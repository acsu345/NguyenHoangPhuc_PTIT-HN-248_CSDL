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

UPDATE orders SET total_amount = 3000000 WHERE order_id = 1;
UPDATE orders SET total_amount = 4500000 WHERE order_id = 2;
UPDATE orders SET total_amount = 8000000 WHERE order_id = 3;
UPDATE orders SET total_amount = 1200000 WHERE order_id = 4;
UPDATE orders SET total_amount = 6000000 WHERE order_id = 5;
UPDATE orders SET total_amount = 2500000 WHERE order_id = 6;

SELECT
    customers.customer_id,
    customers.full_name,
    SUM(orders.total_amount) AS total_spent
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name;

SELECT
    customers.customer_id,
    customers.full_name,
    MAX(orders.total_amount) AS max_order_value
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name;

SELECT
    customers.customer_id,
    customers.full_name,
    SUM(orders.total_amount) AS total_spent
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name
ORDER BY total_spent DESC;
