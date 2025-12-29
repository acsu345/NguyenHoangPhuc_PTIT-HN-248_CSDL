create database bai05;
use bai05;

create table Student(
	Student_id int primary key,
    Fullname varchar(50) not null ,
    date_of_birth date,
    email varchar(50) unique
);

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT NOT NULL CHECK (credit > 0)
);
CREATE TABLE Enrollment (
    Student_id INT,
    Subject_id INT,
    Enroll_date DATE NOT NULL,
    PRIMARY KEY (Student_id, Subject_id),
    FOREIGN KEY (Student_id) REFERENCES Student(Student_id),
    FOREIGN KEY (Subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Student (Student_id, Fullname, date_of_birth, email)
VALUES
(1, 'Nguyen Van A', '2002-05-10', 'a@gmail.com'),
(2, 'Tran Thi B', '2001-08-20', 'b@gmail.com');

INSERT INTO Subject (subject_id, subject_name, credit)
VALUES
(1, 'Co so du lieu', 3),
(2, 'Lap trinh Java', 4),
(3, 'He dieu hanh', 3);

INSERT INTO Enrollment (Student_id, Subject_id, Enroll_date)
VALUES
(1, 1, '2025-01-10'),
(1, 2, '2025-01-11'),
(2, 1, '2025-01-12'),
(2, 3, '2025-01-13');

SELECT * FROM Enrollment;

