-- BAI TAP: TRUY VAN DU LIEU VOI CSDL QUAN LY SINH VIEN
-- Su dung CSDL QuanLySinhVien da tao va nhap du lieu tu bai truoc.
USE QuanLySinhVien;

-- CAU 1: Sinh vien co ten bat dau bang chu h (khong phan biet hoa thuong tuy collation).
SELECT *
FROM Student
WHERE StudentName LIKE 'h%';

-- CAU 2: Lop hoc bat dau vao thang 12 (tat ca cac nam).
SELECT *
FROM Class
WHERE MONTH(StartDate) = 12;

-- CAU 3: Mon hoc co Credit tu 3 den 5, bao gom 3 va 5.
SELECT *
FROM Subject
WHERE Credit BETWEEN 3 AND 5;

-- CAU 4: Doi ClassID cua sinh vien Hung thanh 2.
-- Chay rieng cau lenh nay khi muon thay doi du lieu.
UPDATE Student
SET ClassID = 2
WHERE StudentName = 'Hung';

-- Kiem tra sau khi cap nhat.
SELECT StudentID, StudentName, ClassID
FROM Student
WHERE StudentName = 'Hung';

-- CAU 5: Diem mon hoc cua sinh vien; diem giam dan, trung diem thi ten tang dan.
SELECT s.StudentName, sub.SubName, m.Mark
FROM Student AS s
JOIN Mark AS m ON s.StudentID = m.StudentID
JOIN Subject AS sub ON m.SubID = sub.SubID
ORDER BY m.Mark DESC, s.StudentName ASC;
