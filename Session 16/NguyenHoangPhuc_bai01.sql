drop database if exists quanlybanhang;
create database quanlybanhang;
use quanlybanhang;

create table customers (
    customer_id int auto_increment primary key,
    customer_name varchar(100) not null,
    phone varchar(20) not null unique,
    address varchar(255)
);

create table products (
    product_id int auto_increment primary key,
    product_name varchar(100) not null unique,
    price decimal(10,2) not null,
    quantity int not null check (quantity >= 0),
    category varchar(50) not null
);

create table employees (
    employee_id int auto_increment primary key,
    employee_name varchar(100) not null,
    birthday date,
    position varchar(50) not null,
    salary decimal(10,2) not null,
    revenue decimal(10,2) default 0
);

create table orders (
    order_id int auto_increment primary key,
    customer_id int,
    employee_id int,
    order_date datetime default current_timestamp,
    total_amount decimal(10,2) default 0,

    foreign key (customer_id) references customers(customer_id),
    foreign key (employee_id) references employees(employee_id)
);

create table orderdetails (
    order_detail_id int auto_increment primary key,
    order_id int,
    product_id int,
    quantity int not null check (quantity > 0),
    unit_price decimal(10,2) not null,

    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

alter table customers
add email varchar(100) not null unique;

alter table employees
drop column birthday;

insert into customers (customer_name, email, phone, address) values
('nguyễn văn a','a@gmail.com','0901111111','hà nội'),
('trần thị b','b@gmail.com','0902222222','tp hcm'),
('lê văn c','c@gmail.com','0903333333','đà nẵng'),
('phạm thị d','d@gmail.com','0904444444','huế'),
('hoàng văn e','e@gmail.com','0905555555','cần thơ');

insert into products (product_name, price, quantity, category) values
('laptop hp',1500,200,'laptop'),
('chuột logitech',20,500,'phụ kiện'),
('bàn phím corsair',120,300,'phụ kiện'),
('màn hình dell',350,150,'màn hình'),
('tai nghe sony',200,400,'âm thanh');

insert into employees (employee_name, position, salary) values
('nguyễn an','sales',800),
('trần bình','sales',900),
('lê chi','manager',1500),
('phạm dũng','sales',850),
('hoàng em','support',700);

insert into orders (customer_id, employee_id) values
(1,1),(2,2),(1,3),(3,1),(4,2);

insert into orderdetails (order_id, product_id, quantity, unit_price) values
(1,1,2,1500),
(1,2,5,20),
(2,3,3,120),
(3,4,1,350),
(4,5,10,200);

select customer_id, customer_name, email, phone, address
from customers;

update products
set product_name = 'laptop dell xps',
    price = 99.99
where product_id = 1;

select o.order_id,
       c.customer_name,
       e.employee_name,
       o.total_amount,
       o.order_date
from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id;

select c.customer_id,
       c.customer_name,
       count(o.order_id) as total_orders
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name;

select e.employee_id,
       e.employee_name,
       sum(o.total_amount) as revenue
from employees e
join orders o on e.employee_id = o.employee_id
where year(o.order_date) = year(curdate())
group by e.employee_id, e.employee_name;

select p.product_id,
       p.product_name,
       sum(od.quantity) as total_quantity
from orderdetails od
join orders o on od.order_id = o.order_id
join products p on od.product_id = p.product_id
where month(o.order_date) = month(curdate())
  and year(o.order_date) = year(curdate())
group by p.product_id, p.product_name
having sum(od.quantity) > 100
order by total_quantity desc;

select c.customer_id, c.customer_name
from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is null;

select *
from products
where price > (select avg(price) from products);

select c.customer_id,
       c.customer_name,
       sum(o.total_amount) as total_spent
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having total_spent = (
    select max(t.total_spent)
    from (
        select sum(total_amount) as total_spent
        from orders
        group by customer_id
    ) t
);

create view view_order_list as
select o.order_id,
       c.customer_name,
       e.employee_name,
       o.total_amount,
       o.order_date
from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id
order by o.order_date desc;

create view view_order_detail_product as
select od.order_detail_id,
       p.product_name,
       od.quantity,
       od.unit_price
from orderdetails od
join products p on od.product_id = p.product_id
order by od.quantity desc;

delimiter $$

create procedure proc_insert_employee(
    in p_name varchar(100),
    in p_position varchar(50),
    in p_salary decimal(10,2),
    out new_id int
)
begin
    insert into employees (employee_name, position, salary)
    values (p_name, p_position, p_salary);

    set new_id = last_insert_id();
end$$

delimiter ;

delimiter $$

create procedure proc_get_orderdetails(in p_order_id int)
begin
    select *
    from orderdetails
    where order_id = p_order_id;
end$$

delimiter ;

delimiter $$

create procedure proc_cal_total_amount_by_order(
    in p_order_id int,
    out total_products int
)
begin
    select count(distinct product_id)
    into total_products
    from orderdetails
    where order_id = p_order_id;
end$$

delimiter ;


delimiter $$

create trigger trigger_after_insert_order_details
before insert on orderdetails
for each row
begin
    declare stock int;

    select quantity into stock
    from products
    where product_id = new.product_id;

    if stock < new.quantity then
        signal sqlstate '45000'
        set message_text = 'số lượng sản phẩm trong kho không đủ';
    else
        update products
        set quantity = quantity - new.quantity
        where product_id = new.product_id;
    end if;
end$$

delimiter ;

delimiter $$

create procedure proc_insert_order_details(
    in p_order_id int,
    in p_product_id int,
    in p_quantity int,
    in p_price decimal(10,2)
)
begin
    declare v_count int;

    start transaction;

    select count(*) into v_count
    from orders
    where order_id = p_order_id;

    if v_count = 0 then
        signal sqlstate '45000'
        set message_text = 'không tồn tại mã hóa đơn';
    end if;

    insert into orderdetails(order_id, product_id, quantity, unit_price)
    values (p_order_id, p_product_id, p_quantity, p_price);

    update orders
    set total_amount = total_amount + (p_quantity * p_price)
    where order_id = p_order_id;

    commit;
end$$

delimiter ;
