# Changelog

Tất cả thay đổi đáng chú ý của UAEM CRM được ghi lại tại đây. Dự án dùng nhánh `main` làm dòng phát hành chính.

Quy ước phiên bản & cách ghi changelog: [docs/van-hanh/phien-ban.md](docs/van-hanh/phien-ban.md).

## [3.38.7] - 2026-06-22
- **HDSD mới "Chia nhân viên & ai thấy hội thoại nào"** (`/hdsd/23-chia-nhan-vien-quyen-xem-hoi-thoai`): hướng
  dẫn A–Z cho người mới — 4 lớp quyết định (nhóm quyền → quyền nick → khoá → phân chia), từng bước tạo nhân
  viên / phân quyền / cấp quyền nick / phân chia / khoá hội thoại, kèm bảng "ai thấy/trả lời", 3 tình huống mẫu
  + checklist. Mỗi bước có **nút bấm thẳng vào trang** tương ứng.
- **HDSD link được vào thẳng trang app:** link nội bộ kiểu `/settings/...` trong tài liệu nay mở đúng trang trên
  domain của khách (trước chỉ điều hướng trong khu /hdsd).

## [3.38.6] - 2026-06-21
- **Frontend quản lý được backup rollback CLI:** trang Sao lưu thêm mục **"Bản rollback khi cập nhật (CLI)"**
  — liệt kê các file `db-*.sql.gz` do `./update.sh` tạo (mount `./backups` vào container) + **xoá** ngay trong web
  (owner). Validate tên file nghiêm ngặt (`db-YYYYMMDD-HHMMSS.sql.gz`, chống path traversal). Mục tự ẩn nếu chưa
  mount thư mục. Endpoint: `GET /backup/cli`, `DELETE /backup/cli/:name`. Compose thêm mount + `CLI_BACKUP_DIR`.

## [3.38.5] - 2026-06-21
- **Thư viện — Office (xlsx/docx/pptx) cũng xem TRONG overlay, không mở tab mới:** nhúng Office Online viewer
  (`embed.aspx`) vào iframe overlay. Giờ ảnh/video/pdf/txt/office đều xem ngay trong app; chỉ loại không xem
  được (zip…) mới tải về.

## [3.38.4] - 2026-06-21
- **Thư viện — xem trước NGAY TRONG APP (overlay), không mở tab mới:** bấm ảnh → **lightbox** có nút ‹ › +
  phím mũi tên điều hướng toàn bộ ảnh; bấm **video** → player phát ngay trong overlay; **PDF/txt** → xem trong
  iframe overlay. Office vẫn mở Office Online viewer (không nhúng được). Nhấn vùng tối / Esc / nút ✕ để đóng.

## [3.38.3] - 2026-06-21
- **Thư viện — tab Ảnh: thêm "Tải về" + sửa tên tải "media":** menu ⋮ của ảnh nay có **"Tải về"** (dưới
  "Chuyển tiếp"). Tải ảnh/file không còn ra tên **"media"** — ảnh Zalo không có tên gốc sẽ được đặt
  `zalo-image-<ngày-giờ>.jpg`. Bấm thẳng vào ảnh cũng mở qua URL có tên + đúng content-type (lưu lại tên đẹp).

## [3.38.2] - 2026-06-21
- **Thư viện hội thoại — xem trước VIDEO:** bấm file video (mp4/webm/mov/m4v/ogv) trong tab File giờ **mở phát
  inline** (tab mới, trình duyệt tự play) thay vì tải về. Định dạng không phát được (avi/mkv…) vẫn tải về đúng tên.

## [3.38.1] - 2026-06-21
- **Tinh giản trang Sao lưu & Khôi phục:** mục **"Bảo vệ media cũ"** + **"Sao lưu lên Google Drive (tuỳ chọn)"**
  nay **thu gọn mặc định** (bấm để mở rộng) cho gọn. Bảng **"Các bản sao lưu"** + danh sách **"② Khôi phục"**
  có **cuộn** (max-height) khi nhiều gói; header bảng dính khi cuộn. Thêm nút **"Sao lưu ngay"** ở khối "Sao lưu
  tự động". Trang **Bộ nhớ & Dọn dẹp** bỏ khối "Khôi phục & chuyển VPS" (đã nằm ở trang Sao lưu) cho gọn.

## [3.38.0] - 2026-06-21
- **Backup đổi sang mô hình KHOÁ TỔNG (1 file key + 1 mật khẩu cho MỌI gói):** thay vì mỗi gói 1 file key/mật
  khẩu riêng, cả tổ chức dùng **1 MASTER KEY**. Mục mới **"Mật khẩu & Khoá backup"** (trang Sao lưu) cho:
  **tải FILE KEY tổng** (1 lần, mở mọi gói), **đặt/đổi mật khẩu tổng** (nhập 2 lần + nút hiện/ẩn, có ghi nhận
  "đã đặt mật khẩu" + thời điểm), **quên mật khẩu** → owner đặt lại không cần mật khẩu cũ (dựa `ENCRYPTION_KEY`),
  **đổi FILE KEY (xoay khoá)** → sinh khoá mới + cập nhật mọi gói trên VPS, key cũ hết hiệu lực (tuỳ chọn giữ
  mật khẩu). Bỏ ô mật khẩu/cột "File key" từng gói. Gói cũ (3.37.x) vẫn mở được bằng `ENCRYPTION_KEY` cùng máy.
  Endpoint mới: `GET/POST /backup/master*`. Định dạng: recipient `mk` (MASTER KEY) thay `pw` từng gói — xem
  `docs/van-hanh/backup-format.md`. Đã test round-trip mã hoá (12/12 pass: MK/sys/mật khẩu/xoay khoá).

## [3.37.20] - 2026-06-21
- **Sửa badge mật khẩu + link Drive ở danh sách backup:** GET /backup trả thêm `hasPassword` + `remoteLink` +
  `destination` (trước bị thiếu trong select → badge "🔒/🔑" và link Drive không hiện).

## [3.37.19] - 2026-06-21
- **Rõ ràng mật khẩu backup:** ô mật khẩu chuyển thành **checkbox "Đặt mật khẩu (tuỳ chọn)"** mới hiện (gọn);
  bảng backup hiện badge **"🔒 có mật khẩu" / "🔑 chỉ file key"** cho từng gói (cột Loại). Làm rõ: mật khẩu chỉ
  dùng khi khôi phục NGOÀI hệ thống; gói "chỉ file key" mà gõ mật khẩu sẽ không mở được (dùng file key/ENCRYPTION_KEY).
  Thêm cột DB `has_password` (migration additive).
- **Thư viện File trong tin nhắn — sửa bug bấm/tải:** bấm file giờ **XEM TRƯỚC** (PDF/ảnh inline, Office qua viewer
  Microsoft) thay vì tải; **tải về đúng TÊN GỐC** (hết ra "media"); thêm **"Tải về"** trong menu ⋮ (dưới Chuyển tiếp).

## [3.37.18] - 2026-06-21
- **Gom & thu gọn trang Sao lưu & Khôi phục (IA):** chuyển **"Khôi phục media"** + **"Chuyển VPS (xuất cấu
  hình)"** từ trang Bộ nhớ về đúng trang **Sao lưu & Khôi phục**, chia 2 nhóm rõ **① Sao lưu / ② Khôi phục**.
  Các phần phụ (Hướng dẫn, Chuyển VPS) **thu gọn bấm mới mở** cho đỡ rối. Trang Bộ nhớ chỉ còn **dung lượng +
  dọn dẹp** (có link trỏ sang). Khôi phục media trên web kèm **thanh tiến độ + log lỗi**.

## [3.37.17] - 2026-06-20
- **Khôi phục đúng ngữ cảnh "chuyển VPS" (`--clean`):** `pg_dump` thêm `--clean --if-exists` → gói restore **đè
  được vào DB đã có schema** (vd VPS mới đã chạy migrate), **idempotent**. Đã **test khôi phục cách ly**
  (postgres throwaway): nạp DB trống ra 923 tin/32 hội thoại; dump cũ nạp đè lỗi 442 dòng; dump `--clean` nạp 2
  lần đều 0 lỗi.
- **Khôi phục media trên web có THANH TIẾN ĐỘ + LOG LỖI:** `restore-media` đổi sang **job chạy nền** + endpoint
  `GET /backup/restore-status/:jobId`. Trang Bộ nhớ hiện **% tiến độ theo bước** (giải mã → giải nén → đếm → up
  media x/total) và **log lỗi từng file** nếu có.

## [3.37.16] - 2026-06-20
- **Sửa text giao diện cũ mâu thuẫn mã hoá:** bỏ các câu "giải nén xem ngay / không cần công cụ" (intro +
  footer trang Sao lưu) — gói nay `.tar.gz.enc`, phải có file key/mật khẩu/ENCRYPTION_KEY mới mở.

## [3.37.15] - 2026-06-20
- **Cập nhật hướng dẫn trang Bộ nhớ cho khớp mã hoá:** mục "Khôi phục media" + "Chuyển VPS mới" nay ghi rõ gói
  backup đã mã hoá → khôi phục cùng server tự giải mã bằng `ENCRYPTION_KEY`; chuyển VPS cần mang
  `ENCRYPTION_KEY`/file key/mật khẩu; gói trên Google Drive không kèm file key. (Chỉ sửa chữ.)

## [3.37.14] - 2026-06-20
- **Cấu hình sao lưu tự động (LOCAL) + theo lịch:** thêm khối cấu hình trên trang Sao lưu — bật/tắt, **chọn giờ
  chạy hằng ngày (0–23h)**, **số bản giữ** (tự xoá bản cũ hơn). Cron đổi sang chạy **mỗi giờ + đọc cấu hình theo
  từng tổ chức** (lưu AppSetting, không đổi schema). Endpoint `GET/PUT /api/v1/backup/auto-config`.
- **Duyệt & dọn dẹp backup:** thêm nút **Xoá** mỗi gói (owner, xác nhận 2 lớp, có ghi nhật ký) → `DELETE
  /api/v1/backup/:id`. Bản trên Google Drive (nếu có) vẫn giữ.
- **Hướng dẫn rõ cho khách** trên trang Sao lưu (5 bước: mã hoá · 3 chìa · cất file key · Drive không chứa key ·
  chuyển VPS). Xác nhận: **đẩy Google Drive KHÔNG kèm file key** (lộ Drive vẫn an toàn).

## [3.37.13] - 2026-06-20
- **Sửa khôi phục-media-từ-backup sau khi mã hoá:** gói backup giờ là `.enc` → `restore-media` (trang Bộ nhớ)
  nay **tự giải mã bằng ENCRYPTION_KEY** (recipient `sys`, cùng server → không cần nhập key/mật khẩu) trước khi
  giải nén. Trước fix sẽ lỗi "không giải nén được".
- **Trang Sao lưu: tải FILE KEY + đặt mật khẩu:** thêm ô **mật khẩu backup** (tuỳ chọn) lúc tạo + **tự tải file
  key** sau khi tạo (kèm cảnh báo cất giữ) + nút **"File key"** mỗi dòng để tải lại. Mỗi lần tải key được **ghi
  nhật ký** (lịch sử tải key trong Nhật ký thao tác).

## [3.37.12] - 2026-06-20
- **Mã hoá gói backup (đóng lỗ rò "ai cầm file cũng đọc"):** gói backup giờ là **`.tar.gz.enc` mã hoá
  AES-256-GCM**. Lộ file mà không có chìa = **blob rác vô dụng**. Mở bằng **1 trong 3 chìa** (envelope):
  **FILE KEY** (tải riêng, gated owner) · **MẬT KHẨU** (owner đặt, ≥8 ký tự, scrypt) · **ENCRYPTION_KEY**
  (`.env`, cho auto-backup/restore). Áp cho **mọi** gói (thủ công + cron tự động). Định dạng tự-mô-tả, có
  doc + mẫu Node.js để viết công cụ khôi phục độc lập sau này — xem `docs/van-hanh/backup-format.md`.
- API thêm: `GET /api/v1/backup/:id/keyfile` (tải file key, owner) · `POST /backup/create` nhận `{password}`.

## [3.37.11] - 2026-06-20
- **Sao lưu TỰ ĐỘNG hằng ngày (lưới an toàn bytes):** thêm cron 03:00 gói `.tar.gz` (DB + media từ MinIO) cho
  mỗi tổ chức, giữ 14 gói auto mới nhất (xoá gói auto cũ hơn — không đụng backup thủ công/source). Đây là lớp
  chống mất data thật sự: mất MinIO vẫn restore được. **Thuần thêm — không đổi schema, không migration, không
  ảnh hưởng khách update bản cũ, không mất file đã lưu** (backup chỉ ĐỌC source). Chỉnh qua env
  `BACKUP_CRON_SCHEDULE` / `BACKUP_AUTO_KEEP`.

## [3.37.10] - 2026-06-20
- **Điều tra khôi phục ảnh nhóm:** thử tăng cửa sổ lịch sử 50→500 nhưng phát hiện `getGroupChatHistory` của
  Zalo **trả HTTP 404 bất kể count** → recovery nhóm đang hỏng ở tầng API Zalo (zca-js v2.1.2). Đã giữ count=50;
  cần điều tra/nâng zca-js để recovery nhóm hoạt động lại cho tương lai.

## [3.37.9] - 2026-06-20
- **Sửa Thư viện ảnh không hiện (sau khi khoá bucket):** API `/conversations/:id/media` trước trả URL MinIO
  trực tiếp → bucket PRIVATE nên 403 → ảnh vỡ. Nay **proxify qua URL ký HMAC** → ảnh hiện lại.
- **Thư viện tải ảnh NHỎ cho nhẹ:** thêm `?w=240` → proxy resize ảnh bằng **ffmpeg** (đã có sẵn, không thêm
  thư viện) + cache RAM (LRU 300) → lưới ảnh tải bản thu nhỏ ~vài KB thay vì ảnh full, đỡ tốn băng thông/API.
  Bấm vào vẫn mở ảnh full.

## [3.37.8] - 2026-06-20
- **Biểu cảm hiện TÊN nhân viên (không phải email):** reaction CRM lưu `fullName` thay vì email; popup còn
  resolve `reactorId → tên` nên reaction CŨ (đã lưu email) cũng hiện đúng tên.
- **Gỡ biểu cảm gỡ LUÔN trên Zalo Real:** khi bỏ tim, backend gửi icon rỗng (`Reactions.NONE`) tới Zalo →
  reaction biến mất ở cả CRM lẫn Zalo (trước chỉ gỡ ở CRM, Zalo vẫn còn).

## [3.37.7] - 2026-06-20
- **Biểu cảm hiện ĐÚNG tên người thả:** popup "Biểu cảm" trước luôn hiện "Người dùng" vì API không trả tên.
  Nay trả `reactorName` + `reactorSource` (đã lưu sẵn trong DB) và FE giữ raw rows → hiện đúng tên + "Từ Zalo
  App / Từ CRM".
