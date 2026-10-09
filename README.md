# Thực hành: Thêm dữ liệu vào CSDL QuanLySinhVien

## Mục tiêu
Sử dụng `INSERT INTO` để thêm dữ liệu vào bốn bảng đã được tạo trong bài thực hành trước: `Class`, `Student`, `Subject`, `Mark`.

## Cấu trúc bài nộp
- `QuanLySinhVien_Insert.sql`: thêm đầy đủ dữ liệu trong đề và truy vấn `SELECT` kiểm tra.
- `README.md`: hướng dẫn thực hành và nộp bài.

## Chuẩn bị
Bài này **dùng lại cơ sở dữ liệu `QuanLySinhVien` đã tạo ở bài trước**. Cần có sẵn các bảng và khóa ngoại:
- `Class(ClassID)`
- `Student(StudentID, ClassID)` với `ClassID` tham chiếu `Class`
- `Subject(SubID)`
- `Mark(MarkID, SubID, StudentID)` với `SubID` tham chiếu `Subject`, `StudentID` tham chiếu `Student`.

## Thực hiện trên MySQL Workbench
1. Kết nối MySQL Server, kiểm tra database `QuanLySinhVien` và 4 bảng có sẵn.
2. Mở file `QuanLySinhVien_Insert.sql`.
3. Chạy toàn bộ script **một lần**. Các câu lệnh `SELECT` ở cuối cho phép kiểm tra dữ liệu.
4. Chụp ảnh màn hình nội dung SQL và kết quả `SELECT` của 4 bảng.
5. Đưa ảnh chụp **thực tế** vào thư mục `images/` (tạo thư mục nếu cần), sau đó upload bài lên GitHub và nộp link repository.

## Dữ liệu mong đợi
| Bảng | Số bản ghi chèn |
| --- | ---: |
| Class | 3 |
| Student | 3 |
| Subject | 4 |
| Mark | 3 |

Lưu ý:
- Học viên Hoa không có số điện thoại: nhập `NULL`.
- `Class.StartDate` của B3 dùng `CURRENT_DATE()` theo đề, ngày cụ thể phụ thuộc ngày chạy SQL.
- Trong bảng `Mark`, đề yêu cầu điểm `12`; giữ nguyên. Nếu muốn giới hạn thang điểm 0–10, cần xác nhận lại với giảng viên trước khi sửa dữ liệu hoặc ràng buộc.
- Vì các mã khóa chính 1, 2, 3... được sử dụng, chạy script lặp lại trên cùng dữ liệu có thể báo trùng khóa; **không xóa dữ liệu cũ khi chưa sao lưu**.
- Nếu bảng `Student` đã có dữ liệu khiến AUTO_INCREMENT không bắt đầu từ 1, cần kiểm tra lại ID trước khi chèn `Mark`.

## Trình tự nộp GitHub
Giải nén rồi upload hai file `README.md` và `QuanLySinhVien_Insert.sql` vào một repository riêng, ví dụ `QuanLySinhVien-Insert`, không đưa nhầm file bài khác vào cùng repo. Đường dẫn nộp là link repository GitHub, không phải file ZIP hoặc chỉ bản ghi âm.
