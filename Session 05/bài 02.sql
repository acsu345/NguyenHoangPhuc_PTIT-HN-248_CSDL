DROP DATABASE IF EXISTS session05;
CREATE DATABASE session05;
USE session05;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(255),
    status ENUM('active', 'inactive')
);

INSERT INTO customers VALUES
(1, 'Nguyen Van A', 'a@gmail.com', 'TP.HCM', 'active'),
(2, 'Tran Thi B', 'b@gmail.com', 'Ha Noi', 'active'),
(3, 'Le Van C', 'c@gmail.com', 'TP.HCM', 'inactive'),
(4, 'Pham Thi D', 'd@gmail.com', 'Ha Noi', 'inactive'),
(5, 'Hoang Van E', 'e@gmail.com', 'Da Nang', 'active');
SELECT * FROM customers;

SELECT *
FROM customers
WHERE city = 'TP.HCM';

SELECT *
FROM customers
WHERE status = 'active'
  AND city = 'Ha Noi';

SELECT *
FROM customers
ORDER BY full_name ASC;