- **Gỡ bỏ biểu cảm của mình:** bấm lại nút tim (hoặc icon đang chọn) để **bỏ** — trước đây không gỡ được do
  lệch KEY ('heart') vs EMOJI ('❤️') nên không khớp được reaction đang có (luôn thêm, không bao giờ gỡ). (Hiện
  gỡ khỏi CRM; gỡ trên Zalo Real sẽ bổ sung sau khi kiểm chứng SDK.)
- **Tải file từ ô xem trước cũng ra đúng tên gốc:** nút Tải trong modal xem trước trước đây dùng `window.open`
  nên lưu thành "media". Nay dùng alias `/:name` + `<a download>` → đúng tên file gốc.

## [3.37.6] - 2026-06-20
- **Sửa video xem trước bị to vỡ layout:** thêm khung giới hạn cho `<video>` inline (max 280×320, bo góc, giữ
  đúng tỉ lệ) — trước đây thiếu CSS `.chat-video` nên video (nhất là video dọc) render full-size đè layout.
- **Công việc / tiến độ — thu gọn + việc mới lên trên:** danh sách việc mặc định hiện **3 việc mới nhất**
  (sắp xếp việc mới trên cùng), bấm **"Xem thêm N việc"** để mở rộng; tên việc quá dài **cắt gọn 1 dòng**
  (bấm xem đầy đủ) tránh vỡ layout panel.
- **Hoạt động gần đây — thu gọn:** mặc định hiện **4 hoạt động mới nhất**, bấm **"Xem thêm"** để xem hết →
  panel gọn, render nhẹ hơn.
- **Tag Zalo đổi trên app → CRM tự cập nhật (không cần F5):** trước đây nhãn hội thoại chỉ refresh khi **đổi
  hội thoại**; nay refresh thêm khi **quay lại tab CRM** (focus/visible) + poll nhẹ 60s lúc đang xem → đổi tag
  bên app Zalo là CRM hiện đúng trong ~1 phút. (DB vốn đã đồng bộ đúng; lỗi nằm ở UI không tự làm mới.)

## [3.37.5] - 2026-06-20
- **File ảnh/video gửi dạng "file" hiển thị đúng:** ảnh (jpg/png…) Zalo gửi kèm dạng `content_type=file`
  giờ render thành **ẢNH xem ngay** (không còn thẻ "xem/tải"); video (mp4…) render **trình phát `<video>`
  inline**. Tài liệu (xlsx/pdf/doc…) **giữ nguyên thẻ file** như cũ (theo E09 registry). Phân loại theo
  đuôi/mime trong `fileMediaMeta` — không đụng các nhánh ảnh/video/file đang chạy.
- **Tải file ra ĐÚNG tên gốc (sửa triệt để):** chuyển sang `<a download>` (URL proxy cùng origin → trình
  duyệt tôn trọng tên) thay vì `window.open` → hết cảnh tải về tên "media".

## [3.37.4] - 2026-06-20
- **Picker cảm xúc không còn "biến mất khi rê lên":** thêm cầu nối trong suốt lấp khoảng hở giữa picker và
  cụm nút + giữ picker mở khi rê chuột trên cả cụm nút → bấm chọn icon mượt, không rớt hover.
- **Tải file đúng TÊN GỐC:** file tải về mang đúng tên người gửi (qua `Content-Disposition` + alias
  `/api/v1/media/:name?dl=1`) thay vì tên "media". Object lưu theo **UUID** nên không đè khi trùng tên; trình
  duyệt tự thêm `(1),(2)…` khi tải nhiều file trùng tên.
- **Xem video trực tiếp:** bấm thumbnail video mở trình phát ngay (sửa lỗi chỉ nhận URL `http`, nay nhận cả
  URL proxy `/api/…` của bucket private).
- **Bảo mật (xác minh):** link proxy có chữ ký **tự hết hạn ≤2 ngày** (sai chữ ký → 403, hết hạn → 410, liệt
  kê bucket → 403). **Lưu ý:** bucket vẫn cho **tải object ẩn danh** nếu biết đúng key → cần **flip PRIVATE**
  (`mc anonymous set none`) để khoá hẳn truy cập ngoài.

## [3.37.1] - 2026-06-20
- **Proxy ảnh TỰ CHỮA (self-heal):** khi gặp file MinIO đã mất, proxy **tự re-fetch ảnh từ Zalo** (nền) rồi
  lưu lại → ảnh **tự lành** ở lần xem sau (refresh), khỏi bấm tay "Khôi phục ảnh hỏng". Debounce 2 phút/tổ chức.

## [3.37.0] - 2026-06-20

### Security — Khoá kho file: bucket PRIVATE, mọi media qua proxy có chữ ký
- **Vấn đề:** file trong bucket có thể tải nếu biết URL chính xác (ẩn danh) → URL lộ = file lộ vĩnh viễn.
- **Khắc phục:** mọi ảnh/file phục vụ qua **media-proxy có chữ ký HMAC + hạn dùng (làm tròn ngày → cache tốt,
  link lộ tự chết ≤2 ngày)**; backend đọc MinIO bằng **khoá nội bộ** → **bucket chuyển PRIVATE** (bỏ GET ẩn
  danh). Link công khai cũ (kể cả đã lộ) **chết ngay** sau khi flip — vá ngược toàn hệ thống.
- **Không mất tính năng:** ảnh/PDF xem trực tiếp qua proxy; **Office (Excel/Word)** xem qua viewer Microsoft
  bằng URL proxy (alias `/:name` để nhận đúng đuôi file); tải file vẫn được. Gửi file cho khách KHÔNG ảnh hưởng
  (zca-js tải byte trực tiếp lên Zalo, không kéo từ bucket).
- Áp cho cả tin **realtime** (proxify nội dung khi emit socket) + tin **cũ** (rewrite URL lúc tải tin). File cũ
  giữ nguyên trong kho, không mất.

## [3.36.2] - 2026-06-20
- **Thả tim nhanh trên tin nhắn**: mỗi tin có **nút TIM luôn hiện** (mờ → **đỏ** khi đã thả) ở góc dưới mép
  ngoài bubble — **1 chạm thả/gỡ tim** (gửi cảm xúc Zalo thật). **Rê chuột** bung **picker 6 cảm xúc**
  (❤️👍😆😮😭😡); nút **⋮** (chuyển tiếp/sao chép…) hiện khi hover. Thay nút mặt-cười cũ.

