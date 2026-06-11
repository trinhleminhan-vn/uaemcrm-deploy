#!/usr/bin/env bash
# install.sh — Cài UAEM CRM trên VPS. Chạy được kiểu "1 lệnh":
#   bash <(curl -fsSL https://raw.githubusercontent.com/trinhleminhan-vn/uaemcrm-deploy/main/install.sh)
# Tự tải cấu hình, hỏi tên miền, sinh secret, bật HTTPS, khởi động.
set -euo pipefail

# Nơi tải file cấu hình (đổi nếu repo deploy của bạn khác).
DEPLOY_BASE_URL="${DEPLOY_BASE_URL:-https://raw.githubusercontent.com/trinhleminhan-vn/uaemcrm-deploy/main}"
DIR="${INSTALL_DIR:-$HOME/uaemcrm}"

echo "════════════════════════════════════════════"
echo "  UAEM CRM — Cài đặt"
echo "════════════════════════════════════════════"

# 1) Docker (tự cài nếu thiếu)
if ! command -v docker >/dev/null 2>&1; then
  read -rp "Chưa có Docker. Cài tự động bây giờ? [Y/n] " a
  if [[ "${a:-Y}" =~ ^[Yy]?$ ]]; then
    curl -fsSL https://get.docker.com | sh
  else
    echo "❌ Hãy cài Docker rồi chạy lại: https://docs.docker.com/engine/install/"; exit 1
  fi
fi
docker compose version >/dev/null 2>&1 || { echo "❌ Cần Docker Compose v2."; exit 1; }
command -v openssl >/dev/null 2>&1 || { echo "❌ Cần openssl."; exit 1; }

mkdir -p "$DIR"; cd "$DIR"
echo "→ Thư mục cài đặt: $DIR"

# 2) Tải các file cấu hình nếu thiếu
for f in docker-compose.yml Caddyfile .env.example; do
  if [ ! -f "$f" ]; then echo "→ Tải $f"; curl -fsSL "$DEPLOY_BASE_URL/$f" -o "$f"; fi
done
[ -f .env ] || cp .env.example .env

setkv() { sed -i.bak "s|^$1=.*|$1=$2|" .env && rm -f .env.bak; }
val() { grep -E "^$1=" .env | head -1 | cut -d= -f2- || true; }

# 3) Hỏi tên miền nếu còn để mặc định
if grep -qE '^APP_DOMAIN=.*yourdomain' .env; then
  echo "Nhập 2 tên miền (đã trỏ A record về IP VPS này):"
  read -rp "  • Tên miền ứng dụng (vd crm.tencongty.com): " APP_D
  read -rp "  • Tên miền kho file/ảnh (vd files.tencongty.com): " S3_D
  setkv APP_DOMAIN "$APP_D";  setkv S3_DOMAIN "$S3_D"
  setkv APP_URL "https://$APP_D";  setkv S3_PUBLIC_URL "https://$S3_D"
fi

# 4) Tự sinh secret còn trống
gen() { [ -z "$(val "$1")" ] && { setkv "$1" "$2"; echo "  + đã sinh $1"; }; return 0; }
gen JWT_SECRET          "$(openssl rand -hex 32)"
gen ENCRYPTION_KEY      "$(openssl rand -hex 32)"
gen DB_PASSWORD         "$(openssl rand -hex 16)"
gen MINIO_ROOT_USER     "minio_$(openssl rand -hex 4)"
gen MINIO_ROOT_PASSWORD "$(openssl rand -hex 24)"

# 5) Quyết định bật Caddy (HTTPS) hay không
USE_CADDY="--profile caddy"
grep -qE '^APP_DOMAIN=.*yourdomain' .env && USE_CADDY=""   # vẫn placeholder → không bật HTTPS

# 6) Kéo image + khởi động
echo "→ Kéo image..."
if ! docker compose pull 2>/tmp/uaemcrm_pull.log; then
  if grep -qiE 'denied|unauthorized|forbidden' /tmp/uaemcrm_pull.log; then
    echo "⚠ Không kéo được image (registry private). Hãy đăng nhập trước:"
    echo "   echo <TOKEN_read:packages> | docker login ghcr.io -u <user> --password-stdin"
    echo "   rồi chạy lại ./install.sh"
    exit 1
  fi
  cat /tmp/uaemcrm_pull.log; exit 1
fi
echo "→ Khởi động..."
# shellcheck disable=SC2086
docker compose -p uaemcrm ${USE_CADDY} up -d

echo "════════════════════════════════════════════"
echo "✅ Hoàn tất. Kiểm tra: docker compose -p uaemcrm ps"
if [ -n "${USE_CADDY}" ]; then
  echo "🌐 Mở: $(val APP_URL)   (Caddy tự cấp HTTPS, lần đầu ~1 phút)"
else
  echo "🌐 Chưa đặt tên miền → chưa bật HTTPS. Sửa .env rồi chạy lại ./install.sh."
fi
echo "📒 Lần đầu mở web → trang Thiết lập (tạo tổ chức + tài khoản chủ)."
echo "🔄 Cập nhật sau này: ./update.sh"
echo "════════════════════════════════════════════"
