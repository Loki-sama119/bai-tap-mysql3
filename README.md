# Bài thực hành: Tạo CSDL Quản Lý Bán Hàng

## Mục tiêu
Tạo cơ sở dữ liệu **QuanLyBanHang** bằng các câu lệnh SQL, gồm bốn bảng trong mô hình đề bài và các ràng buộc khóa chính/khóa ngoại.

## Mô hình quan hệ
- `Customer`(**cID**, cName, cAge)
- `Product`(**pID**, pName, pPrice)
- `Order`(**oID**, cID [FK → Customer.cID], oDate, oTotalPrice)
- `OrderDetail`(**oID**, **pID**, odQTY), trong đó oID và pID là **khóa chính kép**, đồng thời là khóa ngoại tham chiếu `Order` và `Product`.

Quan hệ:
- `Customer` **1 – N** `Order`: một khách hàng có thể có nhiều đơn hàng; người chưa mua vẫn được lưu ở Customer.
- `Order` **1 – N** `OrderDetail`.
- `Product` **1 – N** `OrderDetail`.
- Từ đó `Order` **N – M** `Product` qua `OrderDetail`.

![Mo hinh quan he](images/MoHinhQuanHe.png)

## Các file
- **QuanLyBanHang.sql**: script DDL tạo database và bốn bảng (yêu cầu chính của đề).
- **DuLieuMau_KiemTra.sql**: script DML thử nghiệm, có thể chạy sau khi tạo bảng.
- **images/MoHinhQuanHe.png**: ảnh mô hình quan hệ để minh họa.

## Cách chạy bằng MySQL Workbench
1. Mở `QuanLyBanHang.sql`, nhấn **Execute All** (tia sét). Script **DROP TABLE** trước khi tạo lại nên sẽ xóa dữ liệu cũ trong bốn bảng nếu chạy lại.
2. Refresh **SCHEMAS**, mở `QuanLyBanHang → Tables` để xem đủ bốn bảng.
3. Chạy tùy chọn `DuLieuMau_KiemTra.sql` để thêm dữ liệu và xem hai truy vấn JOIN.
4. Chụp ảnh màn hình schema và truy vấn thật trên máy trước khi nộp nếu cần minh chứng chạy SQL.

## Ghi chú thiết kế
Đề bài không quy định độ dài chuỗi và kiểu số cụ thể, nên chọn `VARCHAR(100)`, `INT`, `DECIMAL` hợp lý. `Order` được bao trong dấu backtick vì là từ khóa SQL. `oTotalPrice` lưu trên đơn hàng theo sơ đồ, dữ liệu mẫu được nhập sao cho bằng tổng tiền hàng; nếu phát triển ứng dụng cần cập nhật lại tổng tiền khi thay đổi chi tiết đơn.

> Ảnh sơ đồ là bản vẽ minh họa, không phải ảnh chụp đã chạy MySQL Workbench. SQL cần được chạy trên MySQL để xác nhận môi trường thực tế.
