# HealthSync — Báo cáo đối chiếu nghiệp vụ và dữ liệu (Gap Analysis)

## Ba điểm vênh nghiêm trọng

**1. Không lưu được vòng đời lịch hẹn.** Bảng `Appointments` cũ chỉ có `is_active` kiểu Boolean, không biểu diễn được năm trạng thái `PENDING`, `CONFIRMED`, `CHECKED_IN`, `COMPLETED` và `CANCELLED` trong quy trình. Vì vậy không xác định được lịch đã xác nhận cọc hay bệnh nhân đã khám xong. Thiết kế mới thay bằng `status ENUM(...)`. Dữ liệu cũ `TRUE/FALSE` chỉ được chuyển gần đúng sang `PENDING/CANCELLED` và cần được kiểm tra thủ công.

**2. Không theo dõi tiền cọc và khoản phạt khi hủy.** Cấu trúc cũ không có `deposit_amount`, `penalty_fee` và `cancel_reason`; kế toán không thể xác định số tiền giữ lại hoặc hoàn trả. Thiết kế mới dùng `DECIMAL(12,2)` thay vì `FLOAT`, đồng thời giới hạn khoản phạt không âm, không vượt tiền cọc. Số tiền hoàn lại được tính bằng tiền cọc trừ phí phạt. Trong ví dụ, cọc 300.000đ, phạt 150.000đ, hoàn 150.000đ.

**3. Không tồn tại bảng đơn thuốc.** Quy trình yêu cầu bác sĩ kê thuốc sau khi khám `COMPLETED`, nhưng database cũ không có nơi lưu đơn. Bảng `Prescriptions` được bổ sung với khóa ngoại `appointment_id`, thông tin thuốc và ngày kê; khóa `UNIQUE(appointment_id)` thể hiện tối đa một đơn cho mỗi lịch. Trigger ngăn kê đơn khi trạng thái khác `COMPLETED`.

## Kết luận và giới hạn

Mô hình mới khớp các bước cần lưu trữ trong Activity Diagram và hỗ trợ kiểm thử hai kịch bản. Các ràng buộc hiện tại chưa kiểm soát đầy đủ mọi chuyển trạng thái (ví dụ `PENDING` sang `COMPLETED` trực tiếp), và không xác minh giao dịch nộp cọc thực tế; nếu triển khai sản phẩm cần thêm bảng giao dịch thanh toán, nhật ký trạng thái và kiểm soát chuyển trạng thái ở service/trigger.
