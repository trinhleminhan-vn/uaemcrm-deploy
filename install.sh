#!/usr/bin/env bash
# install.sh — Cài UAEM CRM trên VPS (kiểu 1 lệnh, tự tải cấu hình + hỏi đáp).
#   bash <(curl -fsSL https://raw.githubusercontent.com/trinhleminhan-vn/uaemcrm-deploy/main/install.sh)
set -euo pipefail

DEPLOY_BASE_URL="${DEPLOY_BASE_URL:-https://raw.githubusercontent.com/trinhleminhan-vn/uaemcrm-deploy/main}"
DIR="${INSTALL_DIR:-$HOME/uaemcrm}"

echo "════════════════════════════════════════════"
echo "  UAEM CRM — Cài đặt"
echo "════════════════════════════════════════════"

# ── Yêu cầu hệ thống (kiểm tra + khuyến nghị) ─────────────────────────────────
#   HĐH: Linux x86_64 (khuyến nghị Ubuntu 22.04/24.04 hoặc Debian 12). Cần Docker.
#   Khuyến nghị: 2–4 vCPU, 4 GB RAM, 60 GB SSD. Tối thiểu: 2 GB RAM (+swap).
if command -v free >/dev/null 2>&1; then
  RAM_MB=$(free -m | awk '/^Mem:/{print $2}')
  if [ "${RAM_MB:-0}" -lt 1800 ]; then
    echo "⚠ RAM chỉ ${RAM_MB}MB (khuyến nghị ≥4GB, tối thiểu 2GB + swap). Có thể chậm/đầy bộ nhớ."
    read -rp "  Vẫn tiếp tục? [y/N] " a; [[ "${a:-N}" =~ ^[Yy]$ ]] || exit 1
  fi
fi
[ "$(uname -s)" = "Linux" ] || { echo "❌ Chỉ chạy trên Linux VPS."; exit 1; }

# ── Docker (tự cài nếu thiếu) ─────────────────────────────────────────────────
if ! command -v docker >/dev/null 2>&1; then
  read -rp "Chưa có Docker. Cài tự động bây giờ? [Y/n] " a
  [[ "${a:-Y}" =~ ^[Yy]?$ ]] && curl -fsSL https://get.docker.com | sh || { echo "❌ Hãy cài Docker rồi chạy lại."; exit 1; }
fi
docker compose version >/dev/null 2>&1 || { echo "❌ Cần Docker Compose v2."; exit 1; }
command -v openssl >/dev/null 2>&1 || { echo "❌ Cần openssl."; exit 1; }

mkdir -p "$DIR"; cd "$DIR"
echo "→ Thư mục cài đặt: $DIR"

# ── Tải file cấu hình nếu thiếu ───────────────────────────────────────────────
for f in docker-compose.yml docker-compose.proxy.yml Caddyfile .env.example update.sh auto-update.sh cleanup-backups.sh; do
  [ -f "$f" ] || { echo "→ Tải $f"; curl -fsSL "$DEPLOY_BASE_URL/$f" -o "$f"; }
done
chmod +x update.sh auto-update.sh cleanup-backups.sh 2>/dev/null || true
[ -f .env ] || cp .env.example .env

setkv() { sed -i.bak "s|^$1=.*|$1=$2|" .env && rm -f .env.bak; }
val()   { grep -E "^$1=" .env | head -1 | cut -d= -f2- || true; }
port_busy() { command -v ss >/dev/null 2>&1 && [ -n "$(ss -ltnH "sport = :$1" 2>/dev/null)" ]; }

# ── Domain ────────────────────────────────────────────────────────────────────
if grep -qE '^APP_DOMAIN=.*yourdomain' .env; then
  echo "Nhập 2 tên miền (đã trỏ A record về IP VPS này):"
  read -rp "  • Tên miền ứng dụng (vd crm.tencongty.com): " APP_D
  read -rp "  • Tên miền kho file/ảnh (vd files.tencongty.com): " S3_D
  setkv APP_DOMAIN "$APP_D"; setkv S3_DOMAIN "$S3_D"
  setkv APP_URL "https://$APP_D"; setkv S3_PUBLIC_URL "https://$S3_D"
fi

# ── Chọn chế độ HTTPS / reverse proxy ─────────────────────────────────────────
# Caddy (mặc định) cần 80+443 trống. Nếu bận hoặc đã có proxy riêng → chế độ external.
MODE="caddy"
if port_busy 80 || port_busy 443; then
  echo "⚠ Phát hiện cổng 80 hoặc 443 ĐANG BẬN (có proxy/web khác?) → không dùng được Caddy tích hợp."
  MODE="external"
