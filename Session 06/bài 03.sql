DROP DATABASE IF EXISTS session06;
CREATE DATABASE session06;
USE session06;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(255),
    city VARCHAR(255)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled')
);

INSERT INTO customers VALUES
(1, 'Nguyen Van A', 'TP.HCM'),
(2, 'Tran Thi B', 'Ha Noi'),
(3, 'Le Van C', 'Da Nang'),
(4, 'Pham Thi D', 'TP.HCM'),
(5, 'Hoang Van E', 'Can Tho');

INSERT INTO orders VALUES
(1, 1, '2024-01-10', 'completed'),
(2, 1, '2024-01-15', 'pending'),
(3, 2, '2024-01-20', 'completed'),
(4, 3, '2024-02-01', 'cancelled'),
(5, 2, '2024-02-05', 'completed'),
(6, 5, '2024-02-10', 'pending');

ALTER TABLE orders
ADD total_amount DECIMAL(10,2);

UPDATE orders SET total_amount = 30000000 WHERE order_id = 1;
UPDATE orders SET total_amount = 45000000 WHERE order_id = 2;
UPDATE orders SET total_amount = 80000000 WHERE order_id = 3;
UPDATE orders SET total_amount = 12000000 WHERE order_id = 4;
UPDATE orders SET total_amount = 6000000 WHERE order_id = 5;
UPDATE orders SET total_amount = 25000000 WHERE order_id = 6;

SELECT
    order_date,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'completed'
GROUP BY order_date;

SELECT
    order_date,
    COUNT(order_id) AS total_orders
FROM orders
WHERE status = 'completed'
GROUP BY order_date;

SELECT
    order_date,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'completed'
GROUP BY order_date
HAVING SUM(total_amount) > 10000000;
