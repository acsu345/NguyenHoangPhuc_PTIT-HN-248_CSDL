
DROP DATABASE IF EXISTS mini_social_network;
CREATE DATABASE mini_social_network;
USE mini_social_network;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

CREATE TABLE Friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK (status IN ('pending', 'accepted')),
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (friend_id) REFERENCES Users(user_id)
);

CREATE TABLE user_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE post_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE friend_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

-- Log đăng ký user
CREATE TRIGGER trg_after_insert_user
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO user_log(user_id, action)
    VALUES (NEW.user_id, 'User registered');
END$$

-- Log đăng bài
CREATE TRIGGER trg_after_insert_post
AFTER INSERT ON Posts
FOR EACH ROW
BEGIN
    INSERT INTO post_log(post_id, action)
    VALUES (NEW.post_id, 'Post created');
END$$

-- Like: tăng like_count
CREATE TRIGGER trg_after_like
AFTER INSERT ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$

-- Unlike: giảm like_count
CREATE TRIGGER trg_after_unlike
AFTER DELETE ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END$$

-- Log gửi lời mời kết bạn
CREATE TRIGGER trg_after_friend_request
AFTER INSERT ON Friends
FOR EACH ROW
BEGIN
    INSERT INTO friend_log(action)
    VALUES ('Friend request sent');
END$$

-- Khi chấp nhận kết bạn → tạo quan hệ đối xứng
CREATE TRIGGER trg_accept_friend
AFTER UPDATE ON Friends
FOR EACH ROW
BEGIN
    IF OLD.status = 'pending' AND NEW.status = 'accepted' THEN
        INSERT IGNORE INTO Friends(user_id, friend_id, status)
        VALUES (NEW.friend_id, NEW.user_id, 'accepted');
    END IF;
END$$

DELIMITER ;

DELIMITER $$

-- BÀI 1: Đăng ký thành viên
CREATE PROCEDURE sp_register_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM Users
        WHERE username = p_username OR email = p_email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username or Email already exists';
    ELSE
        INSERT INTO Users(username, password, email)
        VALUES (p_username, p_password, p_email);
    END IF;
END$$

-- BÀI 2: Đăng bài viết
CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF TRIM(p_content) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Post content cannot be empty';
    ELSE
        INSERT INTO Posts(user_id, content)
        VALUES (p_user_id, p_content);
    END IF;
END$$

-- BÀI 4: Gửi lời mời kết bạn
CREATE PROCEDURE sp_send_friend_request(
    IN p_sender INT,
    IN p_receiver INT
)
BEGIN
    IF p_sender = p_receiver THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot send friend request to yourself';
    ELSEIF EXISTS (
        SELECT 1 FROM Friends
        WHERE user_id = p_sender AND friend_id = p_receiver
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Friend request already exists';
    ELSE
        INSERT INTO Friends(user_id, friend_id)
        VALUES (p_sender, p_receiver);
    END IF;
END$$

-- BÀI 6: Quản lý quan hệ bạn bè (Transaction)
CREATE PROCEDURE sp_remove_friend(
    IN p_user INT,
    IN p_friend INT
)
BEGIN
    START TRANSACTION;

    DELETE FROM Friends
    WHERE (user_id = p_user AND friend_id = p_friend)
       OR (user_id = p_friend AND friend_id = p_user);

    IF ROW_COUNT() = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Friend relationship not found';
    ELSE
        COMMIT;
    END IF;
END$$

-- BÀI 7: Xóa bài viết
CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1 FROM Posts
        WHERE post_id = p_post_id AND user_id = p_user_id
    ) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No permission to delete this post';
    ELSE
        DELETE FROM Posts WHERE post_id = p_post_id;
        COMMIT;
    END IF;
END$$

-- BÀI 8: Xóa tài khoản
CREATE PROCEDURE sp_delete_user(
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;
    DELETE FROM Users WHERE user_id = p_user_id;
    COMMIT;
END$$

DELIMITER ;

-- Đăng ký user
CALL sp_register_user('alice', '123', 'alice@gmail.com');
CALL sp_register_user('bob', '123', 'bob@gmail.com');
CALL sp_register_user('charlie', '123', 'charlie@gmail.com');

-- Lỗi trùng
-- CALL sp_register_user('alice', '123', 'x@gmail.com');

SELECT * FROM Users;
SELECT * FROM user_log;

-- Đăng bài
CALL sp_create_post(1, 'Hello World');
CALL sp_create_post(2, 'My first post');

SELECT * FROM Posts;
SELECT * FROM post_log;

-- Like / Unlike
INSERT INTO Likes VALUES (1,1,NOW());
INSERT INTO Likes VALUES (2,1,NOW());
DELETE FROM Likes WHERE user_id = 2 AND post_id = 1;

SELECT * FROM Posts;

-- Kết bạn
CALL sp_send_friend_request(1,2);
UPDATE Friends SET status = 'accepted' WHERE user_id = 1 AND friend_id = 2;

SELECT * FROM Friends;

-- Xóa bài viết
CALL sp_delete_post(1,1);
SELECT * FROM Posts;

-- Xóa user
CALL sp_delete_user(2);
SELECT * FROM Users;