fi
echo "Chọn cách truy cập HTTPS:"
echo "  1) Caddy tích hợp — tự cấp HTTPS (cần 80+443 trống)$( [ "$MODE" = external ] && echo ' [đang bận]')"
echo "  2) Dùng reverse proxy SẴN CÓ của bạn (nginx/Caddy/Cloudflare…) — app mở 1 cổng host"
read -rp "  Chọn [1/2] (mặc định $( [ "$MODE" = caddy ] && echo 1 || echo 2)): " c
case "${c:-}" in
  1) MODE="caddy" ;;
  2) MODE="external" ;;
  "") : ;;  # giữ mặc định theo phát hiện cổng
esac

if [ "$MODE" = "external" ]; then
  cur_port="$(val APP_PORT)"; cur_port="${cur_port:-3000}"
  read -rp "  Cổng host cho app (proxy của bạn trỏ vào) [mặc định $cur_port]: " p
  setkv APP_PORT "${p:-$cur_port}"
  cur_s3="$(val S3_PORT)"; cur_s3="${cur_s3:-9000}"
  read -rp "  Cổng host cho kho file (S3) [mặc định $cur_s3]: " ps
  setkv S3_PORT "${ps:-$cur_s3}"
fi

# Lưu chế độ để update.sh dùng đúng
grep -qE '^DEPLOY_MODE=' .env && setkv DEPLOY_MODE "$MODE" || echo "DEPLOY_MODE=$MODE" >> .env

# ── Tự sinh secret còn trống ──────────────────────────────────────────────────
gen() { [ -z "$(val "$1")" ] && { setkv "$1" "$2"; echo "  + đã sinh $1"; }; return 0; }
gen JWT_SECRET          "$(openssl rand -hex 32)"
gen ENCRYPTION_KEY      "$(openssl rand -hex 32)"
gen DB_PASSWORD         "$(openssl rand -hex 16)"
gen MINIO_ROOT_USER     "minio_$(openssl rand -hex 4)"
gen MINIO_ROOT_PASSWORD "$(openssl rand -hex 24)"

# ── Kéo image ─────────────────────────────────────────────────────────────────
echo "→ Kéo image..."
if ! docker compose pull 2>/tmp/uaemcrm_pull.log; then
  if grep -qiE 'denied|unauthorized|forbidden' /tmp/uaemcrm_pull.log; then
    echo "⚠ Không kéo được image (registry private). Đăng nhập trước:"
    echo "   echo <TOKEN_read:packages> | docker login ghcr.io -u <user> --password-stdin"
    echo "   rồi chạy lại ./install.sh"; exit 1
  fi
  cat /tmp/uaemcrm_pull.log; exit 1
fi

# ── Khởi động theo chế độ ─────────────────────────────────────────────────────
echo "→ Khởi động (chế độ: $MODE)..."
if [ "$MODE" = "caddy" ]; then
  docker compose -p uaemcrm --profile caddy up -d
else
  docker compose -f docker-compose.yml -f docker-compose.proxy.yml -p uaemcrm up -d
fi

# ── Đăng ký tác vụ tự-động-cập-nhật (chỉ chạy khi BẬT toggle trong app) ───────
chmod +x auto-update.sh 2>/dev/null || true
if command -v crontab >/dev/null 2>&1; then
  _DIR="$(cd "$(dirname "$0")" && pwd)"
  _LINE="*/5 * * * * cd $_DIR && ./auto-update.sh >> $_DIR/auto-update.log 2>&1"
  ( crontab -l 2>/dev/null | grep -v 'auto-update.sh'; echo "$_LINE" ) | crontab - 2>/dev/null \
    && echo "→ Đã đăng ký tác vụ cập nhật (kiểm tra mỗi 5 phút; chỉ chạy khi bạn bấm 'Cập nhật ngay' hoặc BẬT tự-động trong Cài đặt → Phiên bản & Cập nhật)." || true
fi

echo "════════════════════════════════════════════"
echo "✅ Hoàn tất. Kiểm tra: docker compose -p uaemcrm ps"
if [ "$MODE" = "caddy" ]; then
  echo "🌐 Mở: $(val APP_URL)   (Caddy tự cấp HTTPS, lần đầu ~1 phút)"
else
  echo "🌐 Chế độ proxy ngoài. App đang ở 127.0.0.1:$(val APP_PORT), kho file ở 127.0.0.1:$(val S3_PORT)."
  echo "   → Trỏ reverse proxy của bạn (HTTPS):"
  echo "       $(val APP_DOMAIN)  →  http://127.0.0.1:$(val APP_PORT)"
  echo "       $(val S3_DOMAIN)   →  http://127.0.0.1:$(val S3_PORT)"
  echo "   (Proxy ở máy khác? đặt APP_BIND/S3_BIND=0.0.0.0 trong .env rồi chạy lại.)"
fi
echo "📒 Lần đầu mở web → trang Thiết lập (tạo tổ chức + tài khoản chủ)."
echo "🔄 Cập nhật sau này: ./update.sh"
echo "════════════════════════════════════════════"
