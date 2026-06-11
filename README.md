# UAEM CRM — Cài đặt & Cập nhật (self-host)

Hướng dẫn cài UAEM CRM lên VPS của bạn bằng Docker. Bạn chỉ cần thư mục `release/` này (3-4 file),
**không cần mã nguồn**.

## Yêu cầu hệ thống
| Mục | Tối thiểu | Khuyến nghị |
|---|---|---|
| Hệ điều hành | Linux x86_64 | **Ubuntu 22.04 / 24.04** (hoặc Debian 12) |
| CPU | 2 vCPU | 2–4 vCPU |
| RAM | 2 GB (+ swap) | **4 GB** |
| Ổ đĩa | 30 GB SSD | 60–80 GB SSD (lưu ảnh/file lâu dài) |
| Khác | Docker (script tự cài nếu thiếu) | — |

**Cần chuẩn bị:**
1. **2 tên miền** trỏ A record về IP VPS: 1 cho app (vd `crm.tencongty.com`), 1 cho kho file (vd `files.tencongty.com`).
2. Nếu dùng HTTPS tích hợp (Caddy): cổng **80 + 443** trống. *Đã có web/proxy chiếm 80/443? → dùng chế độ "proxy có sẵn" (xem dưới).*

> Không cần tự cài Docker — script sẽ hỏi và cài giúp. Các dịch vụ phụ (Postgres/Redis/MinIO) chạy **trong Docker,
> KHÔNG mở cổng host** → không đụng dịch vụ sẵn có trên máy bạn.

## Cài đặt — chỉ 1 lệnh

SSH vào VPS rồi chạy:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/trinhleminhan-vn/uaemcrm-deploy/main/install.sh)
```
Script sẽ: cài Docker (nếu thiếu) → **hỏi 2 tên miền** → **tự sinh mọi mật khẩu/secret** → kéo image → bật
**HTTPS tự động** (Caddy + Let's Encrypt) → khởi động. Xong, mở `https://crm.tencongty.com` → trang **Thiết lập**
tạo tổ chức + tài khoản chủ.

> Lần đầu Caddy cấp chứng chỉ ~1 phút. Đảm bảo domain đã trỏ đúng IP và cổng 80/443 mở.

<details><summary>Cách thủ công (nếu không dùng 1 lệnh)</summary>

Tải `docker-compose.yml`, `Caddyfile`, `.env.example`, `install.sh`, `update.sh` về 1 thư mục rồi:
```bash
cp .env.example .env && nano .env   # điền APP_DOMAIN/S3_DOMAIN/APP_URL/S3_PUBLIC_URL
chmod +x install.sh && ./install.sh
```
</details>

## Tên miền, cổng & reverse proxy

Khi cài, script hỏi bạn chọn **1 trong 2 cách truy cập**:

**1) Caddy tích hợp (mặc định, dễ nhất)** — tự cấp HTTPS (Let's Encrypt). Caddy chiếm cổng **80 + 443**.
Hợp khi VPS chưa có web/proxy nào khác.

**2) Dùng reverse proxy SẴN CÓ của bạn** (nginx / Caddy / Traefik / Cloudflare Tunnel…) — chọn khi:
- Cổng 80/443 **đã bị web khác chiếm** (script tự phát hiện và gợi ý chế độ này), hoặc
- Bạn muốn quản lý HTTPS bằng proxy riêng.

Ở chế độ này app mở **2 cổng host** (mặc định `127.0.0.1:3000` cho app, `127.0.0.1:9000` cho kho file) để proxy
của bạn trỏ vào — **cổng tuỳ chỉnh được** khi cài. Bạn cấu hình proxy (HTTPS):
```
crm.tencongty.com    →  http://127.0.0.1:3000     (app)
files.tencongty.com  →  http://127.0.0.1:9000     (kho file / S3 — cần cho ảnh hiển thị)
```
Proxy chạy ở **máy khác**? đặt `APP_BIND=0.0.0.0` và `S3_BIND=0.0.0.0` trong `.env` (và tự lo tường lửa).

> Đổi cổng/chế độ sau khi cài: sửa `.env` (APP_PORT/S3_PORT/DEPLOY_MODE) rồi chạy lại `./install.sh`.
> Lệnh chạy chế độ proxy thủ công: `docker compose -f docker-compose.yml -f docker-compose.proxy.yml -p uaemcrm up -d`.

## Cập nhật phiên bản mới — chỉ 1 lệnh

Khi nhà cung cấp ra bản mới:
```bash
cd ~/uaemcrm && ./update.sh        # lên bản mới nhất
# hoặc ghim đúng 1 phiên bản:
./update.sh 3.4.0
```
`update.sh` **tự backup database trước** → kéo image mới → áp **migration an toàn (không mất dữ liệu)** → khởi động lại.

**Nguyên tắc vì sao update an toàn:** dữ liệu của bạn (DB, ảnh/file) nằm trong *Docker volume* **tách rời image** —
update chỉ thay phần code (image), volume giữ nguyên. Migration chỉ **thêm** thay đổi schema còn thiếu, không xoá dữ liệu.

## Vận hành nhanh
```bash
docker compose -p uaemcrm ps                 # trạng thái
docker compose -p uaemcrm logs -f app        # xem log app
docker compose -p uaemcrm --profile caddy restart caddy   # khởi động lại proxy
docker compose -p uaemcrm --profile backup up -d          # bật backup DB định kỳ (hằng ngày)
```

## Sao lưu dữ liệu
- Trong app: **Cài đặt → Sao lưu & Khôi phục** (gói `.tar.gz` gồm DB + ảnh/file; có thể đẩy lên Google Drive).
- Tự động: bật service backup (lệnh trên) hoặc `update.sh` luôn backup trước mỗi lần cập nhật.

## Khắc phục sự cố
- **Cổng 80/443 đã bận**: chọn chế độ "reverse proxy sẵn có" khi cài (xem mục trên) — không cần Caddy.
- **Không lên HTTPS (Caddy)**: kiểm tra A record đã trỏ đúng IP, cổng 80/443 mở, `docker compose -p uaemcrm logs caddy`.
- **Ảnh không hiển thị**: kho file (S3_DOMAIN) phải truy cập được qua HTTPS — kiểm tra proxy/domain `files....`.
- **App lỗi**: `docker compose -p uaemcrm logs app`. Khởi động lại: `docker compose -p uaemcrm restart app`.
- **Đổi domain/cổng**: sửa `.env` rồi chạy lại `./install.sh`.
- **Cần xem DB**: `docker compose -p uaemcrm exec db psql -U crmuser uaemcrm` (DB không mở cổng host).
