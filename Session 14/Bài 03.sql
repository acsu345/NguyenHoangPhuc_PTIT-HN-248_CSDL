drop database if exists session14;
create database session14;
use session14;

create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null,
    posts_count int default 0
);

create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    likes_count int default 0,
    foreign key (user_id) references users(user_id)
);

create table if not exists likes (
    like_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    constraint fk_likes_post
        foreign key (post_id) references posts(post_id),
    constraint fk_likes_user
        foreign key (user_id) references users(user_id),
    constraint unique_like unique (post_id, user_id)
);


insert into users (username) values
('nguyen van an'),
('tran thi bay');

insert into posts (user_id, content)
values (1, 'bai viet dau tien');


start transaction;

insert into likes (post_id, user_id)
values (1, 1);

update posts
set likes_count = likes_count + 1
where post_id = 1;

commit;

select post_id, likes_count from posts;

select post_id, count(*) as total_likes
from likes
group by post_id;
