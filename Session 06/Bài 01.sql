create database session06;
use session06;

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

SELECT 
    orders.order_id,
    customers.full_name,
    orders.order_date,
    orders.status
FROM orders
JOIN customers
ON orders.customer_id = customers.customer_id;

SELECT 
    customers.customer_id,
    customers.full_name,
    COUNT(orders.order_id) AS total_orders
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name;

SELECT 
    customers.customer_id,
    customers.full_name,
    COUNT(orders.order_id) AS total_orders
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name
HAVING COUNT(orders.order_id) >= 1;
