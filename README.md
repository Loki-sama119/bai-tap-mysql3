# AutoRide — Nâng cấp CSDL thuê/trả xe (MySQL)

## Mục tiêu
Phân tích khoảng trống giữa quy trình nghiệp vụ và mô hình dữ liệu, nâng cấp `Rentals` bằng `ALTER TABLE`, bổ sung `Inspections`, kiểm soát trạng thái và mô phỏng số tiền hoàn lại.

## File
- `autoride_db.sql`: tạo schema mẫu legacy, nâng cấp bằng ALTER, tạo bảng Inspections, trigger, dữ liệu INSERT/UPDATE, SELECT kết quả.
- `er_activity_mapping.md`: báo cáo ba khoảng trống dữ liệu (dưới 200 từ).
- `ai_prompt_log.md`: nhật ký hỗ trợ AI và phần cần kiểm chứng.
- `images/AutoRide_ERD.png`: sơ đồ quan hệ thiết kế.

## Hướng dẫn chạy
1. Mở MySQL Workbench kết nối MySQL 8.0+.
2. Mở `autoride_db.sql`, chạy **một lần** từ đầu đến cuối trên môi trường thử nghiệm. Script tạo database `autoride_db` nếu chưa có.
3. Xem kết quả SELECT cuối script: Nguyễn Văn A hoàn 8.000.000đ; Trần Văn C hoàn 7.000.000đ (giả định phí trễ 1.000.000đ).
4. Chụp ảnh **thực tế** sơ đồ bảng, phần SELECT và kết quả `SHOW CREATE TABLE` nếu cần minh chứng.

**Lưu ý:** Script được thiết kế cho database mới/chưa được nâng cấp. Không chạy lặp lại trên bảng Rentals đã có các cột mới vì ALTER sẽ báo cột trùng. Nếu có dữ liệu legacy thực, sao lưu trước và kiểm tra các giá trị `status` trước khi MODIFY ENUM. Chưa xác nhận chạy thực tế trên MySQL Server của người nộp.

## Tóm tắt quan hệ
`Cars (1) — (N) Rentals (1) — (N) Inspections`.
