create database class01 ;
use class01;

create table Student(
	Student_id int primary key,
    Fullname varchar(50) not null ,
    email varchar(50) unique
);

create table Subject (
	Subject_id int primary key,
    Subject_name varchar(50) not null,
    credit int not null
);

create table enrollment (
	Student_id int not null,
    Subject_id int not null,
    primary key (Student_id, Subject_id),
    foreign key (Student_id) references Student(Student_id),
    foreign key (Subject_id) references Subject(Subject_id)
);

create table Score (
	Student_id int not null,
    Subject_id int not null,
    Score float,
    primary key (Student_id, Subject_id),
    foreign key (Student_id) references Student(Student_id),
    foreign key (Subject_id) references Subject(Subject_id)
);

insert into Subject VALUES
(1, 'Database', 3),
(2, 'Java', 4),
(3, 'Web', 3);

insert into Student (Student_id, Fullname, email)
VALUES (101, 'Nguyen Van A', 'a@gmail.com');

insert into Enrollment VALUES
(101, 1),
(101, 2);

insert into Score VALUES
(101, 1, 8.5),
(101, 2, 7.0);

update Score
set score = 9.0
where Student_id = 101 and Subject_id = 2;

delete from Enrollment
where Student_id = 101 and Subject_id = 2;

SELECT
    Student_id,
    Subject_id,
    Score
FROM Score;






