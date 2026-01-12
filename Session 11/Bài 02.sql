USE social_network_mini;
delimiter $$

create procedure calculatepostlikes(
    in p_post_id int,
    out total_likes int
)
begin
    select count(*) 
    into total_likes
    from likes
    where post_id = p_post_id;
end $$

delimiter ;

	
call calculatepostlikes(2, @total_likes);

select @total_likes as tong_so_like;
drop procedure if exists calculatepostlikes;