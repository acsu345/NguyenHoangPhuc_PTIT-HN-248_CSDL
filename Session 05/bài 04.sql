DROP DATABASE IF EXISTS session05;
CREATE DATABASE session05;
USE session05;

create table products (
	product_id int,
    product_name varchar(255),
    price decimal(10,2),
    stock int,
    status enum('active', 'inactive')
);

INSERT INTO products VALUES
(1, 'Laptop Dell', 15000000, 10, 'active'),
(2, 'Chuột Logitech', 500000, 50, 'active'),
(3, 'Bàn phím cơ', 1200000, 20, 'active'),
(4, 'Màn hình Samsung', 3000000, 5, 'inactive'),
(5, 'Tai nghe Sony', 900000, 30, 'active');

ALTER TABLE products
ADD sold_quantity INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE products SET sold_quantity = 50 WHERE product_id = 1;
UPDATE products SET sold_quantity = 120 WHERE product_id = 2;
UPDATE products SET sold_quantity = 80 WHERE product_id = 3;
UPDATE products SET sold_quantity = 30 WHERE product_id = 4;
UPDATE products SET sold_quantity = 60 WHERE product_id = 5;

SELECT *
FROM products
ORDER BY sold_quantity DESC
LIMIT 10;

SELECT *
FROM products
ORDER BY sold_quantity DESC
LIMIT 5 OFFSET 10;

SELECT *
FROM products
WHERE price < 2000000
ORDER BY sold_quantity DESC;
