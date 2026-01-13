drop database if exists social_network_pro;
CREATE DATABASE social_network_pro
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE social_network_pro;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_posts_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_comments_post
        FOREIGN KEY (post_id)
        REFERENCES Posts(post_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_comments_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE Friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) NOT NULL,

    PRIMARY KEY (user_id, friend_id),

    CONSTRAINT fk_friends_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_friends_friend
        FOREIGN KEY (friend_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_status
        CHECK (status IN ('pending', 'accepted'))
);

CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,

    PRIMARY KEY (user_id, post_id),

    CONSTRAINT fk_likes_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_likes_post
        FOREIGN KEY (post_id)
        REFERENCES Posts(post_id)
        ON DELETE CASCADE
);

INSERT INTO Users (username, password, email) VALUES
('binh', '123456', 'binh@gmail.com'),
('chi', '123456', 'chi@gmail.com'),
('dung', '123456', 'dung@gmail.com'),
('em', '123456', 'em@gmail.com'),
('han', '123456', 'han@gmail.com'),
('khanh', '123456', 'khanh@gmail.com'),
('linh', '123456', 'linh@gmail.com'),
('an_database', '123456', 'an_db@gmail.com'),
('anhkhoa', '123456', 'anhkhoa@gmail.com'),
('ngoclan', '123456', 'ngoclan@gmail.com');

INSERT INTO Posts (user_id, content, created_at) VALUES
(1, 'Hôm nay học SQL rất vui 😄', NOW() - INTERVAL 1 DAY),
(1, 'Mình đang làm đồ án CSDL', NOW() - INTERVAL 3 DAY),
(2, 'Ai biết Stored Procedure không?', NOW() - INTERVAL 2 DAY),
(3, 'Database quan trọng thật', NOW() - INTERVAL 5 DAY),
(4, 'Thực hành SQL mỗi ngày', NOW() - INTERVAL 8 DAY),
(5, 'MySQL khó nhưng hay', NOW() - INTERVAL 6 DAY),
(6, 'JOIN bảng làm mình hơi rối', NOW() - INTERVAL 4 DAY),
(7, 'Chuẩn bị thi cuối kỳ CSDL', NOW() - INTERVAL 1 DAY),
(8, 'Học database nâng cao với SQL', NOW() - INTERVAL 1 DAY),
(9, 'Database design rất quan trọng', NOW() - INTERVAL 2 DAY),
(10, 'Mình thích học database và backend', NOW() - INTERVAL 3 DAY);


INSERT INTO Comments (post_id, user_id, content) VALUES
(1, 2, 'Chuẩn luôn bạn ơi!'),
(1, 3, 'SQL học càng làm càng hiểu'),
(2, 4, 'Đồ án nhớ làm procedure nha'),
(3, 1, 'Stored Procedure rất quan trọng'),
(3, 5, 'Học dần là ổn'),
(7, 6, 'JOIN nhiều bảng quen dần thôi'),
(9, 1, 'Chuẩn bài database luôn'),
(10, 2, 'Mình cũng đang học backend'),
(8, 3, 'SQL càng học càng cuốn');


INSERT INTO Friends (user_id, friend_id, status) VALUES
(1, 2, 'accepted'),
(2, 1, 'accepted'),

(1, 3, 'accepted'),
(3, 1, 'accepted'),

(2, 4, 'pending'),
(4, 2, 'pending'),

(3, 5, 'accepted'),
(5, 3, 'accepted'),

(6, 1, 'pending'),
(1, 6, 'pending'),
(8, 1, 'accepted'),
(1, 8, 'accepted'),

(9, 1, 'pending'),
(1, 9, 'pending');

INSERT INTO Likes (user_id, post_id) VALUES
(2, 1),
(3, 1),
(4, 1),
(1, 2),
(3, 2),
(1, 3),
(2, 3),
(4, 3),
(5, 3),
(6, 7),
(7, 7),
(1, 8),
(2, 8),
(3, 8),
(4, 8),
(1, 9),
(2, 9),
(1, 10);


