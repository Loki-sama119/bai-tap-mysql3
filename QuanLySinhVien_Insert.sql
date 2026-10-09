-- BAI THUC HANH: THEM DU LIEU VAO CSDL QUAN LY SINH VIEN
-- Yeu cau: Da tao CSDL QuanLySinhVien voi 4 bang Class, Student, Subject, Mark.
-- Chay script nay 1 lan tren CSDL da co cac bang.
USE QuanLySinhVien;

-- 1. CLASS
INSERT INTO `Class` (`ClassID`, `ClassName`, `StartDate`, `Status`) VALUES
(1, 'A1', '2008-12-20', b'1'),
(2, 'A2', '2008-12-22', b'1'),
(3, 'B3', CURRENT_DATE(), b'0');

-- 2. STUDENT (StudentID AUTO_INCREMENT)
INSERT INTO `Student` (`StudentName`, `Address`, `Phone`, `Status`, `ClassID`) VALUES
('Hung', 'Ha Noi', '0912113113', b'1', 1),
('Hoa', 'Hai phong', NULL, b'1', 1),
('Manh', 'HCM', '0123123123', b'0', 2);

-- 3. SUBJECT
INSERT INTO `Subject` (`SubID`, `SubName`, `Credit`, `Status`) VALUES
(1, 'CF', 5, b'1'),
(2, 'C', 6, b'1'),
(3, 'HDJ', 5, b'1'),
(4, 'RDBMS', 10, b'1');

-- 4. MARK (MarkID AUTO_INCREMENT)
-- Diem 12 duoc giu nguyen theo de bai; schema truoc do CHECK Mark BETWEEN 0 AND 100.
INSERT INTO `Mark` (`SubID`, `StudentID`, `Mark`, `ExamTimes`) VALUES
(1, 1, 8, 1),
(1, 2, 10, 2),
(2, 1, 12, 1);

-- 5. KIEM TRA DU LIEU (MySQL Workbench hien thi 4 result sets)
SELECT `ClassID`, `ClassName`, `StartDate`, CAST(`Status` AS UNSIGNED) AS `Status` FROM `Class` ORDER BY `ClassID`;
SELECT `StudentID`, `StudentName`, `Address`, `Phone`, CAST(`Status` AS UNSIGNED) AS `Status`, `ClassID` FROM `Student` ORDER BY `StudentID`;
SELECT `SubID`, `SubName`, `Credit`, CAST(`Status` AS UNSIGNED) AS `Status` FROM `Subject` ORDER BY `SubID`;
SELECT `MarkID`, `SubID`, `StudentID`, `Mark`, `ExamTimes` FROM `Mark` ORDER BY `MarkID`;
