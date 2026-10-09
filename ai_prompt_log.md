# Nhật ký tương tác AI — HealthSync

> Đây là bản ghi trung thực về nội dung trao đổi trong phiên làm bài này. AI đã hỗ trợ dựng bộ hồ sơ theo yêu cầu; người học cần tự kiểm tra, chạy thử, hiểu và bảo vệ thiết kế. Không trình bày các câu hỏi gợi ý dưới đây như những lần tự nhập prompt riêng nếu chưa thực hiện.

## Yêu cầu thực tế đã gửi AI

- Người học cung cấp toàn văn đề thực hành HealthSync, bao gồm legacy SQL, kịch bản nghiệp vụ, tiêu chí và yêu cầu tạo bộ nộp đầy đủ.
- Yêu cầu cuối: “tạo full cho toi để tôi nộp”.

## Nội dung AI hỗ trợ và quyết định thiết kế

1. **Lifecycle:** Đề bài cho biết Boolean `is_active` không biểu đạt được 5 trạng thái; giải pháp là `status ENUM('PENDING','CONFIRMED','CHECKED_IN','COMPLETED','CANCELLED')`.
2. **Độ chính xác tài chính:** Dùng `DECIMAL(12,2)` để tránh sai số biểu diễn nhị phân có thể gặp ở `FLOAT`/`DOUBLE` khi xử lý tiền tệ; ràng buộc `penalty_fee BETWEEN 0 AND deposit_amount`.
3. **Quan hệ đơn thuốc:** Dùng khóa ngoại `Prescriptions.appointment_id` và `UNIQUE` để biểu diễn 0..1 đơn thuốc trên mỗi lịch hẹn.
4. **Bảo toàn dữ liệu cũ:** Ưu tiên `ALTER TABLE`, không `DROP TABLE`; chuyển dữ liệu Boolean cũ một cách thận trọng, ghi nhận giới hạn suy diễn.
5. **Ràng buộc nghiệp vụ:** Trigger từ chối thêm/sửa đơn thuốc nếu lịch chưa `COMPLETED` và ngăn đổi trạng thái đã hoàn tất thành trạng thái khác khi đã có đơn thuốc.
6. **ON DELETE:** Chọn `RESTRICT` với Prescriptions để tránh vô tình mất hồ sơ kê thuốc; `ON UPDATE CASCADE` cho khóa tham chiếu. Đây là lựa chọn thiết kế, không phải quy định pháp lý về lưu trữ hồ sơ.

## Câu hỏi cần tự bảo vệ trước giảng viên

- Vì sao `is_active` là anti-pattern cho vòng đời nhiều trạng thái?
- Vì sao `DECIMAL` phù hợp hơn `FLOAT` khi lưu khoản cọc và phí phạt?
- Vì sao `UNIQUE(appointment_id)` tạo quan hệ 1–0..1, thay vì 1–N?
- Trigger chặn kê đơn cho lịch PENDING như thế nào? Có cần chặn cả các chuyển trạng thái nhảy cóc không?
- Vì sao không dùng `ON DELETE CASCADE` để xóa đơn thuốc?

## Kiểm chứng

Mã được chuẩn bị để chạy trên MySQL 8.0.16+; cần tự thực thi tại MySQL Workbench để xác nhận `ALTER`, trigger, hai kịch bản và kết quả SELECT. Không tuyên bố đã chạy thực tế khi chưa có ảnh/log bằng chứng.
