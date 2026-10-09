# Nhật ký tương tác AI – FlashMart

> Minh bạch: Đây là bản ghi các câu hỏi kỹ thuật và câu trả lời tóm tắt từ cuộc trao đổi hiện tại với ChatGPT để tham khảo. Học viên cần tự chạy SQL, kiểm tra và điều chỉnh nội dung theo quá trình học thực tế; không nên mô tả các phép đo hiệu năng chưa thực hiện là đã thử nghiệm.

## 1. JOIN mặc định có giữ dòng không khớp không?
**Câu hỏi:** `JOIN` không có từ `LEFT`, `RIGHT` trong MySQL tương đương JOIN nào?

**Trả lời:** Tương đương `INNER JOIN`, chỉ giữ các dòng có khóa khớp giữa hai bảng. Vì vậy Charlie và Keyboard bị loại khỏi các truy vấn legacy.

## 2. Vì sao COUNT(*) sai với LEFT JOIN?
**Câu hỏi:** Vì sao dùng `COUNT(o.order_id)` thay cho `COUNT(*)` để tính số đơn theo khách?

**Trả lời:** Một khách không có đơn vẫn sinh ra một dòng kết quả trong `LEFT JOIN`, với tất cả cột `o.*` bằng `NULL`. `COUNT(*)` đếm dòng này thành 1; `COUNT(o.order_id)` bỏ qua `NULL` và trả 0.

## 3. LEFT JOIN + IS NULL khác NOT IN như thế nào?
**Câu hỏi:** Khi tìm sản phẩm chưa được bán, nên dùng `LEFT JOIN ... WHERE o.order_id IS NULL` hay `NOT IN`?

**Trả lời:** Cả anti-join và `NOT EXISTS` đều diễn đạt điều kiện không có giao dịch phù hợp; `NOT IN` có thể cho kết quả bất ngờ nếu truy vấn con trả `NULL`. Hiệu năng phụ thuộc chỉ mục, số lượng dữ liệu và kế hoạch thực thi. Để kiểm chứng, dùng `EXPLAIN` trên dữ liệu thật, tránh khẳng định lựa chọn nào luôn nhanh hơn.

## 4. Nested-loop Join là gì?
**Câu hỏi:** Thuật toán nested-loop join trong MySQL hoạt động ra sao và chỉ mục giúp gì?

**Trả lời:** Với mỗi dòng của đầu vào ngoài, bộ máy tìm các dòng khớp ở đầu vào trong. Chỉ mục trên cột JOIN, ví dụ `Orders.customer_id`, `Orders.product_id`, có thể giảm chi phí tìm kiếm. MySQL có nhiều chiến lược tối ưu theo phiên bản và thống kê; không nên mặc định mọi truy vấn đều có cùng kế hoạch.

## 5. Nếu đổi sang RIGHT JOIN mà giữ nguyên thứ tự bảng?
**Câu hỏi:** `Customers RIGHT JOIN Orders` có đáp ứng yêu cầu giữ tất cả khách không?

**Trả lời:** Không. Nó giữ tất cả bản ghi `Orders`, nên vẫn làm mất Charlie. Muốn giữ tất cả khách hàng theo cách rõ ràng nhất, đặt `Customers` bên trái và dùng `LEFT JOIN`.

## 6. CROSS JOIN là gì?
**Câu hỏi:** Khi nào JOIN tạo ra tích Descartes và nguy hiểm thế nào?

**Trả lời:** `CROSS JOIN` kết hợp mỗi hàng bảng A với mọi hàng bảng B (N × M hàng). Nếu thiếu điều kiện kết nối trong một phép JOIN, số kết quả có thể tăng đột biến, khiến truy vấn tốn thời gian và bộ nhớ.
