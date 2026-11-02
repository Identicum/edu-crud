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
