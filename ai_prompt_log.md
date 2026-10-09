# AI Prompt Log — AutoRide

> Nhật ký minh bạch cho lần trao đổi này. Người học cần đọc, chạy thử và tự giải thích quyết định thiết kế trước khi nộp; không trình bày các bước chưa thực hiện là đã làm.

## Câu hỏi/nhóm vấn đề đưa ra cho AI

**Ngữ cảnh:** Người học gửi yêu cầu bài AutoRide và yêu cầu tiếp tục chuẩn bị bộ bài nộp, bao gồm SQL, phân tích và nhật ký.

1. **Kiểu tiền:** Vì sao `security_deposit`, `late_fee`, `damage_fee` nên dùng `DECIMAL` thay vì `FLOAT`?  
   **Kết luận:** `DECIMAL(12,2)` lưu chính xác số thập phân tiền tệ; dùng `DEFAULT 0.00` và `CHECK (>= 0)`.
2. **Quan hệ:** Thiết kế `Rentals` – `Inspections` theo 1–1 hay 1–N?  
   **Kết luận:** Chọn 1–N để có thể ghi nhiều biên bản kiểm tra khi phát sinh tái kiểm tra.
3. **Tính toàn vẹn:** Chặn kiểm tra xe khi hợp đồng vẫn `BOOKED` thế nào?  
   **Kết luận:** Trigger `BEFORE INSERT` trên `Inspections` kiểm tra `Rentals.status` và dùng `SIGNAL` khi sai.
4. **Khóa ngoại:** Tại sao `ON DELETE RESTRICT`?  
   **Kết luận:** Không cho xóa hợp đồng nếu còn biên bản cần truy vết.
5. **Giá trị NULL:** Tránh kết quả hoàn tiền thành NULL thế nào?  
   **Kết luận:** Các cột tài chính `NOT NULL DEFAULT 0.00` và công thức trừ trực tiếp.

## Phần cần tự xác minh

- Chạy `autoride_db.sql` trong MySQL Workbench (MySQL 8.0+), lưu ảnh `SHOW CREATE TABLE` và kết quả `SELECT`.
- Kiểm tra trigger bằng ca `BOOKED` trên dữ liệu thử.
- Đảm bảo quy định mức phí phạt thực tế được thống nhất với BA (trong ví dụ thứ hai chỉ giả định 1.000.000đ cho 2 ngày trả trễ).
