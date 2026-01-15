drop database if exists session14;
create database session14;
use session14;

create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null,
    posts_count int default 0,
    following_count int default 0,
    followers_count int default 0
);

create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    likes_count int default 0,
	comments_count int default 0,
    foreign key (user_id) references users(user_id)
);

create table followers (
    follower_id int not null,
    followed_id int not null,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id),
    foreign key (followed_id) references users(user_id)
);

create table if not exists comments (
    comment_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

insert into users (username) values
('nguyen van an'),
('tran thi bay');

insert into posts (user_id, content)
values (1, 'bai viet dau tien');

delimiter $$

create procedure sp_post_comment (
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
proc: begin
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- bước 1: insert comment
    insert into comments (post_id, user_id, content)
    values (p_post_id, p_user_id, p_content);

    -- tạo savepoint sau khi insert
    savepoint after_insert;

    -- bước 2: update comments_count
    update posts
    set comments_count = comments_count + 1
    where post_id = p_post_id;

    -- nếu update không ảnh hưởng dòng nào (giả lập lỗi)
    if row_count() = 0 then
        rollback to after_insert;
        commit;
        leave proc;
    end if;

    commit;
end $$

delimiter ;

call sp_post_comment(1, 1, 'binh luan dau tien');

select * from comments;

select post_id, comments_count
from posts;
