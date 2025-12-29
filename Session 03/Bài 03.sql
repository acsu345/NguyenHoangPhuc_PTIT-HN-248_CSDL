create database bai03 ;
use bai03;

create table Student(
	Student_id int primary key,
    Fullname varchar(50) not null ,
    date_of_birth date,
    email varchar(50) unique
);

INSERT INTO Student (Student_id, Fullname, Date_of_birth, Email)
VALUES
(1, 'Nguyen Van A', '2002-05-10', 'a@gmail.com'),
(2, 'Tran Thi B', '2001-08-20', 'b@gmail.com'),
(3, 'Le Van C', '2003-01-15', 'c@gmail.com');

UPDATE Student
SET Email = 'new_email1@gmail.com'
WHERE Student_id = 1;

UPDATE Student
SET Date_of_birth = '2001-09-01'
WHERE Student_id = 2;

DELETE FROM Student
WHERE Student_id = 5;

SELECT * FROM Student;
