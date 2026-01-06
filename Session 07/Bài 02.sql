DROP DATABASE IF EXISTS session07;
CREATE DATABASE session07;
USE session07;

CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT
);

INSERT INTO products (id, name, price) VALUES
(1, 'Laptop', 15000000),
(2, 'Chuột', 200000),
(3, 'Bàn phím', 500000),
(4, 'Tai nghe', 300000),
(5, 'Màn hình', 4000000),
(6, 'USB', 150000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(2, 5, 1),
(3, 1, 1),
(3, 4, 2),
(4, 6, 3);

SELECT *
FROM products
WHERE id IN (
    SELECT product_id
    FROM order_items
);
