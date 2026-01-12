USE social_network_mini;

delimiter $$

create procedure get_posts_by_user(in p_user_id int)
begin
    select 
        post_id as postid,
        content as noi_dung,
        created_at as thoi_gian_tao
    from posts
    where user_id = p_user_id
    order by created_at desc;
end $$

delimiter ;


call get_posts_by_user(1);

drop procedure if exists get_posts_by_user;