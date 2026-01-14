drop database if exists session13;
create database session13;
use session13;

create table users (
	user_id int primary key auto_increment,
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts (
	post_id int primary key auto_increment,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

create table likes(
	like_id int primary key auto_increment,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id),
    foreign key (post_id) references posts(post_id)
);

insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

insert into posts (user_id, content, created_at) values
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

delimiter $$

create trigger trg_like_self_check
before insert on likes
for each row
begin
    declare post_owner int;

    select user_id
    into post_owner
    from posts
    where post_id = new.post_id;

    if post_owner = new.user_id then
        signal sqlstate '45000'
        set message_text = 'user khong duoc like bai viet cua chinh minh';
    end if;
end $$

-- insert into likes (user_id, post_id)
-- values (1, 1);

create trigger trg_like_insert
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end $$

insert into likes (user_id, post_id)
values (2, 4);


create trigger trg_like_delete
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end $$

create trigger trg_like_update
after update on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;

    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
    
    
end $$

	
delimiter ;
	-- update likes
-- 	set post_id = 2
-- 	where user_id = 2 and post_id = 4;
-- select post_id, like_count from posts where post_id in (2,4);
-- select * from user_statistics;


delete from likes
where user_id = 3 and post_id = 4;
select post_id, like_count from posts where post_id = 4;
select * from user_statistics;


create view user_statistics as
select 
	u.user_id,
    u.username,
    u.post_count,
    ifnull(sum(p.like_count), 0) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.post_count;

select * from user_statistics;
