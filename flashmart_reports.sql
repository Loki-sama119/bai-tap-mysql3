-- FLASHMART | BAI THUC HANH INNER JOIN, LEFT JOIN, ANTI-JOIN
-- MySQL 8.0+
-- Chay toan bo script tren MySQL Workbench.
-- Luu y: Script tao lai ba bang demo; khong dung tren CSDL san xuat.
CREATE DATABASE IF NOT EXISTS flashmart_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE flashmart_db;

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_orders_product FOREIGN KEY (product_id) REFERENCES Products(product_id)
) ENGINE=InnoDB;

INSERT INTO Customers (customer_id, name) VALUES
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

INSERT INTO Products (product_id, product_name) VALUES
(101, 'Laptop'), (102, 'Mouse'), (103, 'Keyboard');

INSERT INTO Orders (order_id, customer_id, product_id) VALUES
(1001, 1, 101), (1002, 1, 102), (1003, 2, 101);

-- BAO CAO 1: Tat ca khach hang, ke ca chua tung mua.
-- COUNT(o.order_id) = 0 khi khong co don hang tuong ung.
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM Customers AS c
LEFT JOIN Orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY c.customer_id;

-- BAO CAO 2: San pham chua tung co giao dich (anti-join).
SELECT p.product_id, p.product_name
FROM Products AS p
LEFT JOIN Orders AS o ON p.product_id = o.product_id
WHERE o.order_id IS NULL
ORDER BY p.product_id;

-- DOI CHIEU: bao cao 1 phai co 3 khach, bao cao 2 phai co 1 san pham.
SELECT (SELECT COUNT(*) FROM Customers) AS total_customers,
       (SELECT COUNT(*) FROM Products) AS total_products,
       (SELECT COUNT(*) FROM Orders) AS total_orders;
