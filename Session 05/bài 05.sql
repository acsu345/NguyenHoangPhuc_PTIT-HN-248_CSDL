DROP DATABASE IF EXISTS session05;
CREATE DATABASE session05;
USE session05;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    total_amount DECIMAL(10,2),
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled')
);

INSERT INTO orders VALUES
(1, 1, 3000000, '2024-01-10', 'completed'),
(2, 2, 8000000, '2024-01-15', 'completed'),
(3, 3, 1200000, '2024-01-20', 'pending'),
(4, 1, 9500000, '2024-02-01', 'completed'),
(5, 4, 4000000, '2024-02-05', 'cancelled'),
(6, 2, 15000000, '2024-02-10', 'completed'),
(7, 5, 6000000, '2024-02-15', 'pending'),
(8, 3, 2500000, '2024-02-18', 'completed'),
(9, 1, 7000000, '2024-02-20', 'pending'),
(10, 4, 1800000, '2024-02-22', 'completed'),
(11, 5, 5200000, '2024-02-25', 'completed'),
(12, 2, 900000, '2024-02-27', 'pending'),
(13, 3, 11000000, '2024-03-01', 'completed'),
(14, 1, 4500000, '2024-03-03', 'cancelled');


SELECT *
FROM orders
WHERE status = 'completed';

SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;

SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;

