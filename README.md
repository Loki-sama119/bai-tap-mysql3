# FlashMart – Sửa lỗi JOIN trong báo cáo Marketing và Kho vận

Bài thực hành MySQL về `INNER JOIN`, `LEFT JOIN`, anti-join và `COUNT`.

## File nộp chính
- [`flashmart_reports.sql`](flashmart_reports.sql): tạo database/bảng, nhập dữ liệu, chạy 2 báo cáo và thống kê đối chiếu.
- [`join_analysis.md`](join_analysis.md): giải thích vì sao cần `COUNT(o.order_id)` thay `COUNT(*)` (dưới 150 từ).
- [`ai_prompt_log.md`](ai_prompt_log.md): các câu hỏi và trả lời kỹ thuật liên quan JOIN (AI hỗ trợ tham khảo).

## Cách chạy
1. Mở MySQL Workbench, kết nối MySQL Server.
2. Mở `flashmart_reports.sql` và chạy toàn bộ script (Execute All).
3. Xem ba Result Grid và đối chiếu với kết quả dự kiến bên dưới.
4. Chụp ảnh màn hình **thật** của hai báo cáo nếu cần minh chứng. Không dùng ảnh mô phỏng AI làm bằng chứng thực thi.

> **Cảnh báo:** Script xóa và tạo lại ba bảng demo `Orders`, `Products`, `Customers` thuộc database `flashmart_db`. Chỉ chạy trong môi trường thực hành.

## Kết quả dự kiến

**Báo cáo Marketing**:

| customer_id | name | total_orders |
|---|---|---|
| 1 | Alice | 2 |
| 2 | Bob | 1 |
| 3 | Charlie | 0 |

**Báo cáo Kho vận**:

| product_id | product_name |
|---|---|
| 103 | Keyboard |

## Giải thích ngắn
`INNER JOIN` chỉ giữ bản ghi khớp nên bỏ mất Charlie và Keyboard. `LEFT JOIN` giữ các dòng của bảng bên trái; `WHERE o.order_id IS NULL` tìm được sản phẩm chưa có đơn hàng.

## Trạng thái xác minh
Mã nguồn được kiểm tra nội dung và cấu trúc gói file. **Chưa chạy thực tế trên MySQL Server** trong môi trường này; các bảng kết quả ở trên là kết quả suy ra từ dữ liệu mẫu, không phải ảnh thực thi.
