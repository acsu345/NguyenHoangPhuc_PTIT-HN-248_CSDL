USE social_network_mini;

delimiter $$

create procedure createpostwithvalidation(
    in p_user_id int,
    in p_content text,
    out result_message varchar(255)
)
begin
    if length(p_content) < 5 then
        set result_message = 'noi dung qua ngan';
    else
        insert into posts(user_id, content)
        values (p_user_id, p_content);

        set result_message = 'them bai viet thanh cong';
    end if;
end $$

delimiter ;
call createpostwithvalidation(1, 'hi', @result);
call createpostwithvalidation(1, 'hom nay troi dep qua', @result);
select @result as ket_qua;
drop procedure if exists createpostwithvalidation;