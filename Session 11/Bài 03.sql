USE social_network_mini;

delimiter $$

create procedure calculatebonuspoints(
    in p_user_id int,
    inout p_bonus_points int
)
begin
    declare post_count int;

    select count(*) 
    into post_count
    from posts
    where user_id = p_user_id;

    if post_count >= 20 then
        set p_bonus_points = p_bonus_points + 100;
    elseif post_count >= 10 then
        set p_bonus_points = p_bonus_points + 50;
    else
        set p_bonus_points = p_bonus_points;
    end if;
end $$

delimiter ;

set @bonus = 100;

call calculatebonuspoints(1, @bonus);
select @bonus as diem_thuong_sau_khi_tinh;
drop procedure if exists calculatebonuspoints;