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
    foreign key (user_id) references users(user_id)
);

create table followers (
    follower_id int not null,
    followed_id int not null,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id),
    foreign key (followed_id) references users(user_id)
);

insert into users (username) values
('nguyen van an'),
('tran thi bay');

delimiter $$

create procedure sp_follow_user (
    in p_follower_id int,
    in p_followed_id int
)
proc: begin
    declare v_count int;

    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- kiểm tra follower tồn tại
    select count(*) into v_count
    from users
    where user_id = p_follower_id;

    if v_count = 0 then
        rollback;
        leave proc;
    end if;

    -- kiểm tra followed tồn tại
    select count(*) into v_count
    from users
    where user_id = p_followed_id;

    if v_count = 0 then
        rollback;
        leave proc;
    end if;

    -- không cho tự follow chính mình
    if p_follower_id = p_followed_id then
        rollback;
        leave proc;
    end if;

    -- kiểm tra đã follow chưa
    select count(*) into v_count
    from followers
    where follower_id = p_follower_id
      and followed_id = p_followed_id;

    if v_count > 0 then
        rollback;
        leave proc;
    end if;

    -- insert follow
    insert into followers (follower_id, followed_id)
    values (p_follower_id, p_followed_id);

    -- cập nhật count
    update users
    set following_count = following_count + 1
    where user_id = p_follower_id;

    update users
    set followers_count = followers_count + 1
    where user_id = p_followed_id;

    commit;
end $$

delimiter ;

call sp_follow_user(1, 2);

select * from followers;

select user_id, following_count, followers_count
from users;
