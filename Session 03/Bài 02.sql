create database bai02 ;
use bai02;

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

SELECT * FROM Student;
SELECT Student_id, Fullname FROM Student;

