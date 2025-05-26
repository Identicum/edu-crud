CREATE USER eduusr WITH PASSWORD 'edupwd';
CREATE DATABASE edudb WITH OWNER=eduusr;
GRANT ALL PRIVILEGES ON DATABASE edudb TO eduusr;

\c edudb;

GRANT ALL ON SCHEMA public TO eduusr;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO eduusr;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO eduusr;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO eduusr;

-- --------------------------------------------------------------
-- FUNCTIONS

CREATE OR REPLACE FUNCTION set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.modification_time = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_person()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.org_email IS DISTINCT FROM OLD.org_email OR NEW.username IS DISTINCT FROM OLD.username THEN
      UPDATE person
      SET 
        org_email = NEW.org_email,
        username = NEW.username
      WHERE person_id = OLD.person_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------
-- TABLES

CREATE TABLE person (
        person_id            SERIAL PRIMARY KEY,
        first_name           VARCHAR(50) NOT NULL,
        last_name            VARCHAR(50) NOT NULL,
        id_number            VARCHAR(50),
        dob                  DATE,
        username             VARCHAR(32),
        personal_email       VARCHAR(100),
        org_email            VARCHAR(100),
        modification_time    TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE person ADD CONSTRAINT UQ_person_id_number UNIQUE (id_number);
CREATE TRIGGER person_upd BEFORE UPDATE ON person FOR EACH ROW EXECUTE PROCEDURE set_timestamp();

CREATE TABLE course (
        course_id            SERIAL PRIMARY KEY,
        course_name          VARCHAR(50) NOT NULL,
        modification_time    TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE course ADD CONSTRAINT UQ_course_name UNIQUE (course_name);
CREATE TRIGGER course_upd BEFORE UPDATE ON course FOR EACH ROW EXECUTE PROCEDURE set_timestamp();

CREATE TABLE teacher (
    teacher_id SERIAL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    position_type VARCHAR(15) NOT NULL CHECK (position_type IN ('FULL-TIME', 'PART-TIME', 'VISITING')),
    start_date DATE,
    end_date DATE,
    modification_time TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE
);
CREATE TRIGGER teacher_upd BEFORE UPDATE ON teacher FOR EACH ROW EXECUTE PROCEDURE set_timestamp();

CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    position_type VARCHAR(15) NOT NULL CHECK (position_type IN ('REGULAR', 'ALUMNI', 'EXCHANGE')),
    start_date DATE,
    end_date DATE,
    modification_time TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE
);
CREATE TRIGGER student_upd BEFORE UPDATE ON student FOR EACH ROW EXECUTE PROCEDURE set_timestamp();

-- --------------------------------------------------------------
-- VIEWS

CREATE OR REPLACE VIEW vw_edu AS
SELECT
  p.*,
  COALESCE(
    (
      SELECT STRING_AGG(role || '_' || pos_type || '|' || course_name, '##' ORDER BY role, pos_type, course_name)
      FROM (
        SELECT 'TEACHER' AS role, t.position_type AS pos_type, c.course_name
        FROM teacher t
        JOIN course c ON t.course_id = c.course_id
        WHERE t.person_id = p.person_id
          AND (t.start_date IS NULL OR t.start_date <= CURRENT_DATE)
          AND (t.end_date IS NULL OR t.end_date >= CURRENT_DATE)
        UNION ALL
        SELECT 'STUDENT' AS role, s.position_type AS pos_type, c.course_name
        FROM student s
        JOIN course c ON s.course_id = c.course_id
        WHERE s.person_id = p.person_id
          AND (s.start_date IS NULL OR s.start_date <= CURRENT_DATE)
          AND (s.end_date IS NULL OR s.end_date >= CURRENT_DATE)
      ) combined
    ),
    ''
  ) AS active_assignments,
  CASE
    WHEN EXISTS (
      SELECT 1 FROM teacher t
      WHERE t.person_id = p.person_id
        AND (t.start_date IS NULL OR t.start_date <= CURRENT_DATE)
        AND (t.end_date IS NULL OR t.end_date >= CURRENT_DATE)
    ) OR EXISTS (
      SELECT 1 FROM student s
      WHERE s.person_id = p.person_id
        AND (s.start_date IS NULL OR s.start_date <= CURRENT_DATE)
        AND (s.end_date IS NULL OR s.end_date >= CURRENT_DATE)
    )
    THEN 'A'
    ELSE 'I'
  END AS person_status
FROM person p;

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
