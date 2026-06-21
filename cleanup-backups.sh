#!/usr/bin/env bash
# cleanup-backups.sh — Dọn các bản sao lưu ROLLBACK cũ do update.sh tạo (backups/db-*.sql.gz).
#
# Các bản này là điểm rollback khi cập nhật (pg_dump nén, CHỈ DB) — KHÁC với bản sao lưu
# đầy đủ (kèm media, mã hoá) quản lý trong app ở Cài đặt → Sao lưu & Khôi phục.
#
# Dùng:
#   ./cleanup-backups.sh           # giữ 7 bản mới nhất (hoặc BACKUP_KEEP trong .env)
#   ./cleanup-backups.sh 3         # giữ 3 bản mới nhất
#   ./cleanup-backups.sh 0         # xoá HẾT (cẩn thận — mất hết điểm rollback)
set -euo pipefail
cd "$(dirname "$0")"

KEEP="${1:-}"
[ -n "$KEEP" ] || KEEP=$(grep -E '^BACKUP_KEEP=' .env 2>/dev/null | cut -d= -f2- || true)
KEEP=${KEEP:-7}
case "$KEEP" in (*[!0-9]*|'') echo "❌ Số bản giữ phải là số nguyên ≥ 0."; exit 1;; esac

mkdir -p backups
TOTAL=$(ls -1 backups/db-*.sql.gz 2>/dev/null | wc -l | tr -d ' ')
echo "════════════════════════════════════════════"
echo "  Dọn bản rollback (backups/db-*.sql.gz)"
echo "  Tổng hiện có: ${TOTAL}  ·  Giữ lại: ${KEEP} mới nhất"
echo "════════════════════════════════════════════"

OLD=$(ls -t backups/db-*.sql.gz 2>/dev/null | tail -n +"$((KEEP + 1))" || true)
if [ -z "$OLD" ]; then
  echo "✓ Không có bản nào cần xoá."
  exit 0
fi

FREED=0
echo "$OLD" | while IFS= read -r f; do
  [ -n "$f" ] || continue
  echo "   xoá $f ($(du -h "$f" 2>/dev/null | cut -f1))"
  rm -f "$f"
done
REMAIN=$(ls -1 backups/db-*.sql.gz 2>/dev/null | wc -l | tr -d ' ')
echo "✓ Xong. Còn lại ${REMAIN} bản mới nhất."
