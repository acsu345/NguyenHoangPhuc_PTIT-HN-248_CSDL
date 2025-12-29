create database bai04;
use bai04;

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT NOT NULL CHECK (credit > 0)
);

INSERT INTO Subject (subject_id, subject_name, credit)
VALUES
(1, 'Co so du lieu', 3),
(2, 'Lap trinh Java', 4),
(3, 'He dieu hanh', 3),
(4, 'Mang may tinh', 2);

UPDATE Subject
SET credit = 3
WHERE subject_id = 4;

UPDATE Subject
SET subject_name = 'Lap trinh Java nang cao'
WHERE subject_id = 2;

SELECT * FROM Subject;
