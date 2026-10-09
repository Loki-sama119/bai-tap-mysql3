# Bài thực hành: Truy vấn dữ liệu MySQL – QuanLySinhVien

## Mục tiêu
Sử dụng câu lệnh `SELECT`, `WHERE` và `JOIN` để truy vấn dữ liệu từ cơ sở dữ liệu `QuanLySinhVien` đã tạo ở bài trước.

## Tệp bài làm
- [`QuanLySinhVien_Select.sql`](QuanLySinhVien_Select.sql): gồm đầy đủ **5 câu truy vấn** theo đề bài.

## Nội dung 5 truy vấn
1. Hiển thị tất cả học viên từ bảng `Student`.
2. Hiển thị học viên đang theo học (`Status = TRUE`).
3. Hiển thị môn học có `Credit < 10`.
4. Hiển thị học viên lớp `A1` bằng `JOIN Student` với `Class`.
5. Hiển thị điểm môn `CF` bằng `JOIN Student`, `Mark`, `Subject`.

> **Chú ý:** Đề bài gọi `Credit` là “thời gian học”, nhưng trong cấu trúc bảng cũ đây là trường `Credit` (số tín chỉ). Bài làm giữ nguyên điều kiện `Credit < 10` như đề hướng dẫn.

## Hướng dẫn chạy trên MySQL Workbench
1. Mở MySQL Workbench và kết nối đến MySQL Server.
2. Bảo đảm có cơ sở dữ liệu `QuanLySinhVien`, đủ các bảng `Student`, `Class`, `Subject`, `Mark` và dữ liệu đã nhập ở bài thực hành trước.
3. Mở file `QuanLySinhVien_Select.sql` bằng **File → Open SQL Script**.
4. Chạy các câu lệnh bằng nút tia sét. Có thể chọn từng câu để xem kết quả riêng trong **Result Grid**.
5. Chụp ảnh **Result Grid thực tế** của từng truy vấn (nếu giảng viên yêu cầu minh chứng).

## Kết quả dự kiến với dữ liệu mẫu từ bài trước
- Câu 1: `Hung`, `Hoa`, `Manh`.
- Câu 2: `Hung`, `Hoa`.
- Câu 3: `CF`, `C`, `HDJ`.
- Câu 4: `Hung`, `Hoa` thuộc lớp `A1`.
- Câu 5: `Hung` điểm `8`, `Hoa` điểm `10` môn `CF`.

Các kết quả trên chỉ đúng khi dữ liệu hiện tại khớp đúng bài INSERT trước đó; đây **không phải kết quả đã chạy kiểm thử**.

## Nộp bài lên GitHub
Tạo repository riêng (ví dụ `QuanLySinhVien-Select`) và tải file `.sql`, `README.md` lên, sau đó nộp URL repository trên CodeGym. Không nên dùng lại repository của bài tập khác.
