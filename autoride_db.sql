-- AUTORIDE | MySQL 8.0+ | DDL + DML + TEST
-- Chay toan bo script trong MySQL Workbench (database rieng).
-- Buoc dau mo phong schema legacy, tiep do dung ALTER TABLE nang cap.
CREATE DATABASE IF NOT EXISTS autoride_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE autoride_db;

-- A. Khoi tao phien ban legacy (chi tao neu chua co)
CREATE TABLE IF NOT EXISTS Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,
    status VARCHAR(50) DEFAULT 'BOOKED',
    CONSTRAINT fk_rentals_car FOREIGN KEY (car_id)
        REFERENCES Cars(car_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- B. Nang cap co so du lieu KHONG xoa Rentals va khong lam mat du lieu cu
-- Gia dinh du lieu cu chi su dung BOOKED / ACTIVE / COMPLETED / CANCELLED.
ALTER TABLE Rentals
    MODIFY COLUMN status ENUM('BOOKED','ACTIVE','COMPLETED','CANCELLED')
        NOT NULL DEFAULT 'BOOKED',
    ADD COLUMN security_deposit DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ADD COLUMN late_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ADD COLUMN damage_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ADD CONSTRAINT chk_rentals_nonnegative CHECK (
        security_deposit >= 0 AND late_fee >= 0 AND damage_fee >= 0
    );

CREATE TABLE IF NOT EXISTS Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT,
    inspector_name VARCHAR(100) NOT NULL,
    CONSTRAINT fk_inspections_rental FOREIGN KEY (rental_id)
        REFERENCES Rentals(rental_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- C. Trigger bao ve quy trinh: khong kiem tra xe truoc khi nhan (BOOKED)
DROP TRIGGER IF EXISTS trg_inspections_before_insert;
DELIMITER $$
CREATE TRIGGER trg_inspections_before_insert
BEFORE INSERT ON Inspections
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    SELECT status INTO v_status
    FROM Rentals WHERE rental_id = NEW.rental_id;
    IF v_status IS NULL OR v_status NOT IN ('ACTIVE','COMPLETED') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Chi duoc lap bien ban khi hop dong ACTIVE hoac COMPLETED';
    END IF;
END$$
DELIMITER ;

-- D. Mo phong nghiep vu 1: coc 10 trieu, vo den pha, phat 2 trieu, hoan 8 trieu
INSERT INTO Cars (model_name, license_plate)
VALUES ('Toyota Vios', '30A-12345');
SET @car1 := LAST_INSERT_ID();

INSERT INTO Rentals (car_id, customer_name, rent_date, return_date, status, security_deposit)
VALUES (@car1, 'Nguyen Van A', '2026-10-01 08:00:00', '2026-10-03 08:00:00', 'BOOKED', 10000000.00);
SET @rental1 := LAST_INSERT_ID();

UPDATE Rentals SET status = 'ACTIVE' WHERE rental_id = @rental1;
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (@rental1, '2026-10-03 08:15:00', 'Vo den pha trai', 'Tran Thi B');
UPDATE Rentals
SET status = 'COMPLETED', late_fee = 0.00, damage_fee = 2000000.00,
    return_date = '2026-10-03 08:00:00'
WHERE rental_id = @rental1;

-- E. Mo phong nghiep vu 2: tra tre 2 ngay + den pha hong (de van dap)
INSERT INTO Cars (model_name, license_plate)
VALUES ('Hyundai Accent', '30A-67890');
SET @car2 := LAST_INSERT_ID();
INSERT INTO Rentals (car_id, customer_name, rent_date, return_date, status, security_deposit)
VALUES (@car2, 'Tran Van C', '2026-10-02 08:00:00', '2026-10-06 08:00:00', 'BOOKED', 10000000.00);
SET @rental2 := LAST_INSERT_ID();
UPDATE Rentals SET status = 'ACTIVE' WHERE rental_id = @rental2;
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (@rental2, '2026-10-06 08:30:00', 'Vo den pha trai; tra tre 2 ngay', 'Tran Thi B');
-- Gia dinh late_fee 1.000.000d cho 2 ngay tre; damage_fee 2.000.000d.
UPDATE Rentals
SET status = 'COMPLETED', late_fee = 1000000.00, damage_fee = 2000000.00
WHERE rental_id = @rental2;

-- F. Truy van minh chung ket qua
SELECT r.rental_id, r.customer_name, c.license_plate, r.status,
       r.security_deposit, r.late_fee, r.damage_fee,
       (r.security_deposit - r.late_fee - r.damage_fee) AS refund_amount,
       i.inspection_date, i.damage_description, i.inspector_name
FROM Rentals r
JOIN Cars c ON c.car_id = r.car_id
LEFT JOIN Inspections i ON i.rental_id = r.rental_id
WHERE r.rental_id IN (@rental1, @rental2)
ORDER BY r.rental_id;

-- Mong doi:
-- Nguyen Van A: 10.000.000 - 0 - 2.000.000 = 8.000.000 VND
-- Tran Van C: 10.000.000 - 1.000.000 - 2.000.000 = 7.000.000 VND

-- G. Kiem tra schema va quan he
SHOW CREATE TABLE Rentals;
SHOW CREATE TABLE Inspections;
-- Thu test trigger bang mot BOOKED rental moi va INSERT inspection vao rental do.
-- Sau khi test can rollback/ xoa du lieu mau neu can. Khong chay lenh gay loi mac dinh.
