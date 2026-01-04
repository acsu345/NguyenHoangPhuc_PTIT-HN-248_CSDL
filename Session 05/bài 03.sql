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
(7, 5, 6000000, '2024-02-15', 'pending');

SELECT *
FROM orders
WHERE status = 'completed';

SELECT *
FROM orders
WHERE total_amount > 5000000;

SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 5;

SELECT *
FROM orders
WHERE status = 'completed'
ORDER BY total_amount DESC;
