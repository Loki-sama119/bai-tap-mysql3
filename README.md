# HealthSync — Khắc phục lỗ hổng CSDL đặt lịch khám bệnh

Bộ thực hành phân tích sự khác biệt giữa Activity Diagram và ERD/MySQL legacy, đề xuất cải tiến có bảo toàn dữ liệu cũ, đồng thời cung cấp hai kịch bản mô phỏng.

## Thành phần
- `healthsync_db.sql`: DDL khởi tạo hoặc nâng cấp legacy database, trigger và DML kiểm thử 2 kịch bản.
- `consistency_report.md`: Báo cáo ba lỗ hổng chính, phương án xử lý, giới hạn.
- `ai_prompt_log.md`: Nhật ký phạm vi hỗ trợ AI và câu hỏi cần tự giải thích.

## Chạy trên MySQL Workbench
1. Kết nối tới MySQL Server 8.0.16+.
2. Mở `healthsync_db.sql` và chạy **một lần** trên database `healthsync_db` mới hoặc legacy chưa migrate.
3. Kiểm tra các kết quả `SELECT` ở cuối file và chụp ảnh bằng MySQL Workbench để làm minh chứng thực tế.
4. Dự kiến trong kịch bản hủy lịch: `deposit_amount = 300000`, `penalty_fee = 150000`, `refundable_deposit = 150000`, `status = CANCELLED`.
5. Dự kiến trong kịch bản thành công: `status = COMPLETED` và có một hàng `Prescriptions` liên kết.

**Chú ý:** File không thiết kế để chạy lại nguyên xi lần hai: các cột/trigger đã được tạo ở lần đầu. Đối với hệ thống thật, hãy sao lưu DB trước khi migrate. Dữ liệu lịch cũ bị thiếu thông tin cọc/trạng thái chi tiết, cần đối soát thủ công. Mã chỉ minh họa quy trình; chưa quản lý giao dịch thu cọc, lịch sử chuyển trạng thái hay concurrency toàn diện.

## Sơ đồ quan hệ (mô tả)
- `Patients (1) → (N) Appointments`
- `Doctors (1) → (N) Appointments`
- `Appointments (1) → (0..1) Prescriptions`

## Nộp bài
Upload **các file giải nén** lên repository GitHub riêng, không sử dụng repository của bài tập trước. Đọc hiểu nội dung và tự bổ sung ảnh chạy lệnh từ MySQL Workbench nếu giảng viên yêu cầu.
