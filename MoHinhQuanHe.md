# BÀI TẬP: CHUYỂN ĐỔI ERD SANG MÔ HÌNH QUAN HỆ

## Bước 1. Xác định thực thể

Sơ đồ đề bài có **5 thực thể**:

| Thực thể | Thuộc tính | Khóa chính |
|---|---|---|
| PHIEUXUAT | SoPX, NgayXuat | SoPX |
| VATTU | MaVTU, TenVTU | MaVTU |
| PHIEUNHAP | SoPN, NgayNhap | SoPN |
| DONDH | SoDH, NgayDH | SoDH |
| NHACC | MaNCC, TenNCC, DiaChi, SDT (đa trị) | MaNCC |

Các thuộc tính được gạch chân trong ERD gốc là khóa chính. `SDT` được vẽ bằng hình elip đôi nên là thuộc tính đa trị.

## Bước 2. Chuyển đổi các mối quan hệ

1. **Quan hệ 1 – Chi tiết phiếu xuất:** PHIEUXUAT (N) — VATTU (N), có thuộc tính DGXuat, SLXuat. Tạo bảng **CHITIET_PHIEUXUAT(SoPX, MaVTU, DGXuat, SLXuat)**. PK ghép (SoPX, MaVTU); hai cột cũng là FK.
2. **Quan hệ 2 – Chi tiết phiếu nhập:** VATTU (N) — PHIEUNHAP (N), có thuộc tính DGNhap, SLNhap. Tạo **CHITIET_PHIEUNHAP(SoPN, MaVTU, DGNhap, SLNhap)**. PK ghép (SoPN, MaVTU); hai cột cũng là FK.
3. **Quan hệ 3 – Chi tiết đơn đặt hàng:** VATTU (N) — DONDH (N); sơ đồ không thể hiện thuộc tính riêng của quan hệ này. Tạo **CHITIET_DONDH(SoDH, MaVTU)**. PK ghép (SoDH, MaVTU); hai cột cũng là FK. Không tự thêm số lượng hay giá đặt hàng vì không có trong ERD gốc.
4. **Quan hệ 4 – Cung cấp:** NHACC (1) — DONDH (N). Đưa **MaNCC** làm FK vào bảng **DONDH**; không cần bảng trung gian.

Sơ đồ không cho thấy quan hệ 1–1.

## Bước 3. Chuyển thuộc tính đa trị

`NHACC.SDT` là thuộc tính đa trị, do vậy tách thành **NHACC_SDT(MaNCC, SDT)**. Khóa chính ghép (MaNCC, SDT); MaNCC là khóa ngoại đến NHACC. Mỗi nhà cung cấp có thể lưu nhiều số điện thoại.

## Bước 4. Danh sách 9 bảng cuối cùng

```text
PHIEUXUAT(SoPX PK, NgayXuat)
VATTU(MaVTU PK, TenVTU)
PHIEUNHAP(SoPN PK, NgayNhap)
NHACC(MaNCC PK, TenNCC, DiaChi)
DONDH(SoDH PK, NgayDH, MaNCC FK -> NHACC.MaNCC)
CHITIET_PHIEUXUAT(SoPX PK/FK, MaVTU PK/FK, DGXuat, SLXuat)
CHITIET_PHIEUNHAP(SoPN PK/FK, MaVTU PK/FK, DGNhap, SLNhap)
CHITIET_DONDH(SoDH PK/FK, MaVTU PK/FK)
NHACC_SDT(MaNCC PK/FK, SDT PK)
```

**Quy ước:** `PK` là khóa chính, `FK` là khóa ngoại. Các cặp trường ghi `PK/FK` tạo thành khóa chính ghép trong bảng trung gian.

![Mô hình quan hệ sau chuyển đổi](images/MoHinhQuanHe.png)

**Lưu ý:** Đề bài chỉ yêu cầu chuyển đổi mô hình. Các kiểu dữ liệu trong file SQL tham khảo là giả định triển khai, vì hình ERD không quy định kiểu dữ liệu hoặc độ dài cột. Một chi tiết phiếu xuất/nhập được nhận diện bởi cặp mã phiếu và mã vật tư theo mô hình đã cho.
