#!/usr/bin/env bash
# update.sh — Cập nhật UAEM CRM lên phiên bản mới (AN TOÀN: backup DB trước).
# Dùng: ./update.sh           (lấy tag trong .env, vd :latest hoặc :3.4.0)
#       ./update.sh 3.4.0     (ép cập nhật lên tag cụ thể)
set -euo pipefail
cd "$(dirname "$0")"

echo "════════════════════════════════════════════"
echo "  UAEM CRM — Cập nhật"
echo "════════════════════════════════════════════"
echo "Phiên bản hiện tại (theo .env): $(grep -E '^UAEMCRM_IMAGE=' .env | cut -d= -f2- || echo '?')"

# 1) Nếu truyền tag → đổi UAEMCRM_IMAGE trong .env
if [ "${1:-}" != "" ]; then
  base=$(grep -E '^UAEMCRM_IMAGE=' .env | cut -d= -f2- | sed 's/:[^:]*$//')
  sed -i.bak "s|^UAEMCRM_IMAGE=.*|UAEMCRM_IMAGE=${base}:${1}|" .env && rm -f .env.bak
  echo "→ Đặt image: ${base}:${1}"
fi

# 2) BACKUP DB trước khi cập nhật (bắt buộc)
mkdir -p backups
STAMP=$(date +%Y%m%d-%H%M%S)
DB_USER=$(grep -E '^DB_USER=' .env | cut -d= -f2- || echo crmuser)
DB_NAME=$(grep -E '^DB_NAME=' .env | cut -d= -f2- || echo uaemcrm)
echo "→ Backup DB → backups/db-${STAMP}.sql.gz"
docker compose -p uaemcrm exec -T db pg_dump -U "${DB_USER:-crmuser}" "${DB_NAME:-uaemcrm}" | gzip > "backups/db-${STAMP}.sql.gz"
echo "  ✓ backup xong ($(du -h "backups/db-${STAMP}.sql.gz" | cut -f1))"

# 2b) TỰ DỌN bản rollback cũ — chỉ giữ N bản mới nhất (mặc định 7; đổi qua BACKUP_KEEP trong .env).
#     Tránh cập nhật nhiều lần làm phình thư mục backups/.
KEEP=$(grep -E '^BACKUP_KEEP=' .env 2>/dev/null | cut -d= -f2- || true); KEEP=${KEEP:-7}
OLD=$(ls -t backups/db-*.sql.gz 2>/dev/null | tail -n +"$((KEEP + 1))" || true)
if [ -n "$OLD" ]; then
  echo "→ Dọn bản rollback cũ (giữ ${KEEP} mới nhất):"
  echo "$OLD" | while IFS= read -r f; do [ -n "$f" ] && { echo "   xoá $f"; rm -f "$f"; }; done
fi

# 3) Cập nhật file compose từ repo deploy (để nhận thay đổi compose của bản mới)
BASE="${DEPLOY_BASE_URL:-https://raw.githubusercontent.com/trinhleminhan-vn/uaemcrm-deploy/main}"
for f in docker-compose.yml docker-compose.proxy.yml Caddyfile auto-update.sh cleanup-backups.sh; do
  curl -fsSL "$BASE/$f" -o "$f" 2>/dev/null || true
done
chmod +x auto-update.sh cleanup-backups.sh 2>/dev/null || true
# Tự cập nhật CHÍNH update.sh — tải về bản tạm, THAY ở cuối script (tránh ghi đè khi đang chạy);
# áp dụng từ lần chạy kế tiếp.
curl -fsSL "$BASE/update.sh" -o ".update.sh.next" 2>/dev/null && [ -s .update.sh.next ] || rm -f .update.sh.next
# Đăng ký tác vụ tự-động-cập-nhật (idempotent) — chỉ thực sự chạy khi BẬT toggle trong app.
if command -v crontab >/dev/null 2>&1; then
  _DIR="$(pwd)"
  _LINE="*/5 * * * * cd $_DIR && ./auto-update.sh >> $_DIR/auto-update.log 2>&1"
  ( crontab -l 2>/dev/null | grep -v 'auto-update.sh'; echo "$_LINE" ) | crontab - 2>/dev/null || true
fi

# 4) Kéo image mới + khởi động đúng CHẾ ĐỘ (caddy / proxy ngoài). Migration tự áp khi start.
MODE=$(grep -E '^DEPLOY_MODE=' .env | cut -d= -f2- || echo caddy)
echo "→ Kéo image mới..."
docker compose pull app
echo "→ Áp phiên bản mới (chế độ: $MODE — migration tự chạy, không mất dữ liệu)..."
if [ "$MODE" = "caddy" ]; then
  docker compose -p uaemcrm --profile caddy up -d
else
  docker compose -f docker-compose.yml -f docker-compose.proxy.yml -p uaemcrm up -d
fi

docker image prune -f >/dev/null 2>&1 || true

echo "════════════════════════════════════════════"
echo "✅ Đã cập nhật. Kiểm tra: docker compose -p uaemcrm ps"
echo "   Log: docker compose -p uaemcrm logs -f app"
echo "   Backup (điểm rollback): backups/db-${STAMP}.sql.gz"
echo "   Nếu cần lùi: đổi UAEMCRM_IMAGE về tag cũ trong .env → ./update.sh; (nặng) nạp lại backup nếu schema đã đổi."
echo "════════════════════════════════════════════"

# Thay update.sh bằng bản mới đã tải (nếu có) — bước CUỐI cùng để không hỏng lần chạy hiện tại.
[ -f .update.sh.next ] && mv -f .update.sh.next update.sh && chmod +x update.sh 2>/dev/null || true