INSERT INTO Users (username, password, email)
VALUES ('an_nguyen', '123456', 'an@gmail.com');
SELECT * FROM Users;

CREATE VIEW vw_public_users AS
SELECT user_id, username, created_at
FROM Users;

SELECT * FROM vw_public_users;
SELECT user_id, username, created_at FROM Users;

CREATE INDEX idx_users_username ON Users(username);
SELECT * FROM Users
WHERE username = 'an_nguyen';

DELIMITER $$

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        INSERT INTO Posts(user_id, content)
        VALUES (p_user_id, p_content);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User không tồn tại';
    END IF;
END $$

DELIMITER ;

CREATE VIEW vw_recent_posts AS
SELECT p.post_id, u.username, p.content, p.created_at
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
WHERE p.created_at >= NOW() - INTERVAL 7 DAY;
SELECT * FROM vw_recent_posts;

CREATE INDEX idx_posts_user ON Posts(user_id);
CREATE INDEX idx_posts_user_time ON Posts(user_id, created_at);
SELECT * FROM Posts
WHERE user_id = 1
ORDER BY created_at DESC;

DELIMITER $$

CREATE PROCEDURE sp_count_posts(
    IN p_user_id INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM Posts
    WHERE user_id = p_user_id;
END $$

DELIMITER ;
CALL sp_count_posts(1, @total);
SELECT @total AS tong_bai_viet;

CREATE VIEW vw_active_users AS
SELECT * FROM Users
WHERE username IS NOT NULL
WITH CHECK OPTION;


DELIMITER $$

CREATE PROCEDURE sp_add_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    IF p_user_id = p_friend_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể kết bạn với chính mình';
    ELSE
        INSERT INTO Friends(user_id, friend_id, status)
        VALUES (p_user_id, p_friend_id, 'pending');
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_suggest_friends(
    IN p_user_id INT,
    INOUT p_limit INT
)
BEGIN
    DECLARE counter INT DEFAULT 0;

    WHILE counter < p_limit DO
        SELECT user_id, username
        FROM Users
        WHERE user_id != p_user_id
        LIMIT p_limit;
        SET counter = counter + 1;
    END WHILE;
END $$

DELIMITER ;

CREATE INDEX idx_likes_post ON Likes(post_id);
CREATE VIEW vw_top_posts AS
SELECT post_id, COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id
ORDER BY total_likes DESC
LIMIT 5;

DELIMITER $$

CREATE PROCEDURE sp_add_comment(
    IN p_user_id INT,
    IN p_post_id INT,
    IN p_content TEXT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User không tồn tại';
    ELSEIF NOT EXISTS (SELECT 1 FROM Posts WHERE post_id = p_post_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Post không tồn tại';
    ELSE
        INSERT INTO Comments(user_id, post_id, content)
        VALUES (p_user_id, p_post_id, p_content);
    END IF;
END $$

DELIMITER ;
CREATE VIEW vw_post_comments AS
SELECT c.content, u.username, c.created_at
FROM Comments c
JOIN Users u ON c.user_id = u.user_id;
DELIMITER $$

CREATE PROCEDURE sp_like_post(
    IN p_user_id INT,
    IN p_post_id INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM Likes
        WHERE user_id = p_user_id AND post_id = p_post_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đã thích bài viết này';
    ELSE
        INSERT INTO Likes(user_id, post_id)
        VALUES (p_user_id, p_post_id);
    END IF;
END $$

DELIMITER ;
CREATE VIEW vw_post_likes AS
SELECT post_id, COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id;

DELIMITER $$

CREATE PROCEDURE sp_search_social(
    IN p_option INT,
    IN p_keyword VARCHAR(100)
)
BEGIN
    IF p_option = 1 THEN
        SELECT * FROM Users
        WHERE username LIKE CONCAT('%', p_keyword, '%');
    ELSEIF p_option = 2 THEN
        SELECT * FROM Posts
        WHERE content LIKE CONCAT('%', p_keyword, '%');
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tuỳ chọn không hợp lệ';
    END IF;
END $$

DELIMITER ;
CALL sp_search_social(1, 'an');
CALL sp_search_social(2, 'database');

