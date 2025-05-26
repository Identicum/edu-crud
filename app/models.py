from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Person(db.Model):
    __tablename__ = 'person'
    person_id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    id_number = db.Column(db.String(50))
    dob = db.Column(db.Date)
    username = db.Column(db.String(32))
    personal_email = db.Column(db.String(100))
    org_email = db.Column(db.String(100))
    modification_time = db.Column(db.DateTime)
    teachers = db.relationship('Teacher', backref='person', lazy=True, cascade="all, delete-orphan")
    students = db.relationship('Student', backref='person', lazy=True, cascade="all, delete-orphan")

class Course(db.Model):
    __tablename__ = 'course'
    course_id = db.Column(db.Integer, primary_key=True)
    course_name = db.Column(db.String(50), nullable=False)
    modification_time = db.Column(db.DateTime)
    teachers_assigned = db.relationship('Teacher', backref='course', lazy=True, cascade="all, delete-orphan")
    students_enrolled = db.relationship('Student', backref='course', lazy=True, cascade="all, delete-orphan")

class Teacher(db.Model):
    __tablename__ = 'teacher'
    teacher_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, db.ForeignKey('person.person_id'), nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey('course.course_id'), nullable=False)
    position_type = db.Column(db.String(15), nullable=False)
    start_date = db.Column(db.Date)
    end_date = db.Column(db.Date)
    modification_time = db.Column(db.DateTime)

class Student(db.Model):
    __tablename__ = 'student'
    student_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, db.ForeignKey('person.person_id'), nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey('course.course_id'), nullable=False)
    position_type = db.Column(db.String(15), nullable=False)
    start_date = db.Column(db.Date)
    end_date = db.Column(db.Date)
    modification_time = db.Column(db.DateTime)
