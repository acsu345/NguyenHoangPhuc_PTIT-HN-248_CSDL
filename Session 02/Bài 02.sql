create database K24_CNTT1_SESSION03;
use K24_CNTT1_SESSION03;

CREATE TABLE Class (
    ClassID INT PRIMARY KEY,
    ClassName VARCHAR(100) NOT NULL,
    AcademicYear VARCHAR(20) NOT NULL
);

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    ClassID INT NOT NULL,
    CONSTRAINT fk_student_class
        FOREIGN KEY (ClassID)
        REFERENCES Class(ClassID)
);