## [3.36.1] - 2026-06-20
- **Ô tìm nhân viên (Quyền xem hội thoại) gõ tên để tìm**: đổi sang `v-autocomplete` (giống picker "Nhân viên
  phụ trách") — nhiều nhân viên cũng lọc nhanh, không tràn.
- **Cập nhật HDSD**: thêm/sửa các trang cho khoá hội thoại + tự-động-khoá, chuyển tiếp cá nhân/nhóm + copy số,
  cache-through bộ nhớ + khôi phục ảnh; **trang mới "Trạng thái khách hàng"**. Sửa trang chỉ mục (thêm mục
  19/20/21/22, version 3.36.0) và **sơ đồ dữ liệu** (sửa lỗi mermaid mindmap do dấu ngoặc + bổ sung luồng
  Phân chia/Khoá + Kho media + Công việc).

## [3.36.0] - 2026-06-20

### Added — Tự động khoá hội thoại MỚI (theo từng nick)
- Trong **Phân chia hội thoại → Hội thoại đang khoá**, mỗi nick có tuỳ chọn **Tự động khoá hội thoại mới**:
  **Tắt / Chỉ cá nhân / Chỉ nhóm / Cả hai**. Khi KH/nhóm **chưa từng có trên CRM** nhắn tới, hội thoại tạo ra
  sẽ tự đặt **Hạn chế** (chỉ chủ/admin thấy để triage rồi giao care/viewer). Tin do CRM tự gửi đi không bị khoá.
- Lưu trong `conversationPolicy` per-nick (không cần migration). Mặc định **Tắt** — giữ nguyên hành vi cũ.

## [3.35.1] - 2026-06-20

### Security — Vá lỗ hổng LỘ TOÀN BỘ FILE qua bucket (NGHIÊM TRỌNG)
- **Lỗ hổng:** bucket MinIO đặt chính sách ẩn danh `download` (qua `mc anonymous set download`) **vô tình cấp
  `s3:ListBucket`** → bất kỳ ai mở `https://<s3-domain>/<bucket>/` đều **liệt kê được TOÀN BỘ file** (ảnh chat,
  thẻ chuyển khoản, file khách) rồi tải về. UUID ngẫu nhiên KHÔNG bảo vệ vì listing đang bật.
- **Khắc phục:** đổi sang chính sách ẩn danh **chỉ `s3:GetObject`** (tải theo link chính xác — Zalo CDN vẫn
  lấy được ảnh — nhưng **chặn liệt kê/enumerate**). Đã áp ngay trên bucket live (listing → 403). Sửa
  `minio-init` ở cả `docker-compose.yml` (live) lẫn `release/docker-compose.yml` (khách) để deploy sau không
  mở lại. Upload ẩn danh vẫn TẮT.
- ⚠️ **Khách self-host hiện cũng dính lỗ này** — sau khi sync `release/` lên repo deploy, khách chạy
  `./update.sh` để minio-init áp lại chính sách an toàn (hoặc khoá thủ công bằng `mc anonymous set-json`).
- **Đóng cổng vượt Cloudflare:** `app` và `minio` (S3) trước đây publish `0.0.0.0:3091`/`0.0.0.0:9090` → vào
  thẳng `http://IP:cổng` được, **bỏ qua Cloudflare** (WAF/allow-list IP/HTTPS) và giới hạn IP của nginx. Đã bind
  **`127.0.0.1`** (nginx cùng host vẫn proxy tới được; Zalo CDN tải ảnh qua domain S3). DB/Redis/console MinIO
  vốn đã chỉ `127.0.0.1`.

## [3.35.0] - 2026-06-19

### Added — Lưu ảnh kiểu "Cache-through" (giảm tải đĩa, ảnh đã xem là vĩnh viễn)
- **Hội thoại MỚI** mặc định **không mirror ảnh ngay** (`storeMedia=false`) — giữ link Zalo CDN, nhẹ đĩa. Hội
  thoại **cũ giữ nguyên** (vẫn mirror ngay). Migration chỉ đổi MẶC ĐỊNH, không động hàng hiện có.
- **Cache-through khi xem:** ảnh CDN đi qua **media-proxy**; lần đầu tải thành công → tự **lưu MinIO + đổi nội
  dung tin CDN→MinIO** (chạy nền). Lần sau tải thẳng MinIO, không phụ thuộc CDN hết hạn.
  → Ảnh **được xem ≥1 lần là vĩnh viễn**; ảnh không ai mở thì không tốn đĩa. Text luôn ở DB.
- Hội thoại VIP cần chắc chắn → bật `storeMedia=true` để mirror ngay (không chờ ai xem).

## [3.34.0] - 2026-06-19

### Fixed — Ảnh mất do "Dọn dẹp file mồ côi" xoá nhầm (NGHIÊM TRỌNG)
- **Nguyên nhân thật:** nút **Dọn dẹp file mồ côi** (`/storage/cleanup-orphans`) xoá VĨNH VIỄN object MinIO mà
  bộ dò tham chiếu không thấy. Bộ dò cũ so theo **URL prefix đầy đủ** → bỏ sót khi content escape `\/` hoặc
  host/prefix đổi → object **đang được tin tham chiếu bị coi là mồ côi → xoá** → ảnh hỏng (`NoSuchKey`). MinIO
  vẫn khoẻ (1029 object), chỉ mất lác đác do xoá nhầm. KHÔNG phải lỗi phân quyền.
- **Chống tái diễn:** đổi cách nhận diện tham chiếu sang khớp theo **UUID** của object (token không dấu, không
  bị escape/đổi host) + **không bao giờ xoá object < 2 ngày**. Số "mồ côi" hiển thị giờ = đúng số sẽ xoá.
- **Khôi phục ảnh đã mất:** mở rộng job khôi phục — phát hiện cả tin trỏ object **mất hẳn** (không chỉ 0-byte),
  re-fetch lại từ Zalo (nick đang kết nối, tin còn trên Zalo) rồi mirror lại.
- **Ảnh hỏng hiện gọn:** chỗ ảnh không tải được hiện ô **"Ảnh không tải được"** thay vì icon vỡ / lỗi XML thô.

### Added — Proxy ảnh Zalo CDN (bổ trợ)
- Ảnh **chưa kịp mirror** vẫn trỏ Zalo CDN (chỉ tải được ở trình duyệt đã đăng nhập Zalo) giờ được rewrite sang
  **URL proxy ký HMAC** (`/api/v1/media`) — backend tải hộ → nhân viên khác cũng xem được.

## [3.33.0] - 2026-06-19

### Fixed — Nhân viên (kể cả "chỉ xem") không thấy ảnh trong hội thoại
- **Nguyên nhân (không phải lỗi phân quyền):** ảnh chưa kịp mirror về MinIO vẫn trỏ **Zalo CDN**. Link CDN chỉ
  tải được trong trình duyệt **đã đăng nhập Zalo** (owner) → nhân viên khác (kể cả vai trò "chỉ xem") không có
  cookie Zalo nên ảnh đứt. Rà soát xác nhận các tầng quyền **không** chặn ảnh theo vai trò.
- **Khắc phục — proxy ảnh qua backend:** server tự rewrite URL ảnh/video Zalo CDN trong tin thành **URL proxy
  ký HMAC** (`/api/v1/media`), backend tải hộ rồi stream về → **mọi nhân viên đều xem được ảnh**, không phụ
  thuộc cookie Zalo. Ảnh đã ở MinIO (public) giữ nguyên, không proxy. Chỉ cho proxy host Zalo CDN (chống SSRF),
  link có hạn dùng + chữ ký.

## [3.32.1] - 2026-06-19
- **Chuyển tiếp: sửa list không tự hiện + có avatar + toggle mượt** (kế thừa cách màn Tạo nhóm):
  - Mở hộp thoại là **tự nạp danh bạ ngay** (trước phải bấm "Gợi nhớ" mới render).
  - Mỗi dòng có **avatar** (cá nhân & nhóm).
  - Nút **Tên Zalo / Gợi nhớ** chỉ đổi cách hiển thị (computed client-side) — **không gọi lại API**, đổi tức
    thì, hết lag.

## [3.32.0] - 2026-06-19

### Changed — Chuyển tiếp: tách Cá nhân / Nhóm + gửi có delay
- **Danh sách chuyển tiếp luôn có người để chọn**: tách **2 tab Cá nhân / Nhóm**. Tab Cá nhân lấy từ **danh bạ
  của nick** (kể cả KH chưa từng nhắn 1-1 → tự tạo hội thoại khi gửi), tab Nhóm lấy các nhóm của nick. Trước
  đây chỉ liệt kê hội thoại sẵn có nên nick mới/ít chat thì trống trơn.
- **Tìm theo tên / SĐT / Gợi nhớ** trong tab Cá nhân (+ nút Tên Zalo/Gợi nhớ); tab Nhóm tìm theo tên nhóm.
- **Gửi tuần tự + delay 700ms** giữa các đích khi chọn nhiều → tránh spam / giới hạn gửi của Zalo. Báo kết quả
  "đã chuyển tiếp X/Y đích".

## [3.31.1] - 2026-06-19
- **Nút thao tác hover canh GIỮA theo chiều cao tin**: tin lớn (thẻ chuyển khoản…) nút 😊/⋮ nằm giữa cho cân,
  không dồn lên đỉnh trông rời rạc.

## [3.31.0] - 2026-06-19

### Added / Fixed — Thao tác tin nhắn trực quan + copy số thông minh + tag Zalo bền hơn
- **Nút ⋮ "thao tác khác" khi hover tin**: ngoài nút thả cảm xúc, mỗi tin giờ có thêm nút **⋮** (chuyển tiếp /
  sao chép / trả lời…) hiện cùng lúc khi đưa chuột — khỏi phải nhớ bấm chuột phải. Hai nút xếp dọc, **ôm sát
  mép bubble ở góc trên** (trước đây canh giữa tin cao/rộng nên trôi ra xa, trông rời rạc — đã sửa).
- **Copy số thông minh**: SĐT, số tài khoản ngân hàng, mã/OTP, số tham chiếu… trong tin được **gạch chân nét
  đứt**, bấm là copy ngay (tự bỏ dấu cách/chấm) + báo "Đã copy". Áp cho cả chú thích ảnh/file.
- **Tag Zalo Real bền hơn**: khi gắn/bỏ tag, server kiểm tra phản hồi có thẩm quyền của Zalo; nếu phát hiện
  **ghi hụt do lệch phiên bản** (Zalo nhận nhưng không đổi) thì tự lấy version mới và **ghi lại 1 lần**; vẫn
  hụt thì báo lỗi rõ thay vì im lặng "thành công giả".

## [3.30.0] - 2026-06-19

### Added / Fixed — Chuyển tiếp & tìm kiếm theo "Gợi nhớ"
- **Chuyển tiếp được CẢ cá nhân ↔ nhóm**: trước đây danh sách chuyển tiếp chỉ hiện đúng loại đang lọc ở hộp
  thư (cá nhân→cá nhân). Giờ hộp thoại chuyển tiếp tự tải **toàn bộ** hội thoại trên nick nguồn — cả cá nhân
  lẫn nhóm — nên gửi được cá nhân→nhóm và nhóm→cá nhân.
- **Tìm trong chuyển tiếp**: ô tìm theo tên KH / tên nhóm / SĐT / **gợi nhớ (alias)** + nút đổi **Tên Zalo /
  Gợi nhớ** để dễ nhận đúng người (giống lúc tạo nhóm). Mỗi dòng có nhãn Cá nhân / Nhóm.
- **"Tin nhắn mới" thêm Tên Zalo / Gợi nhớ**: tìm và hiển thị KH theo tên gợi nhớ giống màn tạo nhóm.

## [3.29.1] - 2026-06-19
- **Sửa quyền ngay trong "Hội thoại đang khoá"** (trang Phân chia hội thoại): mỗi dòng thêm nút **Quản lý** →
  mở hộp thoại thêm/bớt người, đổi vai trò Chăm sóc/Chỉ xem, đổi mức Chung/Hạn chế ngay tại chỗ (không phải
  vào từng hội thoại). Lưu xong bảng tự cập nhật.

## [3.29.0] - 2026-06-19

### Added / Changed — Khoá hội thoại: thời gian thực + chặn triệt để + quản lý hàng loạt
- **Áp ngay không cần F5**: khi khoá/mở khoá hoặc thêm/bớt người, hội thoại bị khoá **biến mất tức thì** khỏi
  danh sách của nhân viên không có quyền (qua socket `chat:visibility-change`), đang mở thì tự đóng. Chủ/admin
  luôn thấy đủ.
- **Chặn triệt để mọi tương tác cho "Chỉ xem"**: ngoài gửi tin, server giờ chặn cả thả cảm xúc, gỡ/thu hồi,
  sửa, chuyển tiếp, ghim/bỏ ghim, "đang gõ"… (12 thao tác) — viewer chỉ theo dõi, không lách được.
- **Chọn nhiều nhân viên một lần** khi thêm vào hội thoại khoá (chip multi-select) + chọn vai trò Chăm sóc/Chỉ xem.
- **Tổng quan hội thoại đang khoá** trong trang Phân chia hội thoại: bảng tra cứu ai đang thấy, tìm kiếm, mở
  nhanh, mở khoá.
- **Bàn giao nghỉ việc chuyển trọn quyền**: chuyển cả phân chia (giữ nguyên vai trò care/viewer) lẫn quyền nick
  (ZaloAccountAccess) sang người nhận.

## [3.28.1] - 2026-06-19
- **Khoá ô soạn trực quan cho người "Chỉ xem"**: viewer mở hội thoại thấy ô soạn bị khoá + nhãn "Bạn chỉ có
  quyền theo dõi — không trả lời" (trước chỉ chặn lúc bấm gửi).
- **Bỏ dòng "Xem" trong ma trận Phân chia hội thoại** (đã vô tác dụng, gây hiểu nhầm) — việc THẤY hội thoại
  giờ do "Quyền xem hội thoại" (khoá) lo. Cập nhật chú thích cho rõ.

## [3.28.0] - 2026-06-19

### Added — Khoá hội thoại (VIP/mật) + vai trò Chỉ-xem
- **Khoá từng hội thoại (1-1 & nhóm)**: trong panel hội thoại có khu **"Quyền xem hội thoại"** — chọn
  **Chung** (ai có quyền nick đều thấy) hoặc **Hạn chế (khoá)** (chỉ chủ/admin + người được thêm mới thấy).
- **Vai trò thành viên**: **Chăm sóc** (xem + trả lời) hoặc **Chỉ xem** (theo dõi, không trả lời — bị chặn ở
  server). Khách VIP / nhóm cấp cao → khoá + thêm đúng người.
- **Nhất quán & không lách được**: vá lỗ hổng cũ — `GET hội thoại` + `GET tin nhắn` giờ kiểm tra quyền nick +
  khoá; nhân viên không phải thành viên **không thấy, không gọi API trực tiếp được**.
- Phân tầng rõ: **Quyền nick** (động nick nào) → **Khoá** (thấy hội thoại) → **Phân chia** (trả lời) → Riêng tư.
  Owner/admin thấy hết để quản lý. Chỉ người quản lý (chủ/admin/điều phối) thấy khu cấu hình khoá.

## [3.27.1] - 2026-06-19
- Sửa: dialog cấp quyền nick hiện đúng **tên nhân viên** (trước hiện trống/"chưa đặt tên" do đọc sai trường dữ liệu).

## [3.27.0] - 2026-06-19

### Changed — Giao diện cấp quyền nick + cập nhật HDSD
- **Dialog "Cấp quyền xem nick này" thiết kế lại** (trước đây giao diện rối): có **hướng dẫn rõ** (nhân viên
  chỉ thấy nick khi được thêm + giải thích 3 mức Xem/Chat/Quản lý), danh sách người gọn gàng (avatar + tên +
  email), tên trống có fallback, nhắc tạo nhân viên nếu chưa có.
- **HDSD cập nhật theo tính năng mới:**
  - **02 Tài khoản Zalo**: thêm mục *Cho nhân viên thấy tin nhắn của nick* (mô hình 2 lớp quyền) + **Câu hỏi
    thường gặp**.
  - **Mục mới 21 — Công việc (Task)**: 5 chế độ xem, giao việc nhiều người, trạng thái, gắn nguồn, phân quyền.
  - **11 Phân quyền**: thêm bước *Tạo tài khoản nhân viên* (nút mới) + tài nguyên quyền Công việc.
  - **07 Tự động hoá**: thêm mục *Tự động hoá cho NHÓM Zalo* (rule/broadcast/sequence nhóm).

## [3.26.0] - 2026-06-19

### Fixed — Thêm nút tạo nhân viên
- **Trang Nhân viên (Cài đặt → Nhân viên) giờ có nút "Thêm nhân viên"** (góc trên phải + ở màn hình trống).
  Trước đây chỉ liệt kê/sửa, không có chỗ tạo tài khoản nhân viên mới.
- Dialog tạo: Họ tên · Email đăng nhập · Mật khẩu · chọn **Nhóm quyền** (gán ngay khi tạo, hoặc để gán sau).
- Chỉ owner/admin thấy nút này. Backend đã có sẵn API tạo người dùng từ trước.

## [3.25.0] - 2026-06-19

### Changed — Đợt P3: Trạng thái rõ ràng + Hướng dẫn (tooltip "?")
- **Trạng thái việc trong panel giờ là ô có CHỮ + màu** (○ Cần làm xám · ◐ Đang làm xanh dương · ✓ Xong xanh
  lá) thay vì chỉ ký hiệu khó hiểu — bấm để chuyển vòng, có chú thích khi rê chuột.
- **Nút "?" hướng dẫn** (component dùng chung) gắn ở các chỗ dễ rối: tiêu đề Công việc (giải thích 5 chế độ
  xem + kéo-thả), ô "Giao cho" (ưu tiên NV phụ trách), khu việc trong panel nhóm (cách chuyển trạng thái +
  giao việc), kênh gửi Broadcast (cá nhân vs nhóm).
- Màu sắc thống nhất theo trạng thái xuyên suốt.

## [3.24.0] - 2026-06-19

### Added — Đợt P2: Giao việc thông minh + nhiều người
- **Giao 1 việc cho NHIỀU nhân viên** (trước chỉ 1). Hộp sửa việc có ô "Giao cho" chọn nhiều người
  (chip), thẻ kanban hiện chồng avatar + "+N".
- **Ưu tiên nhân viên phụ trách hội thoại**: khi việc gắn nhóm/khách, danh sách giao việc đưa **người phụ
  trách chính** lên đầu (gắn nhãn "phụ trách chính"), rồi các người phụ trách khác, rồi mới tới NV còn lại.
- **Giao việc ngay trong panel nhóm/khách**: thêm việc tự gợi ý giao cho **người phụ trách hội thoại**;
  mỗi việc bấm vào tên người để đổi người được giao (chọn nhiều).
- Lọc "Của tôi" giờ tính cả việc mình là người phụ trách phụ. (Dashboard tải việc vẫn tính theo người chính.)

## [3.23.0] - 2026-06-19

### Added — Đợt P1: Chi tiết & nguồn công việc
- **Bấm vào việc → xem chi tiết đầy đủ**: ai tạo, lúc nào, và **lịch sử thao tác** (ai/bot làm gì, khi nào —
  có chấm màu phân biệt người/bot/hệ thống).
- **"Gắn với" bấm mở thẳng** hội thoại nhóm/khách liên quan (cả ở thẻ lẫn trong hộp sửa việc).

## [3.22.0] - 2026-06-19

### Added — Đợt T5b: Phân quyền Công việc + T5c: Dashboard tải việc
- **Phân quyền công việc (RBAC)**: thêm tài nguyên **Công việc** vào hệ phân quyền với 5 quyền
  (Truy cập / Thêm / Sửa / Xoá / Xem tất cả). Vào **Cài đặt → Phân quyền** để cấu hình theo nhóm.
- **Không phải ai cũng xoá được nữa**: tạo/sửa/xoá việc đều **kiểm tra quyền** ở server (chặn 403 nếu không
  có quyền) — áp cho cả trang Công việc lẫn việc trong panel nhóm/khách. Nút bị **ẩn** nếu không có quyền.
- **Xoá việc giờ có ghi nhật ký** đầy đủ (trước đây xoá không để lại dấu vết).
- Mặc định: Admin/Trưởng phòng/Marketing = toàn quyền; Sale Senior = xoá được; Sale = tạo/sửa; CEO/HCNS = xem.
- **Dashboard "Tải việc"** (tab mới trong Công việc): mỗi nhân viên 1 thẻ — số việc **cần làm / đang làm /
  đã xong / quá hạn** + danh sách việc đang làm → nhìn 1 phát thấy ai đang bận, ai quá tải.

## [3.21.0] - 2026-06-19

### Changed — Đợt T5a: Hợp nhất Công việc + 3 trạng thái trong nhóm
- **Công việc trong panel nhóm & 1-1 giờ có 3 trạng thái**: Cần làm → **Đang làm** → Hoàn thành (bấm vòng
  qua nút trạng thái). Trước đây chỉ tích xong/chưa, thiếu "đang làm".
- Panel dùng chung **hệ Task mới** (cùng dữ liệu với trang Công việc) — việc tạo trong nhóm **tự gắn nguồn**
  là nhóm đó; hiện người được giao.
- **Trang Công việc**: nguồn (nhóm/khách) của mỗi việc **bấm vào mở thẳng** hội thoại/hồ sơ liên quan.
- **"Công việc" lên menu chính** (cạnh Tự động hoá), không còn nằm trong menu Khách hàng.
- Hành động tự động (rule) tạo việc giờ vào hệ Task mới + hiện trên timeline nhóm.
- Dữ liệu công việc cũ (ConversationTask) được **chuyển sang** hệ Task mới (không mất).

## [3.20.0] - 2026-06-19

### Added — Đợt A7d: Kịch bản (Sequence) drip cho NHÓM
- **Chạy kịch bản chăm sóc cho nhiều nhóm Zalo.** Trong "Kịch bản chăm sóc" (`/automation/bot/sequences`),
  mỗi kịch bản có nút **Chạy cho nhóm** → chọn danh sách nhóm đích → các nhóm trải qua **từng bước có delay**
  (vd: chào → 1 ngày sau ưu đãi → 3 ngày sau nhắc).
- Mỗi nhóm gửi bằng đúng nick là thành viên, **giữ nguyên nick xuyên suốt các bước**. Vẫn áp giới hạn
  tốc độ/nick + khung giờ + giãn cách như sequence cá nhân.
- Chỉ dùng bước **gửi tin (send_message)** cho nhóm (chặn `request_friend` — vô nghĩa với nhóm).
- Tái dùng pipeline campaign→task→worker của A7c (không thêm bảng mới).

> Ghi chú: kích hoạt sequence nhóm theo **sự kiện tự động** (trigger event trong nhóm) là pha sau —
> hiện rule-engine (đợt A7) đã cover phản ứng tức thời "tin nhóm → gắn tag/đổi trạng thái/giao việc…".

## [3.19.0] - 2026-06-19

### Added — Đợt T3+T4: Lịch công việc & Báo cáo năng suất
- **Lịch công việc (tuần)** trong trang Công việc: xem việc có hạn theo 7 ngày, điều hướng tuần trước/sau,
  màu theo độ ưu tiên, đánh dấu quá hạn, bấm mở sửa nhanh.
- **Báo cáo năng suất**: bảng theo nhân viên — số việc **tạo mới / hoàn thành / quá hạn** + **tỷ lệ đúng hạn**
  (thanh tiến độ màu), chọn khoảng thời gian (7/30/90 ngày hoặc tuỳ chỉnh) + tổng hợp toàn đội.
- Trang Công việc giờ có 4 chế độ: Bảng (kanban) · Danh sách · **Lịch** · **Báo cáo**.

## [3.18.0] - 2026-06-18

### Added — Đợt T1: Hệ CÔNG VIỆC (Task) chuyên nghiệp
- **Trang Công việc mới** (menu Khách hàng → Công việc, `/tasks`): quản lý công việc cả đội.
- **Bảng Kanban 3 cột** (Cần làm / Đang làm / Hoàn thành) — **kéo-thả** thẻ đổi trạng thái. Kèm chế độ
  **Danh sách** (bảng) chuyển nhanh.
- Mỗi công việc: tiêu đề, mô tả, **độ ưu tiên** (Thấp/BT/Cao/Khẩn), **trạng thái 3 mức**, **giao nhân viên**,
  **hạn** (cảnh báo quá hạn), gắn tuỳ chọn tới khách/hội thoại/nhóm.
- **Bộ lọc**: của tôi / tất cả / theo nhân viên, theo ưu tiên, quá hạn, tìm theo tiêu đề + thống kê nhanh.
- **Ghi nhật ký hoạt động** (T2): tạo / đổi trạng thái / hoàn thành / giao việc / xoá — hiện ở timeline,
  nhóm chung category "Công việc" (gộp cả checklist hội thoại A4).
- Khác `ConversationTask` (checklist nhanh trong 1 hội thoại) — Task là việc cấp tổ chức, độc lập được.

## [3.17.0] - 2026-06-18

### Added — Đợt A7c: Gửi hàng loạt (Broadcast) tới NHÓM Zalo
- **Broadcast tới nhiều nhóm cùng lúc.** Trong "Gửi hàng loạt & Tiếp thị lại" (`/automation/bot/broadcasts`)
  thêm chọn **Kênh gửi**: Khách hàng (1-1) hoặc **Nhóm Zalo** → chọn danh sách nhóm đích (tìm theo tên/nick).
- Mỗi nhóm gửi bằng đúng nick đang là thành viên (không cần kết bạn). Tận dụng pipeline broadcast sẵn có nên
  vẫn áp **giới hạn tốc độ/nick** (msg/giờ, khung giờ, giãn cách ngẫu nhiên) + retry + tạm dừng/huỷ.
- Tin gửi vào nhóm hiện đúng trong hội thoại (đẩy nhóm lên đầu danh sách), người gửi = `Bot-Auto`.
- **Không đụng luồng broadcast 1-1**: gửi cho khách cá nhân giữ nguyên.

### Kỹ thuật
- `AutomationTask`: `contactId` nullable + thêm `conversationId` (task có thể nhắm hội thoại nhóm).
- Segment mới: `group-manual` (chọn nhóm) / `group-filter` (lọc theo tên). Worker bỏ qua các cổng "bạn bè"
  cho task nhóm; nick gửi lấy sẵn từ hội thoại.

## [3.16.0] - 2026-06-18

### Added — Đợt A7: Tự động hoá (automation) cho NHÓM
- **Rule engine chạy đầy đủ cho hội thoại nhóm.** Trước đây rule chỉ áp được cho KH 1-1 (engine bỏ qua tin
  nhóm vì không có contact). Nay nhóm chạy được mọi hành động ở **cấp hội thoại**, tái dùng lớp CRM A2–A4.
- **Điều kiện mới (rule builder):** Loại hội thoại (user/group), Tên nhóm, Tag hội thoại, Trạng thái hội
  thoại, NV phụ trách hội thoại.
- **Hành động mới cấp hội thoại:** Gắn tag / Gỡ tag / Tạo công việc (task có hạn + giao NV phụ trách).
  Với nhóm: Gán nhân viên, Đổi trạng thái, Gửi template, Tạo lịch hẹn đều áp ở cấp hội thoại.
- Hành động tự động ghi **nhật ký hoạt động** với người thực hiện = bot `Automation` (hiện trên timeline nhóm).
- Rule builder: chọn nhân viên + trạng thái bằng **danh sách thật** của tổ chức (thay vì gõ ID/giá trị cứng).
- **Không đụng luồng 1-1**: hành vi automation cho KH cá nhân giữ nguyên 100%.

## [3.15.1] - 2026-06-18

### Added — Đợt C1: Đồng bộ lớp CRM hội thoại sang panel 1-1
- **Checklist công việc/tiến độ ở panel KH 1-1** (component dùng chung `ConversationTaskList`) — như nhóm.
  Tận dụng `ConversationTask` cấp hội thoại sẵn có. (Trạng thái/tag/ghi chú ở 1-1 vẫn ở cấp KH như cũ để
  tránh nhân đôi gây rối.)

## [3.15.0] - 2026-06-18

### Added — Đợt A6: Nhật ký hoạt động hội thoại (timeline)
- **Ghi log mọi thao tác cấp hội thoại** vào `ActivityLog` (entityType='conversation'): gán/nhận/bỏ phụ trách,
  đổi trạng thái, cập nhật tag, thêm ghi chú, tạo/hoàn thành/mở lại công việc. → lịch sử "ai làm gì, khi nào".
- **Section "Hoạt động gần đây"** trong GroupInfoPanel (tab Thông tin) hiển thị timeline. Route
  `GET /conversations/:id/activity-log`.

## [3.14.0] - 2026-06-18

### Added — Đợt A5: Thư viện nhóm (bảng tin Zalo + media)
- **Tab "Thư viện"** trong GroupInfoPanel: **Bảng tin nhóm** (ghim 📌 / ghi chú 📝 / bình chọn 📊 lấy từ Zalo
  qua `getListBoard`) + **Ảnh/File/Link** đã gửi/nhận (gom từ message theo `contentType`). Route
  `GET /groups/:groupId/board`, `GET /conversations/:id/media?kind=image|file|link`.

### Changed — UX phân công thông minh hơn
- **Menu "Phân chia hội thoại" (chat header)**: ẩn "Nhận về mình" khi hội thoại ĐÃ là của mình (quy tắc ẩn
  tác vụ đã dùng → bớt rối); thêm **ô tìm nhân viên** khi danh sách > 10 người (ít thì không hiện).
- **Gán nhân viên phụ trách (panel nhóm)**: đổi sang **autocomplete tìm được**, tự **ẩn người đã phụ trách**
  khỏi danh sách thêm.

## [3.13.0] - 2026-06-18

### Added — Đợt A3+A4: Lớp CRM cấp hội thoại + Task tiến độ
- **A3 — Trạng thái · Tag · Ghi chú cấp hội thoại** (dùng cho NHÓM "case chăm sóc", và cả 1-1):
  - `Conversation.statusId` (dùng lại Status model) + `Conversation.tags` → đặt trạng thái xử lý + tag cho nhóm.
  - **Ghi chú gắn hội thoại**: `Note.contactId` thành optional + thêm `Note.conversationId` → ghi chú nội bộ
    cho nhóm (không cần KH). Routes `GET/POST /conversations/:id/notes`, `PATCH /conversations/:id/(status|tags)`.
- **A4 — Task/checklist theo dõi tiến độ**: model mới `ConversationTask` (title, done, người làm, hạn) gắn
  hội thoại. Routes `GET/POST /conversations/:id/tasks`, `PATCH/DELETE /conversation-tasks/:id`.
- **GroupInfoPanel tab "Thông tin"** giờ đầy đủ như CRM 1-1: Nhân viên phụ trách (nhiều người) · Trạng thái ·
  Tag · **Công việc/tiến độ (checklist)** · Ghi chú nội bộ.
- Migration `conversation_crm_layer`. Module mới `conversation-crm-routes.ts`.

## [3.12.1] - 2026-06-18

### Added — Đợt A2: Panel nhóm chuyên nghiệp (như 1-1)
- **GroupInfoPanel làm lại có tabs** (Thông tin · Khách hàng · Nhắc hẹn) như panel KH 1-1.
- **Nhiều nhân viên phụ trách nhóm**: panel hiện danh sách người phụ trách + thêm/bỏ ngay (tận dụng
  `ConversationAssignment` multi-assignee sẵn có; conv detail nay trả kèm `assignments`).
- **Map thành viên nhóm ↔ Contact CRM**: tab "Khách hàng" liệt kê từng thành viên Zalo → resolve về
  Friend/Contact theo nick: KH nào đã có trong CRM (tên + trạng thái + điểm + mở hồ sơ), ai chưa có (nút nhắn
  riêng để bắt đầu chăm). Endpoint `GET /groups/:groupId/members-crm`.

## [3.12.0] - 2026-06-18

### Added — Đợt A1: Panel thông tin NHÓM + Nhắc hẹn nối lịch CRM
- **Nút info ở chat NHÓM giờ mở `GroupInfoPanel`** (trước đây bấm không ra gì vì panel cũ cần `contact`,
  nhóm không có contact). Panel hiện: avatar/tên/sĩ số nhóm + link quản lý nhóm + mục **Nhắc hẹn** (+ chỗ
  cho ghi chú/ghim/bình chọn/thư viện ở đợt sau).
- **Tạo nhắc hẹn nhóm**: panel → nhập nội dung + thời gian + người phụ trách → gọi Zalo `createReminder`
  **đăng vào nhóm** (mọi thành viên thấy native trên Zalo) → message-handler **tự sync về CRM Appointment**.
- **Nối lịch CRM cho nhóm (Phase B)**: trước đây `reminder-sync` bỏ qua nhắc hẹn nhóm (chỉ làm 1-1). Nay
  nhắc hẹn nhóm tạo Appointment với `conversationId` (link hội thoại) + **`assignedUserId` = nhân viên đang
  chăm nhóm** (lấy từ `conversation.assignedUserId`) → hiện đúng trên lịch "Của tôi" của người phụ trách.
  Chọn người phụ trách trong panel sẽ gán luôn cho hội thoại nhóm.
- **Schema**: `Appointment.conversationId` (+ index + FK SET NULL) — migration `appointment_conversation_link`.
- **Backend**: `GET/POST /groups/:groupId/reminders`, zaloOps `createReminder`/`getListReminder`.

## [3.11.12] - 2026-06-18

### Fixed
- **Bình chọn nhóm hiện "[object Object]".** `poll-voter` render `opt.text`/`opt.name` nhưng zca-js
  `PollOptions` dùng `content` (text), `votes` (số phiếu), `option_id` (id). Nay map đúng + `closed` (khoá),
  `allow_multi_choices` (nhiều lựa chọn), `expired_time` (hết hạn).
- **Badge nick ở trang Nhóm kẹt "Offline".** Danh sách nick chỉ fetch 1 lần lúc mở trang (lúc nick đang
  connecting) và không tự cập nhật. Nay nút ⟳ làm mới + load nhóm cũng refresh trạng thái nick.

## [3.11.11] - 2026-06-18

### Fixed
- **Nick kẹt trạng thái "connecting" dù kết nối thật vẫn sống (gửi/nhận tin được) → mọi thao tác Zalo báo
  "not connected".** Khi listener Zalo đóng định kỳ (close code 1000, BÌNH THƯỜNG) status bị đặt `connecting`,
  SDK tự retry websocket nên tin vẫn chạy, nhưng callback `onConnected` không phải lúc nào cũng fire lại →
  status **kẹt `connecting`**. Cổng `exec` chặn mọi op khi status ≠ `connected` → `/groups`, đổi avatar, gửi
  tin... đều lỗi dù nick vẫn online. **Sửa:**
  - `exec`: cho phép thao tác khi **`api` đã sẵn** (đã login xong); chỉ chặn khi chưa có api hoặc đã rớt hẳn
    (`disconnected`/`qr_pending`) — không chặn lúc `connecting` tạm thời.
  - `getStatus`/`getAllStatuses`: `connecting` **mà api đã có** → báo `connected` cho đúng thực tế (badge nick,
    danh sách nick, trang Nhóm không còn hiện offline nhầm).

## [3.11.10] - 2026-06-18

### Added
- **Đổi avatar nhóm.** Dialog cài đặt nhóm thêm đổi ảnh đại diện: bấm avatar → chọn ảnh → "Lưu ảnh mới".
  Backend route `POST /groups/:groupId/avatar` (multipart, ≤5MB) → ghi tmp → `changeGroupAvatar` → dọn tmp.

### Changed
- **Refine quyền đổi tên/avatar theo setting nhóm (không chặn cứng theo trưởng/phó).** Trước đây chỉ trưởng/phó
  mới sửa được tên/ảnh. Thực tế Zalo dùng setting **`blockName`** ("chặn thành viên đổi tên & ảnh nhóm"): nếu
  nhóm KHÔNG bật `blockName` (hoặc chưa cấu hình gì), **thành viên thường vẫn được đổi tên/ảnh**. Nay
  `canEditNameAvatar = trưởng/phó || !blockName` → mở đúng quyền. Còn các cài đặt quyền khác + quản lý thành
  viên (đặt/hạ phó, xoá, chặn, chuyển quyền) vẫn chỉ trưởng/phó (Zalo enforce admin-only). Zalo vẫn là người
  quyết cuối — nếu không đủ quyền, thao tác báo lỗi rõ.

## [3.11.9] - 2026-06-18

### Added
- **Hoàn thiện Cài đặt nhóm.** Dialog cài đặt nhóm thêm 9 tùy chọn của Zalo (`updateGroupSettings`): duyệt
  thành viên (`joinAppr`), chỉ trưởng/phó được gửi tin (`lockSendMsg`), chặn đổi tên & ảnh nhóm (`blockName`),
  chặn tạo ghi chú/nhắc hẹn (`lockCreatePost`), chặn tạo bình chọn (`lockCreatePoll`), gắn nhãn tin admin
  (`signAdminMsg`), cho thành viên mới xem tin cũ (`enableMsgHistory`), không cho ghim (`setTopicOnly`), ẩn
  danh sách thành viên (`lockViewMember`). Khởi tạo từ `group.setting` hiện tại; **chỉ trưởng/phó** sửa được
  (chế độ chỉ đọc + ẩn "Giải tán" nếu không phải trưởng nhóm). Tận dụng route `PATCH /groups/:id/settings` sẵn có.
- **Tùy chọn nhóm khi tạo nhóm mới.** Dialog tạo nhóm thêm mục "Tùy chọn nhóm (quyền & duyệt)" gập/mở — set
  sẵn các quyền lúc tạo; sau khi `createGroup` thành công sẽ tự `updateGroupSettings` lên nhóm vừa tạo.

### Note
- Đổi avatar nhóm cần pipeline upload file riêng — sẽ làm ở bản sau.

## [3.11.8] - 2026-06-18

### Added / Fixed
- **Modal "Tạo nhóm" hết bị cắt nút.** Khoá `max-height: 90vh` + body cuộn, header/nút "Tạo nhóm" luôn hiện.
- **Mở hội thoại nhóm tự chuyển tab "Nhóm".** Trước đây mở group conv mà list vẫn ở tab "Cá nhân" (sai logic);
  nay `selectConversation` xong tự `setActiveTab('group')` nếu conv là nhóm.
- **Nhắn riêng từ danh sách thành viên nhóm.** Mỗi thành viên có nút "Nhắn riêng" → ensure hội thoại 1-1 với
  UID đó rồi mở chat ngay.
- **Vai trò + tác vụ theo quyền trong nhóm.** Backend gắn `isOwner`/`isDeputy` cho từng thành viên (so
  `creatorId`/`adminIds`); menu tác vụ ẩn theo vai trò: không tác động lên trưởng nhóm, "Đặt/Hạ phó nhóm" theo
  trạng thái hiện tại, "Chuyển quyền" chỉ hiện khi nick đang chăm LÀ trưởng nhóm, các tác vụ quản lý chỉ hiện
  khi nick là trưởng/phó.

## [3.11.7] - 2026-06-18

### Fixed
- **Thành viên nhóm: lấy từ `memVerList` (memberIds/currentMems luôn rỗng ở zca-js này).** Bản 3.11.6 vẫn
  ra 0 thành viên (header báo "N thành viên" nhưng list rỗng) vì `getGroupInfo` trả `memberIds`/`currentMems`
  RỖNG (kể cả nhóm 2 người), member ID thật nằm ở **`memVerList`** (dạng `"<uid>_<version>"`). Nay parse uid
  từ `memVerList`, gọi `getGroupMembersInfo` **theo lô 50** rồi gộp `profiles`. Ensure-conversation cũng điền
  `groupMembersCount`.
- **Mở hội thoại NHÓM bị TRANG TRẮNG (kẹt tab "Cá nhân").** Deep-link `/chat/:id` tới group conv khi danh sách
  đang ở tab "Cá nhân" (lọc `threadType=user`) → conv không nằm trong list đã lọc → pane trắng, phải bấm tab
  "Nhóm" mới hiện. Nay `selectConversation` **chèn thẳng conversation detail vào list** khi nó ngoài filter →
  pane render ngay, không cần đổi tab.
- **Danh sách nhóm `/groups` không cuộn được (đẩy cả trang).** `v-main` không khoá chiều cao nên `h-100` vô
  nghĩa, list 20+ nhóm nở ra đẩy cả trang cuộn. Nay khoá root trang theo viewport
  (`height: calc(100vh - topnav)` + `overflow:hidden`) như ChatView → list cuộn nội bộ panel trái.

## [3.11.6] - 2026-06-18

### Fixed
- **Nhóm Zalo: tự tải khi mở trang (không bắt bấm refresh) + hiện avatar nhóm + xem được thành viên.**
  - **Auto-load**: `GroupsView` trước đây không có watcher/onMounted → mở trang ra "Không có nhóm nào", phải
    bấm ⟳ thủ công. Nay watch `selectedAccountId` (immediate) → tự tải nhóm ngay khi mở trang / đổi nick.
  - **Avatar nhóm**: danh sách + chi tiết nhóm trước chỉ hiện icon chung; nay hiện **avatar thật** (`avt`/`fullAvt`
    từ Zalo), fallback icon khi nhóm không có avatar.
  - **Thành viên nhóm**: `getGroupMembersInfo()` của Zalo nhận **MEMBER IDs**, không phải groupId — backend
    truyền nhầm groupId → lỗi `Tham số không hợp lệ [zalo:114]`, danh sách thành viên luôn lỗi. Nay lấy
    `memberIds` từ `getGroupInfo` rồi mới gọi `getGroupMembersInfo(memberIds)`.
  - **Hết "Nhóm Zalo" vô danh**: conv nhóm tạo từ nút "Nhắn tin nhóm" hoặc từ **sự kiện nhóm** (đổi tên,
    thêm/bớt thành viên — không phải tin nhắn) trước đây có `groupName=null` → hiện "Nhóm Zalo" vô danh, nút
    nhắn tin trỏ vào nhóm không tên. Nay **resolve tên/avatar/sĩ số qua `getGroupInfo`**: ensure-conversation
    điền lúc tạo + backfill conv cũ còn trống; message-handler backfill nền (fire-and-forget) khi conv nhóm
    sinh ra không kèm tên. Thêm helper `getGroupMeta`.
  - **Cuộn danh sách nhóm**: list 20+ nhóm trước đây đẩy cả trang cuộn chung (thiếu `min-height:0` trong chuỗi
    flex) → nay **cuộn nội bộ** trong panel trái, header/toolbar cố định.

## [3.11.5] - 2026-06-18

### Fixed
- **Trang Nhóm Zalo (`/groups`) luôn rỗng dù có nhóm — sửa cách gọi Zalo.** `api.getAllGroups()` của Zalo CHỈ
  trả `gridVerMap` (map ID↔version, ~24 nhóm) còn `gridInfoMap` (tên/avatar/thành viên) **RỖNG**. Backend trước
  đây trả thẳng object rỗng đó → frontend không có gì để hiện ("Không có nhóm nào") dù nick đang kết nối. Nay
  backend lấy danh sách ID từ `gridVerMap` rồi gọi **`getGroupInfo(ids)`** để nạp thông tin nhóm thật, trả về
  mảng. Frontend `use-groups` chuẩn hoá shape `{gridInfoMap}`/`{profiles}` → mảng (cả list, chi tiết, thành viên).
- **Đồng bộ bạn bè (`/friends`) không kéo bạn thật về — chống rate-limit.** `getAllFriends()` của Zalo bị
  **429 (rate-limit) sau ~2 lần gọi** và thỉnh thoảng trả RỖNG dù tài khoản có bạn (vd 29 bạn live nhưng DB chỉ
  có 19 "đang nhắn lạ"). Sync trước đây nhận rỗng → **im lặng báo "thành công 0 bạn"**, không import. Nay sync
  **thử lại tới 4 lần có backoff** khi rỗng/429, và nếu vẫn rỗng do lỗi thì **báo lỗi rõ** (không coi là thành
  công), không ghi rỗng đè dữ liệu cũ.

## [3.11.4] - 2026-06-18

### Changed
- **Tạo nhóm mới: chọn thành viên bằng cách tick từ danh bạ thay vì gõ UID tay.** Trước đây hộp "Tạo nhóm
  mới" chỉ có 1 ô textarea bắt nhập UID thủ công (cách nhau dấu phẩy) → rất phiền, dễ sai. Nay:
  - **Tick chọn từ danh bạ** của nick: danh sách liên hệ có avatar + tên + UID + nhãn (Bạn bè / Đang chat).
    **Click cả dòng** để chọn (1 cú/người), tick lại để bỏ.
  - **Ô tìm kiếm** theo tên / SĐT / UID (truy vấn server, debounce) + nút **"Chọn tất cả"** cho nhóm kết quả
    đang lọc.
  - **Thanh "Đã chọn N"** hiện chip avatar+tên, bấm ✕ để bỏ nhanh, "Bỏ hết" để xoá toàn bộ.
  - **Vẫn thêm được bằng UID** cho người **chưa có liên hệ** (dán nhiều UID, kiểm tra hợp lệ; UID trùng liên
    hệ đang có thì tự gắn tên/avatar). Khi tạo: gộp UID đã tick + UID nhập tay, tự loại trùng.
  - **Hiển thị TOÀN BỘ danh bạ** (tải tới 200/lần + nút "Xem thêm"), sắp xếp **mới nhất trên đầu**; nút đổi
    kiểu tên **Tên Zalo / Gợi nhớ (alias)** để dễ nhận. Giao diện thiết kế lại theo design system (`--smax-*`,
    Avatar dùng chung) cho gọn — đẹp hơn bản đầu.
  - Không đổi backend — tận dụng API `friends-db` + `createGroup(memberIds[])` sẵn có.
- **Tin nhắn mới: duyệt & bấm chọn KH ngay, không bắt gõ tìm.** Khi chọn nick, hộp "Tin nhắn mới" tự nạp
  **danh bạ gần đây** (mới nhất trên đầu) để bấm mở chat luôn; gõ tìm vẫn lọc như cũ, xoá ô tìm thì quay lại
  danh sách duyệt. Giữ nguyên luồng tra SĐT trên Zalo cho KH hoàn toàn mới.
- **Nhóm Zalo: báo rõ khi nick offline.** Trang `/groups` lấy nhóm **trực tiếp từ Zalo** nên nick phải đang
  kết nối; trước đây nick offline chỉ hiện "Không có nhóm nào" gây hiểu nhầm. Nay hiện cảnh báo "Nick đang
  offline → kết nối lại để tải nhóm" (kèm lý do lỗi từ server).

## [3.11.3] - 2026-06-17

### Fixed
- **Import tin cũ KHÔNG còn kéo tụt hội thoại xuống đáy list.** `updateConversationAfterMessage` trước đây
  set `lastMessageAt = sentAt` vô điều kiện → khi backfill chèn tin CŨ (lấp lỗ hổng) vào hội thoại đã có tin
  mới hơn, nó kéo lùi `lastMessageAt` về ngày cũ → hội thoại tụt sai vị trí (vd "CSKH" có tin 16/06 nhưng
  nằm ở mốc 04/06). Nay backfill **chỉ đẩy `lastMessageAt` tới nếu tin mới hơn** (không kéo lùi) và **không
  tăng unread** (tin cũ không phải tin chưa đọc). Tin real-time giữ nguyên hành vi.

## [3.11.2] - 2026-06-17

### Added / Fixed
- **Extension v1.0.4 — chế độ "Đồng bộ hội thoại ĐANG MỞ" + sync avatar.**
  - **Lỗi sót tin (vd nick An)**: hội thoại KHÔNG nằm trong danh sách Zalo Web (bị ẩn/lưu trữ/không recent)
    thì cách duyệt-list không bao giờ với tới → mất tin (nhất là tin nhận lúc nick đang ngắt kết nối).
    Thêm nút **"Chỉ đồng bộ hội thoại ĐANG MỞ"**: user tự mở hội thoại đó trên Zalo Web → extension scrape
    đúng hội thoại đang mở (lấy tên từ `.main-title-container`, threadId suy từ `message.toUid` + `group` store).
  - **Avatar**: trích link avatar Zalo từ DOM (`img zadn.vn`) → đẩy `contactZaloAvatarUrl` (1-1) / `groupAvatarUrl`
    (nhóm) về CRM để hiển thị đúng ảnh đại diện.
  - threadType nhóm xác định bằng `group` store (`userId` "g…" KHÔNG mã hoá) thay vì đoán; vẫn bỏ "g" ở threadId.

## [3.11.1] - 2026-06-16

### Fixed
- **Extension đồng bộ Zalo — map dữ liệu ĐÚNG (sửa lỗi "phá nát hội thoại")** (extension v1.0.3). Bản trước
  đọc tên/nhóm từ IndexedDB nhưng Zalo **E2EE mã hoá** các field tên (`group.displayName`, `friend.zaloName`…)
  → ra chuỗi base64 rác: tên nhóm sai, người gửi "Unknown", tạo hội thoại trùng. Đã xác minh thực tế trên Zalo
  Web + đối chiếu API CRM và sửa:
  - **Tên (nhóm, người gửi, đối phương) đọc từ DOM** (client đã giải mã) thay vì IndexedDB. Nhóm: build map
    `uid → tên thành viên` từ nhãn tên trong bong bóng; 1-1: tên đối phương = tên hội thoại.
  - **Group threadId bỏ tiền tố `g`** (`g8057…` → `8057…`) để khớp `externalThreadId` của zca-js/real-time
    → KHÔNG tạo hội thoại trùng nữa.
  - IndexedDB chỉ còn dùng cho phần KHÔNG mã hoá: `msgId`(snowflake), `cliMsgId`, `fromUid`, `sendDttm`(thời gian).
  - Backend `import/messages` nhận thêm `recipientName` (đặt tên contact cho tin self 1-1, tránh "Unknown").

## [3.11.0] - 2026-06-16

### Added
- **Access Token có phân quyền (scope) + trang tải/hướng dẫn Extension đồng bộ Zalo** — gói trọn phần API cho
  extension import tin:
  - Đổi tên **"Public API token" → "Access Token"** (đúng nghĩa: token bí mật Bearer, không phải khoá công khai).
  - **Phân quyền theo scope**: tạo token chọn đúng quyền cần dùng; scope đầu tiên là `import:messages`
    (*Đồng bộ tin Zalo — Extension*). Backend **enforce scope**: endpoint `/api/v1/import/*` yêu cầu token có
    quyền này (token cũ `scopes=[]` vẫn full-access để tương thích ngược). Catalog: `GET /api/v1/api-tokens/scopes`.
  - Trang **Cài đặt → Dev & API → Access Token** thêm thẻ **Extension — Đồng bộ tin Zalo**: nút **Tải extension
    (.zip)** (`/downloads/zalo-import-extension.zip`), hướng dẫn cài 4 bước, nút **Tạo token cho Extension**
    (cấp sẵn đúng scope + tên gợi ý), và ghi rõ giới hạn (chỉ tin chữ đã render — trần của Zalo).
  - Bảng token thêm cột **Quyền** (scope chips). HDSD `02-tai-khoan-zalo` cập nhật theo.

## [3.10.1] - 2026-06-16

### Fixed
- **Paste/kéo-thả ảnh vào ô chat giờ XEM TRƯỚC, không gửi ngay** — trước đây Ctrl+V (hoặc kéo-thả, chọn file)
  ảnh là **gửi luôn** → dễ gửi nhầm. Nay ảnh vào **hàng đợi xem trước** (thumbnail + nút bỏ từng ảnh) phía trên
  ô nhập, phải bấm **"Gửi N ảnh"** mới gửi, hoặc **"Hủy"**. Áp dụng cho cả paste, kéo-thả, và chọn từ máy.

## [3.10.0] - 2026-06-16

### Added
- **Import tin nhắn cũ từ Zalo Web qua Chrome Extension** — vì Zalo mã hoá tin cũ (chỉ client chính chủ giải
  được), thêm extension `tools/zalo-import-extension`: chạy trên `chat.zalo.me`, đọc **metadata tin từ IndexedDB**
  (msgId server + cliMsgId + người gửi + thời gian + hội thoại — không mã hoá) ghép với **nội dung đã giải mã từ
  DOM** (khớp theo cliMsgId), rồi đẩy về CRM. Backend: `POST /api/v1/import/messages` + `GET /api/v1/import/accounts`
  (auth **API token** Bearer), tái dùng pipeline tin nhắn (dedup theo zaloMsgId, không kích hoạt automation).
  Chỉ lấy được tin Zalo Web đã render (gần đây) dạng chữ — đây là giới hạn của Zalo. HDSD: `02-tai-khoan-zalo`.

## [3.9.2] - 2026-06-16

### Changed
- **Nút "Sync lịch sử chat" hoàn thiện & trung thực** — trước đây bấm xong không phản hồi gì (tưởng hỏng) và
  bấm nhiều lần gây lỗi 429 từ Zalo. Nay: hiện trạng thái **đang đồng bộ** + **toast kết quả** ("Đã đồng bộ:
  X danh bạ · Y nhóm · Z tin") + tự refresh; **chặn chạy trùng** ở server (bấm khi đang chạy → báo "đang đồng
  bộ, vui lòng đợi" thay vì spam gọi). Thêm **ghi chú rõ giới hạn**: chỉ lấy được danh bạ + lịch sử nhóm + tin
  từ lúc kết nối; **tin 1-1 cũ trước khi kết nối không lấy được** (giới hạn Zalo — chỉ app điện thoại đồng bộ được).

## [3.9.1] - 2026-06-16

### Fixed
- **Ngắt kết nối nick Zalo thủ công giờ "ở yên"** — trước đây bấm Ngắt kết nối xong `health-check`
  (5 phút/lần) + auto-reconnect vẫn tự kéo nick lên lại, không phân biệt user cố tình ngắt hay rớt mạng.
  Thêm cờ `autoReconnect` cho từng nick: ngắt thủ công → tắt cờ → health-check / auto-reconnect / reconnect
  lúc khởi động đều **bỏ qua**. Bật lại khi user chủ động "Kết nối lại" hoặc đăng nhập QR mới.

## [3.9.0] - 2026-06-16

### Added
- **Tùy biến Trợ lý AI từ giao diện** — trang mới **Cài đặt → CRM Config → Trợ lý AI** (`/settings/crm/ai-assistant`)
  cho phép khách tự dạy AI hiểu đúng doanh nghiệp và nói đúng giọng shop, không cần kỹ thuật:
  - **Bối cảnh & giọng điệu** (áp cho mọi tác vụ): mô tả doanh nghiệp/sản phẩm, chọn giọng (thân thiện/chuyên
    nghiệp/năng động/trang trọng/tự nhập), ngôn ngữ (tự nhận/Việt/Anh), số tin nhắn ngữ cảnh, độ sáng tạo (temperature).
  - **Tùy biến từng tác vụ** (Gợi ý trả lời, Tóm tắt, Cảm xúc, Tô màu tin bán hàng, Đọc note→lịch hẹn): thêm
    **Hướng dẫn riêng**, hoặc **Chế độ chuyên gia** viết lại toàn bộ vai trò; kèm **Xem prompt cuối**, **Thử ngay**,
    **Khôi phục mặc định**.
  - **An toàn**: lớp chống lộ thông tin/prompt-injection và định dạng kết quả (JSON…) **luôn được hệ thống giữ**,
    khách không thể phá kể cả ở Chế độ chuyên gia.
- DB: `ai_configs` thêm cột nghiệp vụ (business_context, tone, language, context_messages, temperature);
  bảng mới `ai_prompt_overrides` (per-org, per-task). Áp bằng migration `20260616120000_ai_customization`.
- API: `GET/PUT /ai/customization`, `PUT/DELETE /ai/prompt/:task`, `POST /ai/preview`, `POST /ai/test`.

### Changed
- Toàn bộ prompt AI chuyển sang `prompts/compose.ts` (ghép theo lớp) để hỗ trợ tùy biến; provider hỗ trợ
  tham số `temperature`. Hành vi mặc định không đổi khi khách chưa tùy biến.

## [3.6.3] - 2026-06-15

### Added
- **Khôi phục ảnh hỏng (0 byte) từ Zalo** — với ảnh đã hỏng do bug 0 byte (URL gốc bị ghi đè), thêm nút **"Khôi phục ảnh hỏng"** ở Cài đặt → Sao lưu. Cơ chế: liệt kê object 0 byte trên MinIO → tìm tin trỏ tới chúng → **re-fetch tin từ Zalo** (DM qua `requestOldMessages`, group qua `getGroupChatHistory`) lấy URL ảnh mới → mirror lại + cập nhật tin → dọn file rỗng mồ côi. Cần nick Zalo liên quan đang kết nối. Endpoint owner `POST /api/v1/backup/recover-broken-media`. (`media-recovery.ts`, `backup-routes.ts`, `BackupPage.vue`, `use-backup.ts`).

## [3.8.4] - 2026-06-15

### Changed
- Bản phát hành để **kiểm thử quy trình tự cập nhật** (nút "Cập nhật ngay" + popup "Có gì mới").
  Không thay đổi tính năng so với 3.8.3.

## [3.8.3] - 2026-06-15

### Added
- **Nút "Cập nhật ngay"** trên trang Phiên bản — khi có bản mới, bấm 1 nút để máy chủ tự cập nhật (kèm sao
  lưu), không cần SSH. Cơ chế: app đặt cờ yêu cầu, tác vụ nền trên máy chủ (kiểm tra mỗi 5 phút) tự chạy
  `update.sh`. Nếu máy chủ không có tác vụ nền (vd app ở VPS khác) → trang nhắc dùng **Cập nhật thủ công** (lệnh copy sẵn).
- **Đọc "Có gì mới" của bản MỚI trước khi cập nhật** — bấm "Xem có gì mới ở vX.Y.Z" để đọc ghi chú bản mới
  (tải từ CHANGELOG công khai) rồi mới quyết định cập nhật.
- **Link hướng dẫn cập nhật** ngay tại mục Cập nhật thủ công.

### Changed
- Tác vụ tự-động-cập-nhật chạy **mỗi 5 phút** (trước 6 giờ) để nút "Cập nhật ngay" phản hồi nhanh.

## [3.8.2] - 2026-06-15

### Fixed
- **Công tắc "Tự động cập nhật" rõ hơn** — trước đây track công tắc khi TẮT quá mờ, khó nhìn. Đã làm rõ
  màu track + viền + thumb nổi bật.

### Added
- **HDSD "Phiên bản & Cập nhật"** — thêm trang hướng dẫn người dùng (`/hdsd`) cho tính năng xem phiên bản,
  cập nhật thủ công và tự động cập nhật.

## [3.8.1] - 2026-06-15

### Fixed
- **Nút "Kiểm tra lại" ở trang Phiên bản giờ ép làm mới ngay** — trước đây trang dùng cache 6 giờ nên sau khi
  phát hành bản mới, "Mới nhất" vẫn hiện bản cũ tới khi hết cache. Nay bấm "Kiểm tra lại" hỏi GHCR tức thì
  (`?refresh=1`). Cron nền vẫn tự làm mới mỗi 6 giờ cho chuông thông báo.

## [3.8.0] - 2026-06-15

### Added
- **Phiên bản & Cập nhật** — trang mới **Cài đặt → Dev & API → Phiên bản & Cập nhật** cho chủ tổ chức:
  - Hiển thị **phiên bản đang dùng** + **bản mới nhất có sẵn** (tự hỏi kho image GHCR).
  - **Thông báo hệ thống**: khi có bản mới, chuông thông báo của chủ tổ chức hiện "Có phiên bản mới: vX.Y.Z".
  - **Cập nhật thủ công**: hiện sẵn lệnh `./update.sh` (copy 1 chạm) để chạy trên máy chủ — tự sao lưu trước.
  - **Tự động cập nhật (tuỳ chọn)**: bật toggle → máy chủ tự cập nhật khi có bản mới (qua tác vụ nền cài kèm,
    kèm sao lưu). Mặc định TẮT — bạn chủ động cập nhật.
  - **"Có gì mới"**: sau khi cập nhật, mở app sẽ hiện popup tóm tắt các thay đổi của bản vừa lên (đọc từ CHANGELOG).
- Sửa `/api/v1/status` trả đúng phiên bản thực (trước đây cố định "1.0.0").

## [3.7.1] - 2026-06-15

### Added
- **HDSD "Phân chia hội thoại"** — thêm trang hướng dẫn người dùng cho tính năng phân chia hội thoại
  (`docs/HDSD/19-phan-chia-hoi-thoai.md` → `/hdsd`): 3 vai trò (điều phối/phụ trách/không phụ trách),
  2 chế độ (đơn giản/nâng cao), cách cấu hình per nick, gán/nhận trong chat, bàn giao khi nghỉ. Liên kết
  chéo với guide Phân quyền (RBAC). Vị trí tính năng: **Cài đặt → Kênh & Tích hợp → Phân chia hội thoại**.

## [3.7.0] - 2026-06-15

### Added
- **Phân chia hội thoại — Phần 1 (gán + chặn trả lời)** — nền tảng phân công hội thoại cho nhân viên
  (mô hình ReBAC-lite theo quan hệ điều phối/phụ trách/không-phụ-trách, học theo Sapo). Gồm:
  - **Gán theo HỘI THOẠI**: bảng `ConversationAssignment` (hỗ trợ nhiều người/1 hội thoại, mặc định tối đa 1)
    + `Conversation.assignedUserId`. Endpoint gán/nhận/bỏ-gán + **bàn giao** toàn bộ hội thoại của 1 nhân
    sự sang người khác (`POST /users/:id/transfer-assignments`).
  - **RBAC**: thêm action `reply` + `assign` cho resource `conversation` (tạo được vai trò "Người phân chia
    hội thoại"). Cập nhật nhóm mặc định (Trưởng phòng/CEO có `assign`; Sale/Senior có `reply`).
  - **Cấu hình per nick** `ZaloAccount.conversationPolicy` (chế độ simple/advanced, số người phụ trách,
    người điều phối, ma trận quyền theo quan hệ, chính sách hội thoại chưa phân) + endpoint GET/PUT.
  - **Chặn trả lời** theo quan hệ — CHỈ khi nick bật chế độ **nâng cao** (opt-in; mặc định simple giữ nguyên
    hành vi cũ, không ảnh hưởng khách đang dùng).
  - **Inbox**: lọc "Của tôi / Chưa phân / Tất cả" + control **"Phụ trách"** ở đầu khung chat
    (badge + Nhận về mình / Gán cho nhân viên / Bỏ phân công).
  - **Trang cấu hình per nick** (Cài đặt → Kênh → "Phân chia hội thoại", layout như Sapo): chọn chế độ
    simple/advanced, số người phụ trách, người điều phối, phương thức (thủ công/tự động), và **ma trận
    quyền** 6 hành động × 5 cột quan hệ (Xem/Trả lời/Hành động nghiệp vụ/Nhận/Phân cho người khác/Xóa).
  - **Phân chia tự động**: khi có hội thoại mới từ khách → tự gán **chia đều** (round-robin cân tải),
    tuỳ chọn chỉ trong **giờ làm việc** / chỉ nhân viên **trực tuyến**; cron **tự chuyển** hội thoại quá
    N phút chưa trả lời sang người khác (quét mỗi 2 phút).
  - **Bàn giao**: chuyển toàn bộ hội thoại của 1 nhân sự (khi nghỉ) sang người khác hoặc về hàng đợi.
  - Thiết kế chi tiết: `docs/rbac/THAO-LUAN-PHAN-QUYEN-CHI-TIET.md`.

## [3.6.2] - 2026-06-15

### Fixed
- **Ảnh không hiển thị trong tin nhắn (file 0 byte)** — khi mirror media về MinIO, lúc tải từ Zalo CDN đôi khi nhận `200` nhưng **body rỗng (0 byte)**; code cũ vẫn lưu file rỗng lên MinIO **rồi ghi đè URL gốc** → ảnh hỏng vĩnh viễn (Cloudflare còn cache bản rỗng). Sửa: **không lưu object 0 byte** — `mirrorRemoteMediaUrl` ném lỗi khi body rỗng để **giữ URL Zalo gốc**, `uploadBuffer` cũng chặn buffer rỗng cho mọi luồng upload. (`message-handler.ts`, `minio-client.ts`).
- **Cron mirror-bù bị "kẹt đầu hàng"** — `media-backfill-cron` quét **cũ-nhất-trước** + dừng sớm khi 1 lô không mirror được gì; vài ảnh cũ đã hết hạn (tải lại lỗi) ở đầu hàng làm các ảnh **mới hơn còn cứu được** không bao giờ tới lượt. Sửa: quét **mới-nhất-trước** → ảnh vừa lỡ mirror (URL còn hạn) được cứu trong 15 phút. (`media-backfill-cron.ts`).

## [3.6.1] - 2026-06-13

### Fixed
- **Dải trắng dưới ô nhập tin nhắn (mobile)** — màn chat mobile để chiều cao cứng `calc(100vh - 120px)` không khớp chiều cao thanh điều hướng dưới → hở một dải trắng giữa ô nhập và bottom nav. Sửa dùng `calc(100dvh - 104px - env(safe-area-inset-bottom))` để ô nhập nằm sát thanh điều hướng. (`MobileChatView.vue`).
- **Ô nhập tin nhắn bị cao do placeholder xuống dòng** — placeholder dài (`Gõ tin nhắn… ("/" template, "@" mention, "#" tag)`) xuống dòng làm ô nhập to ra. Rút gọn còn **"Nhập tin nhắn (dùng được @ / #)"**. (`MessageThread.vue`).
- **Popup "Tin nhắn mẫu" không tự đóng khi bấm ra ngoài** — popup template tự chế trước đây chỉ đóng bằng Escape, bấm ra ngoài vẫn che các vùng khác. Thêm **directive dùng chung `v-click-outside`** (hoạt động cả desktop lẫn cảm ứng) cho popup này; nút mở popup gắn `data-co-ignore` để không bị đóng-rồi-mở lại. (`directives/click-outside.ts`, `main.ts`, `quick-template-popup.vue`).
- **Đã kết bạn nhưng vẫn hiện nút "Kết bạn"** — khi API kiểm tra trạng thái bạn của Zalo bị giới hạn tần suất (429), frontend rơi xuống dữ liệu DB nhưng nhánh dự phòng cũ chỉ xét `relationshipKind` nên bỏ sót. Nay nhận diện "đã là bạn" từ `relationshipKind='friend'` HOẶC `friendshipStatus='accepted'` HOẶC có mốc `becameFriendAt` (và chưa huỷ/chặn). (`MessageThread.vue`).

## [3.6.0] - 2026-06-12

### Fixed
- **Nick Zalo đang chạy nhưng hiển thị "Disconnected" + "cần re-login"** — Zalo SDK đóng listener định kỳ (code 1000 NORMAL_CLOSURE) rồi tự reconnect (`retryOnClose`); code cũ (a) coi mọi lần đóng là disconnect → kẹt status đỏ + đợi 30s, (b) handler `connected` chỉ log **không khôi phục** status, (c) đếm cả close-1000 vào circuit breaker → trip "cần re-login". Sửa: thêm callback **`onConnected`** khôi phục `'connected'` mỗi khi listener (re)connect; **code 1000 = routine** (không đánh disconnected/không ghi DB/không tính circuit breaker/không dừng sync, chỉ `'connecting'` tạm + reconnect dự phòng 15s); circuit breaker chỉ tính disconnect thật. (`zalo-pool.ts`, `zalo-listener-factory.ts`).
- **Lag khi đổi hội thoại (load tin nhắn chậm)** — trước tải **100 tin** + render 100 bong bóng mỗi lần mở. Nay **phân trang**: tải **50 tin mới nhất** trước (giảm ~½ render + payload), cuộn lên đầu khung chat **tự tải tin cũ hơn** (hoặc nút "Tải tin nhắn cũ hơn") + **giữ nguyên vị trí cuộn** (không nhảy đáy). Backend đã sẵn phân trang qua `?page` nên chỉ đổi frontend. (`use-chat.ts`, `MessageThread.vue`, `ChatView.vue`).

### Added
- **Trung tâm Hướng dẫn sử dụng (HDSD) — trang `/hdsd`** — help center công khai (không cần đăng nhập) cho người dùng cuối, dự kiến phục vụ tại `hdsd.<tencongty>.com` (gắn kèm khi khách cài). Gồm **19 hướng dẫn** giọng đời thường (`docs/HDSD/`) cho mọi tính năng + trang **Cài đặt & Bắt đầu** (workflow cài→setup→dùng) + **2 sơ đồ tư duy/luồng (mermaid)**. Frontend: `HelpGuideView.vue` + `MarkdownDoc.vue` (markdown-it + mermaid lazy-load + **ảnh thật chụp từ sản phẩm** + khối **minh hoạ CSS** `.hdsd-demo`), sidebar mục lục + **tìm kiếm full-text** (`manifest.json`), dark mode, responsive. Tự đồng bộ khi build qua `scripts/sync-hdsd.mjs` (`docs/HDSD → public/help`). Truy cập từ **menu avatar góc phải** ("Hướng dẫn sử dụng" → mở tab mới) + **Cài đặt → Cá nhân → Hướng dẫn sử dụng** (tìm kiếm được). **Quy tắc mới (CLAUDE.md §6.4 + memory):** thêm/sửa tính năng ảnh hưởng người dùng phải viết/cập nhật HDSD tương ứng.

## [3.5.1] - 2026-06-12

### Added
- **Dark mode cho modal + automation** — convert màu hardcode trong các modal dùng chung (`AppModalHost`, CreateListModal, FolderManagePopup, ScoreBreakdownModal, RBAC modals…) sang token + remap token automation `--at-*` dưới `html.theme-dark` → modal/broadcast/lists/blocks tự đổi tối. Toggle ở **menu desktop / nút mobile / Cài đặt→Giao diện** nay đổi **tức thì không cần reload** (set class `html.theme-dark` ngay khi bấm).
- **Dark mode tinh tế** — palette tối trung tính (than chì #16171d, chữ #e8e9ed, nhấn xanh/hồng brand) thay theme cyan chói cũ. Cơ chế: **remap token `--smax-*` dưới `html.theme-dark`** → mọi chỗ dùng token (≈790, gồm chat/danh bạ/nav…) tự đổi; convert hex hardcode trong các trang settings/bảo mật sang token. Sửa bug toggle mobile (dùng sai tên theme + mặc định dark). Toggle ở Cài đặt → Giao diện (sáng/tối/hệ thống) + nút trên thanh mobile; opt-in, mặc định sáng.

### Changed
- **Login gọn hơn — bỏ passkey trùng lặp ở bước 2FA** — passkey đã là lối **đăng nhập không mật khẩu** ngay bước 1; trước đây nếu user đăng ký passkey thì sau khi nhập mật khẩu vẫn hiện lại tab "Passkey" như một yếu tố 2FA (thừa & ngược logic — passkey vốn mạnh hơn mật khẩu). Nay lọc `passkey` khỏi danh sách phương thức 2FA: sau mật khẩu chỉ còn **App xác thực (TOTP) / Email + Mã khôi phục**. Ai muốn passkey thì dùng nút passwordless ở bước 1.

### Fixed
- **Quét sạch "đốm sáng" dark mode toàn ứng dụng** — nhiều trang dùng màu hardcode (rõ nhất **Bạn bè**: cả sidebar/bảng/chip/thống kê trắng toát, và một phần **Tài khoản Zalo / Automation / Settings**) không đổi tối. Convert hàng loạt giá trị hex sang token `--smax-*` theo vai trò (nền trắng→`--smax-bg`, xám sáng→`--smax-grey-50`, viền→`--smax-grey-200`, chữ→`--smax-text`/`--smax-grey-700`, nền chọn xanh nhạt→`--smax-primary-soft`) trên toàn bộ `.vue` + `rbac-page.css`. Giữ nguyên **tint ngữ nghĩa** (badge cảnh báo amber/đỏ, tier-warm…) và nút tối `#111827`. Nay các trang đổi tối đồng bộ qua cùng cơ chế remap token.
- **Modal "Tạo chiến dịch" (broadcast) thiếu cuộn** — `.editor-card` thiếu `max-height` → nội dung tràn bị cắt. Thêm `max-height: 90vh` + body `overflow-y: auto` (head/foot cố định, body cuộn).
- **Còn sót màu tím UI** — sweep các sắc tím-accent còn lại (`#7c3aed`×12, `#a855f7`, `#aa3bff`, `#c084fc`, `#a78bfa`…) → hồng. (Giữ màu tím trong **bảng nhãn CRM** vì là tuỳ chọn người dùng.)
- **Icon Lucide bị to 24px che chữ** — `AppIcon` bind `:width/:height` nhưng `lucide-vue-next` chỉ nghe prop `:size` → mọi icon render mặc định 24px (thấy rõ ở preview file/ảnh trong danh sách hội thoại bị che). Thêm `:size="size"` → icon về đúng kích thước trên cả desktop lẫn mobile.

## [3.5.0] - 2026-06-11

### Changed
- **Brand trên mobile** — header mobile (`MobileLayout.vue`) trước hiện sai "ZaloCRM" + icon robot cyan → thay bằng **logo UAEM CRM** (khớp desktop). `theme-color`/manifest đổi từ navy `#0A192F` sang light/`#ff69b4` cho khớp giao diện sáng + brand hồng.
- **Đổi màu tím `#8b5cf6` → hồng `#ff69b4`** (tone tham khảo) trên toàn UI (17 chỗ: gradient privacy/scoring/zalo-accounts/friends/folder…), cặp gradient `#6d28d9` → `#d6418f`.

### Added
- **Quản lý dung lượng bộ nhớ & Dọn dẹp** (owner) — trang `/settings/dev/storage`: dashboard dung lượng app chiếm trên VPS (**Media + Tin nhắn + DB + Backup**), phân loại **theo loại** (ảnh/video/file/voice/gif) + **theo từng khách hàng/nhóm** (số tin nhắn + dung lượng tin + media, top 30). Phát hiện **file mồ côi** (rác). **Dọn dẹp**: file mồ côi (an toàn) + **dọn media theo hội thoại** (xoá vĩnh viễn, cảnh báo rõ). **Whitelist** `Conversation.storeMedia` — công tắc tắt = **không lưu media hội thoại đó về VPS** (giữ Zalo CDN, tiết kiệm bộ nhớ; `handleIncomingMessage` + cron backfill bỏ qua). Backend: `storage-routes.ts` + MinIO `listObjectsWithSize`/`removeObjects`/`putObjectFromFile`. Migration `conversation_store_media`. Xem [Quản lý bộ nhớ](docs/tinh-nang/quan-ly-bo-nho.md).

### Changed
- **Bảng "Theo KH/nhóm" (storage)** — thêm **tìm kiếm + lọc (loại/nguồn/CRM/whitelist) + sort + cuộn** (xử lý nhiều nick Zalo/KH/nhóm); mỗi dòng hiện **nick Zalo phụ trách · nguồn KH · trạng thái CRM · "Chưa vào CRM"** (trực quan khách đến từ đâu). Backend trả tới 200 hội thoại kèm `source/crmStatus/zaloAccount/inCrm`.
- **Xuất cấu hình khôi phục (chuyển VPS)** — nút trên trang Bộ nhớ tải `uaemcrm-restore-config.env` (3 secret `ENCRYPTION_KEY`/`JWT_SECRET`/`FB_TOKEN_ENC_KEY` + `S3_PUBLIC_URL`/`S3_DOMAIN`) — thứ KHÔNG nằm trong gói backup, cần để VPS mới giải mã khoá AI/FB/Drive + giữ URL ảnh. An toàn: owner-only + **xác nhận lại mật khẩu** + audit log + rate-limit + tách khỏi gói data. `POST /api/v1/storage/export-config`.
- **Khôi phục được gói backup trên Google Drive** — thêm `downloadDriveFileToPath` (Drive API `alt=media`) + `ensureBackupFileLocal`: nếu gói `destination=gdrive` (đã xoá local) thì endpoint khôi phục **tự tải từ Drive về** theo `remoteId` rồi khôi phục như gói local. Trước đây restore chỉ đọc local → gói gdrive-only không khôi phục được.
- **Backup đầy đủ hơn** — trước khi đóng gói, tự **mirror nốt media còn trỏ Zalo CDN về MinIO** (`backfillOrgMedia`) → gói `.tar.gz` gồm trọn ảnh/video/file + toàn bộ DB → **phục hồi được toàn bộ**.
- **Khôi phục media từ backup** — `POST /api/v1/backup/:id/restore-media` (owner) tải lại mọi file trong gói lên MinIO đúng key cũ (DB không bị đụng); khôi phục DB vẫn làm thủ công an toàn theo README.

## [3.4.1] - 2026-06-11

### Added
- **Bảo vệ media tự động (cron)** — `media-backfill-cron.ts`: tự mirror các tin còn trỏ Zalo CDN → MinIO, **không cần bấm tay**. Hai nhịp: RETRY mỗi 15 phút (bắt tin lỡ mirror lúc nhận do mạng chập/timeout) + quét đầy đủ 03:20 hằng đêm cho mọi tổ chức. Dừng sớm khi 1 lô không mirror được gì mới (chống lặp vô hạn). Dùng chung `mirrorMediaContentString`.
- **Mirror cả thumbnail link preview** — `mirrorMediaContentString` nay mirror thêm ảnh xem trước của `link`/`location`/`contact_card` (chỉ field thumb/thumbnail, KHÔNG mirror href link ngoài) → ảnh xem trước không mất khi CDN Zalo hết hạn.
- **Xem trước file Office + PDF trong trình duyệt** — bấm vào file trong chat mở modal xem trước: **PDF/text** render native (iframe), **Word/Excel/PowerPoint** qua Office Online viewer (file MinIO public), **ảnh** xem trực tiếp. Nút tải về riêng. (`message-bubble.vue` + `MessageThread.vue`).

### Changed
- **Tin thu hồi** — thay vì chỉ gạch ngang chữ, nay hiển thị **mờ** (ảnh blur / chữ blur) + nhãn "Tin nhắn đã thu hồi"; **bấm vào hé lộ nội dung gốc** (cả text lẫn ảnh — nội dung vẫn được giữ trong DB), kèm badge "Đã thu hồi". (`message-bubble.vue`).
- **Bỏ emoji hệ thống, dùng Lucide** — preview danh sách hội thoại + bong bóng tin + reply bar + nhãn danh bạ/bộ lọc/RBAC nay dùng **Lucide icon** (hoặc text sạch ở nơi không nhúng được SVG như `<option>`). Tuân thủ quy tắc thiết kế (không emoji/icon hệ thống).

### Fixed
- **Khôi phục media lỗi 500 (`tar`)** — code giải nén lọc member `media` nhưng archive lưu dạng `./media/` → không khớp. Sửa: giải nén cả gói rồi đọc `work/media`. (Phát hiện qua test khôi phục thực tế.)
- **Tạo nhắc hẹn không gắn KH bị lỗi 400** — UI cho tạo nhắc hẹn chung (không chọn KH) nhưng backend bắt buộc `contactId`. Sửa: `Appointment.contactId` thành **optional** (migration `appointment_contact_optional`), backend chỉ bắt buộc ngày, bỏ dedup/scoring khi không có KH. Các màn hiển thị vốn đã `?.`-safe.
- **Nút "Xuất CSV" lịch hẹn không hoạt động** — nút thiếu handler. Đã nối: xuất CSV danh sách nhắc hẹn đang lọc (BOM UTF-8 để Excel đọc tiếng Việt đúng).
- **Icon hiện "vòng tròn trắng"** — nhiều tên icon (vd `undo-2`, `sticker`, `qr-code`, `fingerprint`…) chưa có trong registry `AppIcon` → fallback `Circle`. Đã bổ sung import + map đầy đủ (gồm cả icon 2FA).

## [3.4.0] - 2026-06-11

### Added
- **Sao lưu lên Google Drive** — kết nối OAuth 2.0 (`/api/v1/integrations/google-drive/*`), đẩy gói `.tar.gz` lên Drive của owner, và **xuất bản đọc nhanh** (Danh bạ `.xlsx` + tin nhắn theo từng hội thoại). **Tự động hằng ngày 03:30** (cron) + **retention** (giữ N bản, xoá phần thừa trên Drive + local + DB) + tùy chọn **xoá bản local sau khi lên Drive** + nút **Chạy ngay**. Module `providers/google-drive/` (client gọi Drive API bằng fetch, resumable upload), refresh token mã hoá trong `Integration(type='google_drive')`; `createBackupBundle` tách từ `backup-routes` để cron tái dùng. `DataBackup` thêm `destination/remoteId/remoteLink`. Owner **nhập Client ID/Secret thẳng trên giao diện** (endpoint `PUT /credentials`, lưu mã hoá trong DB, fallback `.env`) — kết nối hoàn toàn từ frontend, không cần SSH sửa `.env`. **Backup media lọc theo `orgId`** (`collectOrgMediaKeys`, không còn gom toàn instance) và **bản xuất đọc kèm ảnh/file** theo từng hội thoại (thư mục `media/` riêng, toggle "Kèm ảnh/file", có giới hạn 40 file/hội thoại & 1500 file/lần). Xem [docs/tinh-nang/sao-luu-google-drive.md](docs/tinh-nang/sao-luu-google-drive.md).
- **Sao lưu gói đầy đủ** — `POST /api/v1/backup/create` nay tạo gói `.tar.gz` mở-ra-xem-được gồm `database.sql` (SQL văn bản), thư mục `media/` (tải toàn bộ file từ MinIO) và `README.txt` hướng dẫn khôi phục, thay cho file `.dump` nhị phân cũ. Thêm helper MinIO `listAllObjectKeys`/`downloadObjectToFile`.
- **Backfill media cũ** — `POST /api/v1/backup/mirror-legacy-media` (owner) quét tin nhắn cũ còn trỏ Zalo CDN, tải về MinIO theo lô để tránh mất media khi link CDN hết hạn; nút "Quét & bảo vệ media cũ" ở trang Sao lưu. Tách `mirrorMediaContentString` dùng chung từ luồng nhận tin.
- **Hệ tài liệu dự án** — thêm `CLAUDE.md` (chỉ dẫn dự án) và thư mục `docs/` có cấu trúc: kiến trúc, hệ thống thiết kế, tài liệu chi tiết từng tính năng (có bảng trạng thái + liên kết chéo), vận hành (triển khai, quy ước phiên bản, việc còn dở).

- **Cấu hình AI bằng giao diện** — dialog "Cấu hình AI" (Cài đặt → API Key & Webhook) thêm **ô nhập API Key** + chọn được đủ 5 provider + gõ tự do model. Key lưu **mã hoá AES-256-GCM** trong `AppSetting` (`getProviderApiKey` đọc DB trước, fallback `.env`); `/ai/providers` trả tất cả provider; thêm danh sách model mặc định. Không cần SSH sửa `.env` để bật AI nữa.

### Changed
- Trang **Sao lưu & Khôi phục**: mô tả đúng bản chất gói backup; chuyển các nút từ icon `mdi-*` sang Lucide (`AppIcon`) theo quy tắc thiết kế.
- **Header hội thoại (chat)**: nút action (Đã KB / Webhook…) gọn lại (cao 28px, cùng cỡ, thẳng hàng); header + hàng chip tự xuống dòng khi cột giữa hẹp thay vì bị cắt mất.

- **Đóng gói self-host cho khách** — thêm bộ `release/` (docker-compose dùng image dựng sẵn, `.env.example`, `Caddyfile` auto-HTTPS, `install.sh` tự sinh secret, `update.sh` backup-rồi-cập-nhật, `README` hướng dẫn) + `scripts/release.sh` (build & push image GHCR). Hỗ trợ cả 2 mô hình: source (git) và image dựng sẵn. Tài liệu [docs/van-hanh/phat-hanh.md](docs/van-hanh/phat-hanh.md).
- **Migration an toàn** — thay `prisma db push --accept-data-loss` bằng `docker/migrate-and-start.sh` → `prisma migrate deploy` + tự baseline DB cũ (`0_init`) → **cập nhật KHÔNG mất dữ liệu khách**. Migration squash về `0_init` = schema hiện tại.
- **Cài/cập nhật cho khách linh hoạt hơn** — `install.sh` kiểu **1 lệnh** (tự tải cấu hình, hỏi domain, tự sinh secret, tự cài Docker, kiểm tra RAM/HĐH); chọn **Caddy auto-HTTPS** hoặc **reverse proxy sẵn có** (tự phát hiện 80/443 bận) + **cổng tuỳ chỉnh** (`docker-compose.proxy.yml`). Bỏ mở cổng host cho db/redis/minio → **không đụng dịch vụ sẵn có** trên VPS khách. Đã publish image GHCR `ghcr.io/trinhleminhan-vn/uaemcrm` + repo deploy public `uaemcrm-deploy`.
- **Đổi thương hiệu "ZaloCRM" → "UAEM CRM"** — toàn bộ chuỗi user-facing (title, manifest/PWA, giao diện, folder Google Drive, README gói backup) + tài liệu. Viết lại `README.md` sạch, gỡ URL repo cũ. Giữ nguyên tên hạ tầng nội bộ (container/volume/đường dẫn) để không ảnh hưởng dữ liệu đang chạy; giữ "Zalo" khi chỉ nền tảng Zalo.

### Security
- **Bảo mật 2 lớp (2FA) đa phương thức** — TOTP (app authenticator) + Email OTP + Passkey (WebAuthn/FIDO2) + 10 mã khôi phục tải về. **Login 2 bước** (mật khẩu → yếu tố thứ 2 qua *challenge token* ngắn hạn, `scope`-gated không vào được API thường). Quản lý tại `/settings/personal/password`. Owner **bắt buộc 2FA toàn tổ chức** (`PUT /org/security`) → thành viên chưa bật bị **ép thiết lập TOTP ở lần đăng nhập kế tiếp**. Secret TOTP mã hoá AES-256-GCM; mã khôi phục/email hash SHA-256; thao tác nhạy cảm (tắt/xoá/tạo lại) yêu cầu nhập lại mật khẩu. Thêm **dịch vụ gửi email SMTP dùng chung** (`shared/email/mailer.ts`) cho Email OTP + thông báo sau này. Module `modules/two-factor/*`, component `frontend/src/components/security/*`. Migration `20260611120000_add_2fa`. Chi tiết: [Bảo mật 2 lớp](docs/tinh-nang/bao-mat-2-lop.md).
- **Chống brute-force đăng nhập** — thêm rate-limit riêng `POST /api/v1/auth/login` **10 lần/phút/IP** (trước chỉ có giới hạn chung 500/phút quá lỏng) + `POST /api/v1/setup` 5/phút. **Mật khẩu owner tối thiểu 8 ký tự** khi Thiết lập.
- **Tài liệu bảo mật** `docs/van-hanh/bao-mat.md` — phòng thủ nhiều lớp, mô hình superadmin/setup (đã khoá sau lần đầu), hướng dẫn **Cloudflare Zero Trust** tuỳ chọn (kèm danh sách path BYPASS cho webhook/public API), và bảo mật domain file (`files.<domain>` phải public cho Zalo CDN — chỉ proxy/WAF, không gate identity).

### Fixed
- **Compose chế độ proxy bị chặn** — biến `${APP_DOMAIN:?}`/`${S3_DOMAIN:?}` trong service `caddy` khiến compose bắt buộc domain dù không bật Caddy → đổi sang default rỗng (`:-`). Phát hiện khi test cài mới thật.
- **Redis không được dùng mặc định** dù container có sẵn → bật `REDIS_URL=redis://redis:6379` trong `.env.example` (cho BullMQ / FB lead workers).
- **Lưu cấu hình AI lỗi 500** khi `FB_TOKEN_ENC_KEY` chưa được đặt: `aes-gcm.getKey()` nay **fallback sang `ENCRYPTION_KEY`** (cùng dạng 64-hex) nếu `FB_TOKEN_ENC_KEY` trống — không cần đặt riêng key. Ảnh hưởng chung mọi chỗ mã hoá token (AI, Google Drive, Facebook).
- Thêm `<meta name="mobile-web-app-capable">` để bỏ cảnh báo deprecated của `apple-mobile-web-app-capable`.

## v3.3.1 — 28/05/2026

### Security

- **CRITICAL** Sửa SQL injection trong custom analytics report — `filters.source`/`filters.userId` từ request body bị concat thẳng vào `$queryRawUnsafe`, cho phép UNION-based extraction cross-tenant. Chuyển sang `prisma.$queryRaw` tagged template + `Prisma.sql` bound parameters.
- **CRITICAL** Nâng cấp `fast-jwt` lên 6.2.4 (vá CVE crit-header bypass) và 18 dependency backend khác qua `npm audit fix`. Frontend audit giảm từ 7 → 2 vuln.
- **HIGH** Bắt buộc xác thực trên các endpoint Zalo PII (`/api/v1/zalo-user-info/batch`, `/api/v1/zalo-user-info/:uid`, `/api/v1/zalo-sticker-list`) — trước đây không cần token, cho phép liệt kê số điện thoại/ngày sinh hàng loạt. Giới hạn batch từ 200 → 50 UID.
- **HIGH** Thêm SSRF guard cho webhook URL do org admin cấu hình (`modules/api/webhook-service.ts`) — chặn loopback, RFC1918, link-local (169.254/16), IPv6 ULA/link-local, non-HTTPS. Shared util `ssrf-guard.ts` cũng thay thế regex inline trong `zapier-webhook.ts`.
- **HIGH** Sửa IDOR và email enumeration oracle trong user-routes — member có thể tự đổi `email`/`teamId` của mình để chiếm password-reset. Thêm per-role field allowlist: member chỉ sửa `fullName`; admin thêm `email`+`teamId` (không tự sửa email); owner thêm `role`+`isActive`. Lỗi unique constraint trả về message chung, không lộ email tồn tại.
- **HIGH** Thay thế `xlsx` (SheetJS community, GHSA-4r6h-8v6p-xvw6 prototype pollution + ReDoS, không có bản vá) bằng `exceljs` trong modal import danh sách khách hàng. Lazy-import để giữ bundle nhỏ.
- **HIGH** MinIO: hard-fail khi thiếu `MINIO_ROOT_USER`/`MINIO_ROOT_PASSWORD` trong `.env` thay vì fallback về `minioadmin/minioadmin`.

### Hygiene

- Thêm `.env.bak*` và `.env.*.bak` vào `.gitignore` — ngăn commit nhầm file backup env.
- Bổ sung biến Facebook integration (`FB_GRAPH_API_VERSION`, `FB_APP_ID`, `FB_APP_SECRET`, `FB_WEBHOOK_VERIFY_TOKEN`, `FB_TOKEN_ENC_KEY`, `FB_OAUTH_REDIRECT_URI`) vào `.env.example` kèm hướng dẫn tạo.

### Upgrade notes

Thêm vào `.env` trước khi `docker compose up`:
```
MINIO_ROOT_USER=<admin-user>
MINIO_ROOT_PASSWORD=<strong-password>
```

## v3.3.0 — 25/05/2026

### Added
- Facebook Lead Ingestion: Meta OAuth, page connection, webhook verify/HMAC, lead queue, form auto-discovery.
- Tự tạo Customer List theo Facebook page/form và gán sale vòng tròn cho lead mới.
- Chuyển tiếp media trong chat: image, video, audio.
- Backfill/mirror ảnh/video inbound từ Zalo CDN sang MinIO/S3/R2.
- Cloudflare R2 config trong `.env.example`.
- Release screenshots tại `docs/release-images/v3.3/`.

### Changed
- Merge upstream `hsholding/main` qua branch `merge/hsholding-main-20260525`.
- Merge `feat/fb-lead-ingestion` vào `main`.
- Chat media pipeline dùng object storage nhất quán hơn cho preview và forward.
- `.env` parser xử lý secret/password có ký tự `#`.

### Fixed
- Fix issue #24: fallback JSON lỗi từ `getFriendOnlines`.
- Fix issue #25: nhận diện message type `webchat`.
- Fix thumbnail video không hiện.
- Fix kéo thả file/hình/video vào màn hình chat bị mất.
- Fix ảnh khách gửi đến còn lưu trực tiếp Zalo CDN thay vì mirror về object storage.

## v3.2.0 — 21/05/2026

### Added
- Bot-Auto framework: Blocks, Sequences, Triggers, Broadcasts, Customer Lists.
- Lead Scoring Phase 6: signal detector, auto-decay, auto tags, stuck lead dashboard.
- Customer Lists import CSV/Excel, column mapping, inline edit, undo delete.
- Scoring settings tại `/settings/crm/scoring`.
- Scripts hỗ trợ Phase 7 runner và setup test data.

### Changed
- Bot-Auto được đưa lên top-level navigation.
- Appointments, Friends, Zalo Accounts, Settings layout được redesign.
- Zalo Labels auto-sync khi connect/reconnect.
- Contact touch-profile endpoint bổ sung thông tin từ SDK khi mở conversation.

## v3.1.2 — 04/2026

### Fixed
- Sửa lỗi nhỏ sau v3.1 về đồng bộ, UI và ổn định listener.
- Cải thiện backfill DM history và xử lý duplicate contact.

## v3.1.1 — 04/2026

### Fixed
- Sửa lỗi phát sinh trong luồng tag/note/label.
- Cải thiện fallback AI parse khi quota provider bị giới hạn.

## v3.1.0 — 04/2026

### Added
- CRM Tag system riêng trong Settings.
- Notes thread trong hồ sơ khách hàng.
- Zalo Labels 2-way sync.
- DM history backfill endpoint và nút đồng bộ trong UI.
- DuplicateReviewDialog để rà soát/gộp khách hàng trùng.

### Changed
- Phone normalization theo `phoneNormalized`.
- Contact resolving ưu tiên key chuẩn hơn.

## v3.0.0 — 2026

### Added
- Chat attachments qua MinIO/S3: hình ảnh, video, file.
- Video player inline trong bubble.
- Friend model và FriendshipAttempt.
- Reaction multi-emoji đồng bộ hai chiều Zalo ↔ CRM.
- Sticker animated render qua proxy.
- Bank/QR card render theo style Zalo.
- Zalo user info popup.
- Contact merge theo Zalo globalId.
- Proxy per-account UI.

### Changed
- Redesign Chat, Contacts, Friends theo Smax style.
- Bổ sung Redis và object storage vào stack Docker.

### Fixed
- Fix duplicate message do shape `sendResult.message.msgId`.
- Fix image preview rỗng sau upload attachment.
- Fix reply preview attachment hiện raw JSON.
- Fix mention tô lố vùng text.

## v2.1 — 16/04/2026

### Added
- Tab "Khác" cho hội thoại không quan trọng.
- Tên khách hàng 2 lớp: CRM Name + Zalo Name.
- Bộ lọc hội thoại: chưa đọc, chưa trả lời, thời gian, tag.
- Quick template bằng phím `/`.
- Đồng bộ 50 tin nhắn cũ và selfListen dedup.

### Fixed
- Fix tên "Unknown".
- Fix PWA setup.
- Fix tin nhắn trùng khi gửi.

## v2.0.0 — 31/03/2026

### Added
- AI Assistant: gợi ý trả lời, tóm tắt, phân tích cảm xúc.
- Workflow Automation.
- Integration Hub: Google Sheets, Telegram, Facebook, Zapier.
- Mobile PWA.
- Contact Intelligence: gộp trùng, lead scoring, auto-tag.
- Advanced Analytics.
- Multi-provider AI: Anthropic, OpenAI, Gemini, Qwen, Kimi.
- Proxy per-account.

### Fixed
- Loại bỏ một số trường hợp tin nhắn hiển thị trùng.

## v1.0.0 — Khởi tạo

### Added
- Quản lý nhiều tài khoản Zalo cá nhân.
- Đăng nhập QR và tự reconnect.
- Chat real-time, gửi/nhận tin nhắn, ảnh, file, sticker, nhóm chat.
- Quản lý khách hàng theo pipeline.
- Lịch hẹn, dashboard, báo cáo Excel.
- Phân quyền Owner/Admin/Member.
- Public REST API và webhook.
- Chống block Zalo bằng giới hạn gửi và cảnh báo tốc độ.
- Tìm kiếm toàn hệ thống.
- Theme tối/sáng.
