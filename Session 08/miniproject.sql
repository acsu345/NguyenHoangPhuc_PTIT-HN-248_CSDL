DROP DATABASE IF EXISTS miniproject1;
create database miniproject1;
use miniproject1;

create table customers (
  customer_id int primary key auto_increment,
  customer_name varchar(100) not null,
  email varchar(100) not null unique,
  phone varchar(10) not null unique
);

create table categories (
  category_id int primary key auto_increment,
  category_name varchar(255) not null unique
);

create table products (
  product_id int primary key auto_increment,
  product_name varchar(255) not null unique,
  price decimal(10,2) not null,
  category_id int not null,
  foreign key (category_id) references categories(category_id)
);

create table orders (
  order_id int primary key auto_increment,
  customer_id int not null,
  order_date datetime not null default current_timestamp,
  status enum('PENDING','COMPLETED','CANCELLED') not null default 'PENDING',
  foreign key (customer_id) references customers(customer_id)
);

create table order_items (
  order_item_id int primary key auto_increment,
  order_id int not null,
  product_id int not null,
  quantity int not null,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

INSERT INTO customers (customer_name, email, phone) VALUES
('Nguyễn Văn An', 'an@gmail.com', '0900000001'),
('Trần Thị Bình', 'binh@gmail.com', '0900000002'),
('Lê Văn Cường', 'cuong@gmail.com', '0900000003'),
('Phạm Thị Dung', 'dung@gmail.com', '0900000004'),
('Hoàng Văn Em', 'em@gmail.com', '0900000005');

INSERT INTO categories (category_name) VALUES
('Điện thoại'),
('Laptop'),
('Phụ kiện'),
('Tai nghe'),
('Đồng hồ thông minh');

INSERT INTO products (product_name, price, category_id) VALUES
('iPhone 15', 25000000, 1),
('Samsung Galaxy S24', 22000000, 1),
('MacBook Air M2', 30000000, 2),
('Dell XPS 13', 28000000, 2),
('Tai nghe AirPods Pro', 5500000, 4),
('Chuột Logitech MX Master', 2500000, 3),
('Apple Watch Series 9', 12000000, 5);

INSERT INTO orders (customer_id, status) VALUES
(1, 'COMPLETED'),
(2, 'PENDING'),
(3, 'COMPLETED'),
(4, 'CANCELLED'),
(5, 'PENDING');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 5, 1),
(2, 3, 1),
(3, 2, 2),
(3, 6, 1),
(4, 4, 1),
(5, 7, 1);

select * from products;
select * from orders where status = 'COMPLETED';
select * from products order by price desc;
SELECT *FROM products ORDER BY price DESC LIMIT 5 OFFSET 2;

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id;

SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT
    o.order_id,
    SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2;

SELECT
    c.category_name,
    AVG(p.price) AS avg_price,
    MIN(p.price) AS min_price,
    MAX(p.price) AS max_price
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;

SELECT
    c.category_name,
    AVG(p.price) AS avg_price,
    MIN(p.price) AS min_price,
    MAX(p.price) AS max_price
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;

SELECT *
FROM products
WHERE price > (
    SELECT AVG(price) FROM products
);

SELECT *
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM orders
);
SELECT
    order_id,
    SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id
ORDER BY total_quantity DESC
LIMIT 1;

SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category_id = (
    SELECT category_id
    FROM products
    GROUP BY category_id
    ORDER BY AVG(price) DESC
    LIMIT 1
);

SELECT
    c.customer_id,
    c.customer_name,
    SUM(t.total_quantity) AS total_products
FROM customers c
JOIN (
    SELECT
        o.customer_id,
        SUM(oi.quantity) AS total_quantity
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT *
FROM products
WHERE price = (
    SELECT MAX(price) FROM products
);
