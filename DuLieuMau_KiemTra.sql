-- Chay SAU QuanLyBanHang.sql. Du lieu mau de chung minh cac quan he.
USE QuanLyBanHang;
INSERT INTO `Customer` (`cName`, `cAge`) VALUES
('Nguyen Van A', 22), ('Tran Thi B', 30), ('Le Van C', 25);
INSERT INTO `Product` (`pName`, `pPrice`) VALUES
('But bi', 5000.00), ('Vo hoc sinh', 12000.00), ('Thuoc ke', 8000.00);
INSERT INTO `Order` (`cID`, `oDate`, `oTotalPrice`) VALUES
(1, '2026-10-09 08:00:00', 22000.00),
(1, '2026-10-09 09:00:00', 16000.00),
(2, '2026-10-09 10:00:00', 12000.00);
INSERT INTO `OrderDetail` (`oID`, `pID`, `odQTY`) VALUES
(1, 1, 2), (1, 2, 1), (2, 3, 2), (3, 2, 1);

-- LEFT JOIN de hien thi ca khach hang chua mua hang.
SELECT c.cID, c.cName, o.oID, o.oDate, o.oTotalPrice
FROM `Customer` c LEFT JOIN `Order` o ON c.cID = o.cID
ORDER BY c.cID, o.oID;

-- Chi tiet hoa don va thanh tien tung mat hang.
SELECT o.oID, c.cName, p.pName, d.odQTY, p.pPrice,
       d.odQTY * p.pPrice AS thanh_tien
FROM `OrderDetail` d
JOIN `Order` o ON o.oID = d.oID
JOIN `Customer` c ON c.cID = o.cID
JOIN `Product` p ON p.pID = d.pID
ORDER BY o.oID, p.pID;
