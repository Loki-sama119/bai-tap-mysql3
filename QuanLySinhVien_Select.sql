-- BAI THUC HANH: TRUY VAN DU LIEU - QUAN LY SINH VIEN
-- Yeu cau: Can co CSDL QuanLySinhVien va du lieu tu bai thuc hanh truoc.
USE QuanLySinhVien;

-- Cau 1: Hien thi tat ca hoc vien
SELECT *
FROM Student;

-- Cau 2: Hien thi cac hoc vien dang theo hoc (Status = 1)
SELECT *
FROM Student
WHERE Status = TRUE;

-- Cau 3: Hien thi cac mon hoc co Credit < 10
SELECT *
FROM Subject
WHERE Credit < 10;

-- Cau 4: Hien thi danh sach hoc vien lop A1
SELECT S.StudentId, S.StudentName, C.ClassName
FROM Student AS S
JOIN Class AS C ON S.ClassId = C.ClassID
WHERE C.ClassName = 'A1';

-- Cau 5: Hien thi diem mon CF cua cac hoc vien
SELECT S.StudentId, S.StudentName, Sub.SubName, M.Mark
FROM Student AS S
JOIN Mark AS M ON S.StudentId = M.StudentId
JOIN Subject AS Sub ON M.SubId = Sub.SubId
WHERE Sub.SubName = 'CF';
