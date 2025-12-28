create database teacher;
use teacher;


CREATE TABLE Subject (
    Ma_mon_hoc INT PRIMARY KEY,
    Ten_mon_hoc VARCHAR(30),
    So_tin_chi INT NOT NULL CHECK (So_tin_chi > 0)
);

CREATE TABLE Student (
    Ma_sinh_vien INT PRIMARY KEY,
    Ho_ten VARCHAR(50)
);

CREATE TABLE Register (
    Ma_sinh_vien INT NOT NULL,
    Ma_mon_hoc INT NOT NULL,
    Ngay_dang_ky DATE,
    PRIMARY KEY (Ma_sinh_vien, Ma_mon_hoc),
    FOREIGN KEY (Ma_sinh_vien) REFERENCES Student(Ma_sinh_vien),
    FOREIGN KEY (Ma_mon_hoc) REFERENCES Subject(Ma_mon_hoc)
);

CREATE TABLE Teacher (
    Ma_giang_vien INT PRIMARY KEY,
    Ho_ten VARCHAR(50),
    Email VARCHAR(100)
);

ALTER TABLE Subject
ADD Ma_giang_vien INT;

ALTER TABLE Subject
ADD FOREIGN KEY (Ma_giang_vien)
REFERENCES Teacher(Ma_giang_vien);
