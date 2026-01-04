create database session05;
use session05;

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

SELECT * FROM products;

SELECT * 
FROM products
WHERE status = 'active';

SELECT *
FROM products
WHERE status = 'active'
ORDER BY price ASC;
