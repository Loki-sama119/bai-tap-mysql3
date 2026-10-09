# Đối chiếu Activity Diagram và ERD AutoRide

**1. Thiếu dữ liệu tài chính:** Bản cũ không lưu `security_deposit`, `late_fee`, `damage_fee`. Đặc biệt, **`damage_fee` bắt buộc phải có** vì tiền sửa chữa là khoản khấu trừ trực tiếp từ tiền cọc. Nếu không lưu, kế toán không thể chứng minh căn cứ hoàn tiền, truy thu chi phí hay đối soát doanh thu. Công thức: `refund = security_deposit - late_fee - damage_fee`.

**2. Thiếu biên bản kiểm tra:** Bảng `Inspections` riêng liên kết với `Rentals` qua `rental_id` cho phép ghi ngày kiểm tra, người kiểm tra và mô tả hư hỏng. Thiết kế 1–N hỗ trợ tái kiểm tra mà không lặp dữ liệu hợp đồng.

**3. Trạng thái thiếu kiểm soát:** `VARCHAR(50)` cho phép nhập trạng thái tùy ý, gây sai nhánh quy trình. Đổi sang `ENUM('BOOKED','ACTIVE','COMPLETED','CANCELLED')` để giới hạn giá trị; trigger ngăn thêm biên bản khi hợp đồng chưa `ACTIVE`.

**Quy tắc dữ liệu:** Các cột tiền dùng `DECIMAL(12,2)` thay vì `FLOAT` để tránh sai số nhị phân; phí mặc định `0.00`, ràng buộc không âm. Khóa ngoại `Inspections.rental_id` dùng `ON DELETE RESTRICT` để tránh xóa hợp đồng đang có biên bản.
