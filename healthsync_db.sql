-- HEALTHSYNC - REPAIR LEGACY SCHEMA + BUSINESS SCENARIOS
-- MySQL 8.0.16+ (CHECK constraints enforced)
-- Run once on a fresh instance, or run against legacy schema without previously applied migrations.
-- No DROP DATABASE or DROP TABLE: preserve existing records.

CREATE DATABASE IF NOT EXISTS healthsync_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE healthsync_db;

-- Legacy base tables. IF NOT EXISTS keeps existing data.
CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
) ENGINE=InnoDB;

-- Migration: existing is_active=true maps to PENDING, false to CANCELLED.
-- Legacy booleans do not reveal whether deposit was paid or visits completed.
-- Default deposit 0 marks legacy values requiring manual audit.
ALTER TABLE Appointments
    ADD COLUMN status ENUM('PENDING','CONFIRMED','CHECKED_IN','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING',
    ADD COLUMN deposit_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ADD COLUMN penalty_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ADD COLUMN cancel_reason VARCHAR(255) NULL,
    ADD CONSTRAINT chk_deposit_nonnegative CHECK (deposit_amount >= 0),
    ADD CONSTRAINT chk_penalty_valid CHECK (penalty_fee >= 0 AND penalty_fee <= deposit_amount),
    ADD CONSTRAINT chk_cancel_info CHECK (
      (status = 'CANCELLED') OR (cancel_reason IS NULL AND penalty_fee = 0)
    );
UPDATE Appointments SET status = IF(is_active = 0, 'CANCELLED', 'PENDING');
ALTER TABLE Appointments DROP COLUMN is_active;

-- Appointment can have at most one prescription: UNIQUE(appointment_id).
CREATE TABLE IF NOT EXISTS Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    medication_details TEXT NOT NULL,
    issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_prescription_appointment UNIQUE (appointment_id),
    CONSTRAINT fk_prescriptions_appointment FOREIGN KEY (appointment_id)
       REFERENCES Appointments(appointment_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Guard against prescription insertion for visits other than COMPLETED.
DELIMITER $$
CREATE TRIGGER trg_prescriptions_before_insert
BEFORE INSERT ON Prescriptions FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    SELECT status INTO v_status FROM Appointments
    WHERE appointment_id = NEW.appointment_id;
    IF v_status IS NULL OR v_status <> 'COMPLETED' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prescription requires COMPLETED appointment';
    END IF;
END$$
CREATE TRIGGER trg_prescriptions_before_update
BEFORE UPDATE ON Prescriptions FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    SELECT status INTO v_status FROM Appointments
    WHERE appointment_id = NEW.appointment_id;
    IF v_status IS NULL OR v_status <> 'COMPLETED' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prescription requires COMPLETED appointment';
    END IF;
END$$
-- Prevent moving completed appointments with a prescription back to other states.
CREATE TRIGGER trg_appointments_before_update
BEFORE UPDATE ON Appointments FOR EACH ROW
BEGIN
    IF NEW.status <> 'COMPLETED' AND EXISTS (
        SELECT 1 FROM Prescriptions WHERE appointment_id = NEW.appointment_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot change status: prescription already exists';
    END IF;
END$$
DELIMITER ;

-- Scenario test data: use stable phone numbers to get IDs without assuming auto IDs.
INSERT INTO Patients (full_name, phone) VALUES
('Nguyen Van A', '0900000001'),
('Tran Thi B', '0900000002');
INSERT INTO Doctors (full_name, specialty) VALUES
('Le Thi Bac Si', 'Noi tong quat');

SET @patient_a := (SELECT patient_id FROM Patients WHERE phone='0900000001' ORDER BY patient_id DESC LIMIT 1);
SET @patient_b := (SELECT patient_id FROM Patients WHERE phone='0900000002' ORDER BY patient_id DESC LIMIT 1);
SET @doctor_id := (SELECT doctor_id FROM Doctors WHERE full_name='Le Thi Bac Si' ORDER BY doctor_id DESC LIMIT 1);

-- Scenario 1: PENDING -> CONFIRMED -> CHECKED_IN -> COMPLETED -> prescription.
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (@patient_a, @doctor_id, '2026-11-02 09:00:00', 'PENDING', 500000.00);
SET @success_appointment_id := LAST_INSERT_ID();
UPDATE Appointments SET status='CONFIRMED' WHERE appointment_id=@success_appointment_id;
UPDATE Appointments SET status='CHECKED_IN' WHERE appointment_id=@success_appointment_id;
UPDATE Appointments SET status='COMPLETED' WHERE appointment_id=@success_appointment_id;
INSERT INTO Prescriptions (appointment_id, medication_details, issued_date)
VALUES (@success_appointment_id, 'Paracetamol 500mg: uong theo chi dinh bac si', '2026-11-02 10:00:00');

-- Scenario 2: CONFIRMED -> CANCELLED; 300,000 deposit, 150,000 penalty.
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (@patient_b, @doctor_id, '2026-11-03 14:00:00', 'CONFIRMED', 300000.00);
SET @cancelled_appointment_id := LAST_INSERT_ID();
UPDATE Appointments
SET status='CANCELLED', cancel_reason='Bận việc đột xuất', penalty_fee=150000.00
WHERE appointment_id=@cancelled_appointment_id;

-- Verification A: all scenario records, deposit/penalty/refund.
SELECT a.appointment_id, p.full_name AS patient_name, a.status,
       a.deposit_amount, a.penalty_fee,
       (a.deposit_amount - a.penalty_fee) AS refundable_deposit,
       a.cancel_reason
FROM Appointments a
JOIN Patients p ON p.patient_id=a.patient_id
WHERE a.appointment_id IN (@success_appointment_id, @cancelled_appointment_id)
ORDER BY a.appointment_id;

-- Verification B: completed patients and their prescriptions.
SELECT a.appointment_id, p.full_name AS patient_name, d.full_name AS doctor_name,
       a.status, pr.medication_details, pr.issued_date
FROM Appointments a
JOIN Patients p ON p.patient_id=a.patient_id
JOIN Doctors d ON d.doctor_id=a.doctor_id
JOIN Prescriptions pr ON pr.appointment_id=a.appointment_id
WHERE a.status='COMPLETED';

-- Verify FK and UNIQUE constraints via Workbench schema inspector or SHOW CREATE TABLE.
SHOW CREATE TABLE Appointments;
SHOW CREATE TABLE Prescriptions;

-- For trigger testing, create a PENDING appointment and try inserting a prescription;
-- the INSERT must be run separately and should FAIL (SQLSTATE 45000).
-- INSERT INTO Prescriptions (appointment_id, medication_details)
-- VALUES (<PENDING_APPOINTMENT_ID>, 'Must fail');
