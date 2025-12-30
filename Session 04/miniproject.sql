create database session04;
use session04;

create table student (
  student_id  varchar(20) primary key,
  full_name   varchar(100) not null,
  dob         date not null,
  email       varchar(120) not null unique
);

create table teacher (
  teacher_id  varchar(20) primary key,
  full_name   varchar(100) not null,
  email       varchar(120) not null unique
);

create table course (
  course_id     varchar(20) primary key,
  course_name   varchar(120) not null,
  short_desc    varchar(255),
  sessions      int not null,
  teacher_id    varchar(20) not null,
  check (sessions > 0),
  foreign key (teacher_id) references teacher(teacher_id)
);

create table enrollment (
  enrollment_id int auto_increment primary key,
  student_id    varchar(20) not null,
  course_id     varchar(20) not null,
  enroll_date   date not null,
  foreign key (student_id) references student(student_id),
  foreign key (course_id) references course(course_id)
);

create table result (
  student_id   varchar(20) not null,
  course_id    varchar(20) not null,
  mid_score    decimal(4,2) not null,
  final_score  decimal(4,2) not null,
  check (mid_score >= 0 and mid_score <= 10),
  check (final_score >= 0 and final_score <= 10),
  primary key (student_id, course_id),
  foreign key (student_id) references student(student_id),
  foreign key (course_id) references course(course_id)
);

insert into student (student_id, full_name, dob, email) values
('sv001', 'Nguyễn Văn An',  '2005-03-12', 'an.sv001@uni.edu'),
('sv002', 'Trần Thị Bình',  '2005-07-21', 'binh.sv002@uni.edu'),
('sv003', 'Lê Minh Châu',   '2004-11-02', 'chau.sv003@uni.edu'),
('sv004', 'Phạm Gia Duy',   '2005-01-15', 'duy.sv004@uni.edu'),
('sv005', 'Vũ Thảo Linh',   '2004-09-30', 'linh.sv005@uni.edu');

insert into teacher (teacher_id, full_name, email) values
('gv001', 'TS. Nguyễn Hải',     'hai.gv001@uni.edu'),
('gv002', 'ThS. Trần Quang',    'quang.gv002@uni.edu'),
('gv003', 'TS. Lê Thu',         'thu.gv003@uni.edu'),
('gv004', 'ThS. Phạm Long',     'long.gv004@uni.edu'),
('gv005', 'TS. Vũ Mai',         'mai.gv005@uni.edu');

insert into course (course_id, course_name, short_desc, sessions, teacher_id) values
('c001', 'Cơ sở dữ liệu',        'SQL, thiết kế CSDL, chuẩn hóa', 12, 'gv001'),
('c002', 'Lập trình Web',        'HTML/CSS/JS cơ bản đến nâng cao', 15, 'gv002'),
('c003', 'Cấu trúc dữ liệu',     'Danh sách, cây, đồ thị', 14, 'gv003'),
('c004', 'Mạng máy tính',        'TCP/IP, routing, security', 10, 'gv004'),
('c005', 'Kỹ thuật phần mềm',    'UML, Agile, kiểm thử', 11, 'gv005');

insert into enrollment (student_id, course_id, enroll_date) values
('sv001', 'c001', '2025-12-01'),
('sv001', 'c002', '2025-12-03'),
('sv002', 'c001', '2025-12-01'),
('sv002', 'c003', '2025-12-05'),
('sv003', 'c002', '2025-12-03'),
('sv003', 'c004', '2025-12-06'),
('sv004', 'c005', '2025-12-07'),
('sv005', 'c001', '2025-12-02');

insert into result (student_id, course_id, mid_score, final_score) values
('sv001', 'c001', 7.50, 8.00),
('sv001', 'c002', 6.50, 7.25),
('sv002', 'c001', 8.00, 8.50),
('sv002', 'c003', 7.00, 7.75),
('sv003', 'c002', 9.00, 9.25),
('sv003', 'c004', 6.75, 7.00),
('sv004', 'c005', 8.25, 8.75),
('sv005', 'c001', 5.50, 6.25);

update student
set email = 'an.new.sv001@uni.edu'
where student_id = 'sv001';

update course
set short_desc = 'html/css/js + du an mini website'
where course_id = 'c002';

update result
set final_score = 9.75
where student_id = 'sv003' and course_id = 'c002';

delete from enrollment
where student_id = 'sv005' and course_id = 'c001';

delete from result
where student_id = 'sv005' and course_id = 'c001';

select * from student;
select * from teacher;
select * from course;
select * from enrollment;
select * from result;
