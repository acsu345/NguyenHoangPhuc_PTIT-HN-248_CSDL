DROP DATABASE IF EXISTS session06;
CREATE DATABASE session06;
USE session06;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2)
);
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO products VALUES
(1, 'Laptop Dell', 15000000),
(2, 'Chuột Logitech', 500000),
(3, 'Bàn phím cơ', 1200000),
(4, 'Màn hình Samsung', 3000000),
(5, 'Tai nghe Sony', 900000);

INSERT INTO order_items VALUES
(1, 1, 1), 
(1, 2, 2), 
(2, 3, 1), 
(3, 1, 1),
(3, 4, 2), 
(4, 5, 3);

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT
    p.product_id,
    p.product_name,
    SUM(p.price * oi.quantity) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT
    p.product_id,
    p.product_name,
    SUM(p.price * oi.quantity) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(p.price * oi.quantity) > 5000000;
