\c edudb;

-- --------------------------------------------------------------
-- DATA

INSERT INTO person (first_name, last_name, id_number, dob, personal_email)
VALUES
('Alice', 'Johnson', '11222001', '1985-02-15', 'alice@gmail.com'),
('Bob', 'Smith', '11222002', '1979-11-23', 'bob@gmail.com'),
('Carol', 'Lee', '11222003', '1990-04-30', 'carol@gmail.com'),
('David', 'Nguyen', '11222004', '1988-07-12', 'david.nguyen@gmail.com'),
('Emma', 'Williams', '11222005', '1995-01-20', 'emma.w@gmail.com'),
('Frank', 'Brown', '11222006', '1982-03-18', 'frank.brown@gmail.com'),
('Grace', 'Taylor', '11222007', '1993-09-25', 'grace.taylor@gmail.com'),
('Henry', 'Davis', '11222008', '1980-05-05', 'henry.davis@gmail.com'),
('Isabella', 'Martinez', '11222009', '1997-12-03', 'isabella.m@gmail.com'),
('Jack', 'Wilson', '11222010', '1986-06-30', 'jack.wilson@gmail.com'),
('Karen', 'Moore', '11222011', '1991-08-22', 'karen.moore@gmail.com'),
('Leo', 'Anderson', '11222012', '1984-11-01', 'leo.anderson@gmail.com'),
('Mia', 'Thomas', '11222013', '1999-02-14', 'mia.thomas@gmail.com'),
('Nina', 'Lopez', '11222014', '1992-07-10', 'nina.lopez@gmail.com'),
('Owen', 'Bennett', '11222015', '1987-03-03', 'owen.bennett@gmail.com'),
('Paula', 'Kim', '11222016', '1990-06-18', 'paula.kim@gmail.com'),
('Quentin', 'Reed', '11222017', '1983-01-11', 'quentin.reed@gmail.com'),
('Rachel', 'Scott', '11222018', '1996-09-07', 'rachel.scott@gmail.com'),
('Sam', 'Foster', '11222019', '1985-05-28', 'sam.foster@gmail.com'),
('Tina', 'Evans', '11222020', '1998-12-17', 'tina.evans@gmail.com'),
('Uriel', 'Cruz', '11222021', '1981-08-19', 'uriel.cruz@gmail.com'),
('Vera', 'Hughes', '11222022', '1994-04-04', 'vera.hughes@gmail.com'),
('Walter', 'Price', '11222023', '1989-10-30', 'walter.price@gmail.com'),
('Xavier', 'Morgan', '11222024', '1986-02-08', 'xavier.morgan@gmail.com'),
('Yara', 'Bell', '11222025', '1993-11-16', 'yara.bell@gmail.com'),
('Zane', 'Fleming', '11222026', '1990-07-21', 'zane.fleming@gmail.com');

INSERT INTO course (course_name)
VALUES
('Introduction to Computer Science'),
('Linear Algebra'),
('Classical Mechanics'),
('Organic Chemistry'),
('Data Structures and Algorithms'),
('Microeconomics'),
('Modern European History'),
('Software Engineering Principles');

INSERT INTO teacher (person_id, course_id, position_type, start_date, end_date) VALUES (1, 1, 'FULL-TIME', '2023-09-01', NULL);
INSERT INTO teacher (person_id, course_id, position_type, start_date, end_date) VALUES (1, 4, 'PART-TIME', '2024-01-10', NULL);
INSERT INTO teacher (person_id, course_id, position_type, start_date, end_date) VALUES (2, 2, 'VISITING', '2022-01-01', '2022-12-31');
INSERT INTO teacher (person_id, course_id, position_type, start_date, end_date) VALUES (3, 3, 'FULL-TIME', '2024-09-01', NULL);
INSERT INTO teacher (person_id, course_id, position_type, start_date, end_date) VALUES (13, 1, 'PART-TIME', '2024-01-10', NULL);
INSERT INTO teacher (person_id, course_id, position_type, start_date, end_date) VALUES (14, 1, 'PART-TIME', '2024-01-10', NULL);

INSERT INTO student (person_id, course_id, position_type, start_date, end_date) VALUES (13, 5, 'REGULAR', '2023-09-01', NULL);
INSERT INTO student (person_id, course_id, position_type, start_date, end_date) VALUES (13, 8, 'REGULAR', '2023-09-01', NULL);
INSERT INTO student (person_id, course_id, position_type, start_date, end_date) VALUES (14, 5, 'REGULAR', '2023-09-01', NULL);
INSERT INTO student (person_id, course_id, position_type, start_date, end_date) VALUES (14, 8, 'REGULAR', '2023-09-01', NULL);
INSERT INTO student (person_id, course_id, position_type, start_date, end_date) VALUES (15, 6, 'ALUMNI', '2024-01-10', NULL);
INSERT INTO student (person_id, course_id, position_type, start_date, end_date) VALUES (16, 3, 'EXCHANGE', '2024-01-01', NULL);
INSERT INTO student (person_id, course_id, position_type, start_date, end_date) VALUES (16, 4, 'EXCHANGE', '2024-01-01', NULL);
INSERT INTO student (person_id, course_id, position_type, start_date, end_date) VALUES (17, 4, 'REGULAR', '2024-09-01', NULL);
INSERT INTO student (person_id, course_id, position_type, start_date, end_date) VALUES (17, 5, 'REGULAR', '2024-09-01', NULL);
