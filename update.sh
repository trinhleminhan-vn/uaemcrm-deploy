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

# 3) Kéo image mới + khởi động (migration AN TOÀN tự chạy khi container start)
USE_CADDY=""
grep -qE '^APP_DOMAIN=.*yourdomain\.com' .env || USE_CADDY="--profile caddy"
echo "→ Kéo image mới..."
docker compose pull app
echo "→ Áp phiên bản mới (migration tự chạy, không mất dữ liệu)..."
# shellcheck disable=SC2086
docker compose -p uaemcrm ${USE_CADDY} up -d

# 4) Dọn image cũ
docker image prune -f >/dev/null 2>&1 || true

echo "════════════════════════════════════════════"
echo "✅ Đã cập nhật. Kiểm tra: docker compose -p uaemcrm ps"
echo "   Log: docker compose -p uaemcrm logs -f app"
echo "   Backup (điểm rollback): backups/db-${STAMP}.sql.gz"
echo "   Nếu cần lùi: đổi UAEMCRM_IMAGE về tag cũ trong .env → ./update.sh; (nặng) nạp lại backup nếu schema đã đổi."
echo "════════════════════════════════════════════"
