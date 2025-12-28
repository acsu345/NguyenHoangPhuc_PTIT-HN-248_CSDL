create database student;
use student;

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL
);
CREATE TABLE Subject (
    SubjectID INT PRIMARY KEY,
    SubjectName VARCHAR(100) NOT NULL,
    Credits INT NOT NULL,
    CONSTRAINT chk_credits_positive CHECK (Credits > 0)
);

