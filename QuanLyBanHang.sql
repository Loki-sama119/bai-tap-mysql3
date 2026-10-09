-- Bai thuc hanh: Tao CSDL QuanLyBanHang
-- MySQL 8.x; chay toan bo script trong MySQL Workbench.
CREATE DATABASE IF NOT EXISTS QuanLyBanHang CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE QuanLyBanHang;

-- Xoa bang con truoc khi tao lai de co the chay lai script.
DROP TABLE IF EXISTS `OrderDetail`;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS `Product`;
DROP TABLE IF EXISTS `Customer`;

CREATE TABLE `Customer` (
    `cID` INT NOT NULL AUTO_INCREMENT,
    `cName` VARCHAR(100) NOT NULL,
    `cAge` INT,
    CONSTRAINT `PK_Customer` PRIMARY KEY (`cID`),
    CONSTRAINT `CHK_Customer_Age` CHECK (`cAge` IS NULL OR `cAge` >= 0)
) ENGINE=InnoDB;

CREATE TABLE `Product` (
    `pID` INT NOT NULL AUTO_INCREMENT,
    `pName` VARCHAR(100) NOT NULL,
    `pPrice` DECIMAL(12,2) NOT NULL,
    CONSTRAINT `PK_Product` PRIMARY KEY (`pID`),
    CONSTRAINT `CHK_Product_Price` CHECK (`pPrice` >= 0)
) ENGINE=InnoDB;

-- Order la tu khoa SQL, do do dung dau backtick.
CREATE TABLE `Order` (
    `oID` INT NOT NULL AUTO_INCREMENT,
    `cID` INT NOT NULL,
    `oDate` DATETIME NOT NULL,
    `oTotalPrice` DECIMAL(14,2) NOT NULL DEFAULT 0,
    CONSTRAINT `PK_Order` PRIMARY KEY (`oID`),
    CONSTRAINT `FK_Order_Customer` FOREIGN KEY (`cID`) REFERENCES `Customer` (`cID`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `CHK_Order_Total` CHECK (`oTotalPrice` >= 0)
) ENGINE=InnoDB;

CREATE TABLE `OrderDetail` (
    `oID` INT NOT NULL,
    `pID` INT NOT NULL,
    `odQTY` INT NOT NULL,
    CONSTRAINT `PK_OrderDetail` PRIMARY KEY (`oID`, `pID`),
    CONSTRAINT `FK_OrderDetail_Order` FOREIGN KEY (`oID`) REFERENCES `Order` (`oID`)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `FK_OrderDetail_Product` FOREIGN KEY (`pID`) REFERENCES `Product` (`pID`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `CHK_OrderDetail_Qty` CHECK (`odQTY` > 0)
) ENGINE=InnoDB;

-- Kiem tra cau truc sau khi tao.
SHOW TABLES;
SHOW CREATE TABLE `Customer`;
SHOW CREATE TABLE `Product`;
SHOW CREATE TABLE `Order`;
SHOW CREATE TABLE `OrderDetail`;
