DROP DATABASE IF EXISTS session07;
CREATE DATABASE session07;
USE session07;

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-01-01', 500000),
(2, 2, '2024-01-03', 1500000),
(3, 3, '2024-01-05', 800000),
(4, 4, '2024-01-07', 2000000),
(5, 5, '2024-01-10', 300000),
(6, 6, '2024-01-12', 1000000);

SELECT *
FROM orders
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);
