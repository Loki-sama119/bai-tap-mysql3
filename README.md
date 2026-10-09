# Bài tập: Truy vấn dữ liệu với CSDL Quản lý sinh viên

## Mục tiêu
Thực hành các câu lệnh `SELECT`, `WHERE`, `LIKE`, `MONTH`, `BETWEEN`, `UPDATE`, `JOIN` và `ORDER BY` trong MySQL.

## Tệp bài làm
- `QuanLySinhVien_TruyVanNangCao.sql` — đủ 5 yêu cầu trong đề; câu 4 có lệnh kiểm tra dữ liệu sau cập nhật.

## Yêu cầu trước khi chạy
Đã có CSDL `QuanLySinhVien` và bốn bảng `Class`, `Student`, `Subject`, `Mark`, cùng dữ liệu từ bài thực hành trước. Tệp này **không tạo lại** cơ sở dữ liệu và bảng.

## Năm yêu cầu
1. Sinh viên có tên bắt đầu bằng chữ `h`: `LIKE 'h%'` (không phân biệt chữ hoa/thường với collation MySQL thông dụng dạng `_ci`).
2. Lớp học bắt đầu tháng 12: `MONTH(StartDate) = 12`.
3. Môn học có tín chỉ trong đoạn `[3, 5]`: `Credit BETWEEN 3 AND 5`.
4. Chuyển sinh viên tên `Hung` sang lớp có `ClassID = 2`: `UPDATE` (thay đổi dữ liệu thực).
5. Hiển thị `StudentName`, `SubName`, `Mark` và sắp xếp `Mark DESC, StudentName ASC`.

## Cách chạy trên MySQL Workbench
1. Mở tệp `.sql` và chọn kết nối MySQL.
2. Chạy câu `USE` và các câu `SELECT` để kiểm tra trước.
3. **Chỉ khi muốn đổi lớp cho Hung**, chạy riêng câu `UPDATE Student ... WHERE StudentName = 'Hung'` rồi chạy câu `SELECT` kiểm tra.
4. Chụp Result Grid của các truy vấn đã thực thi. Đây là ảnh minh chứng thật; không thay bằng ảnh mô phỏng.
5. Tải hai tệp lên một repository GitHub công khai; có thể thêm ảnh chụp thật trong thư mục `images/`. Nộp đường dẫn repository theo yêu cầu CodeGym.

## Lưu ý
- `LIKE 'h%'` thường khớp cả `Hung` trên CSDL có collation không phân biệt hoa thường. Nếu collation phân biệt hoa thường và đề muốn cả hai, có thể dùng `LOWER(StudentName) LIKE 'h%'`.
- Lệnh `UPDATE` cập nhật tất cả sinh viên có cùng tên `Hung`. Nếu yêu cầu cập nhật duy nhất một sinh viên, nên dùng `StudentID` để xác định bản ghi.
- Nếu chưa có dữ liệu, các truy vấn có thể trả về bảng rỗng.
