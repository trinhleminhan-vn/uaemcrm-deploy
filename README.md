# UAEM CRM — Cài đặt & Cập nhật (self-host)

Hướng dẫn cài UAEM CRM lên VPS của bạn bằng Docker. Bạn chỉ cần thư mục `release/` này (3-4 file),
**không cần mã nguồn**.

## Yêu cầu (chuẩn bị 3 thứ)
1. **1 VPS** Ubuntu 22.04/24.04 (khuyến nghị 2–4 vCPU, 4 GB RAM, 60 GB SSD).
2. **2 tên miền** trỏ A record về IP VPS: 1 cho app (vd `crm.tencongty.com`), 1 cho kho file (vd `files.tencongty.com`).
3. Cổng **80 + 443** mở (để cấp HTTPS tự động).

> Không cần tự cài Docker — script sẽ hỏi và cài giúp nếu thiếu.

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
- Không lên HTTPS: kiểm tra A record đã trỏ đúng IP, cổng 80/443 mở, `docker compose -p uaemcrm logs caddy`.
- App lỗi: `docker compose -p uaemcrm logs app`. Khởi động lại: `docker compose -p uaemcrm restart app`.
- Quên đổi domain: sửa `.env` rồi chạy lại `./install.sh`.
