#!/usr/bin/env bash
# auto-update.sh — Cập nhật theo (1) nút "Cập nhật ngay" trong app, hoặc
# (2) toggle "Tự động cập nhật" BẬT + có bản mới.
# install.sh/update.sh đăng ký chạy định kỳ (mỗi 5 phút). An toàn: ./update.sh tự backup DB.
set -euo pipefail
cd "$(dirname "$0")"

# Hỏi app (qua container) trạng thái cập nhật. App nội bộ cổng 3000.
JSON=$(docker exec uaemcrm-app wget -qO- http://127.0.0.1:3000/api/v1/system/update-check 2>/dev/null || echo '{}')

REQ=$(echo "$JSON" | grep -o '"updateRequested":"[^"]*"' | cut -d'"' -f4 || true)
LATEST=$(echo "$JSON" | grep -o '"latest":"[^"]*"' | cut -d'"' -f4 || true)

# 1) Người dùng bấm "Cập nhật ngay" trong app → cập nhật tới version yêu cầu.
if [ -n "${REQ:-}" ]; then
  echo "[auto-update] $(date '+%F %T') yêu cầu cập nhật ngay → ${REQ}"
  ./update.sh "$REQ"
  exit 0
fi

# 2) Toggle tự-động BẬT + có bản mới → cập nhật.
echo "$JSON" | grep -q '"autoUpdate":true' || { exit 0; }
echo "$JSON" | grep -q '"updateAvailable":true' || { exit 0; }
echo "[auto-update] $(date '+%F %T') tự động cập nhật → ${LATEST:-latest}"
if [ -n "${LATEST:-}" ]; then ./update.sh "$LATEST"; else ./update.sh; fi
