# Thực hành: Tạo bảng trong CSDL QuanLyDiemThi

## Mục tiêu
Tạo cơ sở dữ liệu `QuanLyDiemThi` gồm **4 bảng** bằng SQL trên MySQL Workbench; thiết lập khóa chính (PK), khóa ngoại (FK) và quan hệ giữa các bảng.

## Cấu trúc bảng

| Bảng | Cột | Ràng buộc |
|---|---|---|
| `HocSinh` | `MaHS VARCHAR(20)`, `TenHS VARCHAR(50)`, `NgaySinh DATETIME`, `Lop VARCHAR(20)`, `GT VARCHAR(20)` | PK: `MaHS` |
| `GiaoVien` | `MaGV VARCHAR(20)`, `TenGV VARCHAR(50)`, `SDT VARCHAR(10)` | PK: `MaGV` |
| `MonHoc` | `MaMH VARCHAR(50)`, `TenMH VARCHAR(50)`, `MaGV VARCHAR(20)` | PK: `MaMH`; FK: `MaGV` → `GiaoVien.MaGV` |
| `BangDiem` | `MaHS VARCHAR(20)`, `MaMH VARCHAR(50)`, `DiemThi INT`, `NgayKT DATETIME` | PK ghép: (`MaHS`, `MaMH`); FK tới `HocSinh` và `MonHoc` |

> **Lưu ý:** Bảng mô tả yêu cầu quy định `MonHoc.MaMH VARCHAR(50)`; ví dụ ở Bước 4 ghi `VARCHAR(20)` nhưng `BangDiem.MaMH` lại là `VARCHAR(50)`. Bài làm thống nhất **`VARCHAR(50)`** để khóa ngoại có kiểu tương thích và đúng bảng yêu cầu.

## Quan hệ

- `GiaoVien` (1) → (N) `MonHoc`: một giáo viên có thể dạy nhiều môn.
- `HocSinh` (1) → (N) `BangDiem`: mỗi học sinh có thể có điểm ở nhiều môn.
- `MonHoc` (1) → (N) `BangDiem`: mỗi môn có thể có điểm của nhiều học sinh.
- `BangDiem` là bảng liên kết giữa học sinh và môn học; khóa chính ghép `(MaHS, MaMH)` chỉ cho phép một bản ghi trên mỗi cặp học sinh–môn học.

## Chạy trên MySQL Workbench

1. Mở MySQL Workbench và kết nối `Localhost`.
2. Mở file `QuanLyDiemThi.sql` (**File → Open SQL Script**), hoặc dán nội dung vào một tab SQL.
3. Chạy các câu lệnh. CSDL `QuanLyDiemThi` và bốn bảng sẽ được tạo nếu chưa tồn tại.
4. Nhấn làm mới **SCHEMAS**, mở rộng `QuanLyDiemThi → Tables` để kiểm tra đủ bốn bảng.
5. Xem kết quả của `SHOW TABLES;` và `SHOW CREATE TABLE` để kiểm tra khóa chính, khóa ngoại.

**Lưu ý:** `CREATE TABLE IF NOT EXISTS` không tự sửa cấu trúc bảng đã có sẵn. Nếu các bảng đã tồn tại với cấu trúc sai, cần kiểm tra trước khi thay đổi; tránh xóa dữ liệu.

## Minh chứng thực hiện

Sau khi chạy **trên máy của bạn**, chụp các ảnh thực tế và đặt vào thư mục `images/` với tên:

- `01_danh_sach_bang.png`: `QuanLyDiemThi → Tables` gồm bốn bảng và kết quả `SHOW TABLES;`.
- `02_khoa_ngoai_MonHoc.png`: kết quả `SHOW CREATE TABLE MonHoc` cho thấy FK `MaGV`.
- `03_khoa_chinh_ngoai_BangDiem.png`: kết quả `SHOW CREATE TABLE BangDiem` cho thấy PK ghép và hai FK.

Nếu có ảnh, bỏ dấu chú thích ở các dòng sau để hiển thị trực tiếp trên GitHub:

<!-- ![Danh sách 4 bảng](images/01_danh_sach_bang.png) -->
<!-- ![Khóa ngoại bảng MonHoc](images/02_khoa_ngoai_MonHoc.png) -->
<!-- ![Khóa chính và khóa ngoại bảng BangDiem](images/03_khoa_chinh_ngoai_BangDiem.png) -->

## Trạng thái

File SQL và tài liệu đã được chuẩn bị; **chưa có xác nhận đã chạy trên MySQL Workbench của người nộp**. Ảnh kết quả phải là ảnh chụp thật sau khi chạy.
