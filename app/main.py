from flask import Flask, request, jsonify
from flask import render_template, redirect, url_for
from models import db, Person, Course, Teacher, Student
import config as config
import os
from sherpa.utils.basics import Logger

app = Flask(__name__)
log_level = os.environ.get("LOG_LEVEL", "")
logger = Logger("python-flask", log_level=log_level, log_path="/tmp/python-flask.log")
logger.info("Logger initialized with level: {}.", log_level)
app.config.from_object(config)
db.init_app(app)

@app.route('/health', methods=["GET"])
def getHealth():
    logger.trace("Health endpoint called.")
    return 'OK'

@app.route("/")
def home():
    return render_template("index.html")

# ---------- Person ----------
@app.route("/persons", methods=["GET"])
def get_persons():
    persons = Person.query.all()
    return render_template("persons.html", persons=persons)

@app.route("/persons", methods=["POST"])
def add_person():
    p = Person(
        first_name=request.form["first_name"],
        last_name=request.form["last_name"],
        id_number=request.form["id_number"],
        dob=request.form["dob"],
        personal_email=request.form["personal_email"]
    )
    db.session.add(p)
    db.session.commit()
    return redirect(url_for("get_persons"))

@app.route("/persons/<int:id>/delete", methods=["POST"])
def delete_person(id):
    p = Person.query.get_or_404(id)
    db.session.delete(p)
    db.session.commit()
    return redirect(url_for("get_persons"))

# ---------- Course ----------
@app.route("/courses", methods=["GET"])
def get_courses():
    courses = Course.query.all()
    return render_template("courses.html", courses=courses)

@app.route("/courses", methods=["POST"])
def add_course():
    c = Course(
        course_name=request.form["course_name"]
    )
    db.session.add(c)
    db.session.commit()
    return redirect(url_for("get_courses"))

@app.route("/courses/<int:id>/delete", methods=["POST"])
def delete_course(id):
    c = Course.query.get_or_404(id)
    db.session.delete(c)
    db.session.commit()
    return redirect(url_for("get_courses"))

# ---------- Teacher ----------

@app.route("/teachers", methods=["GET"])
def get_teachers():
    teachers = (
        db.session.query(Teacher, Person, Course)
        .join(Person, Teacher.person_id == Person.person_id)
        .join(Course, Teacher.course_id == Course.course_id)
        .all()
    )
    persons = Person.query.all()
    courses = Course.query.all()
    return render_template("teachers.html", teachers=teachers, persons=persons, courses=courses)

@app.route("/teachers", methods=["POST"])
def add_teacher():
    t = Teacher(
        person_id=request.form["person_id"],
        course_id=request.form["course_id"],
        position_type=request.form["position_type"],
        start_date=request.form.get("start_date"),
        end_date=request.form.get("end_date") or None,
    )
    db.session.add(t)
    db.session.commit()
    return redirect(url_for("get_teachers"))

@app.route("/teachers/<int:id>/delete", methods=["POST"])
def delete_teacher(id):
    t = Teacher.query.get_or_404(id)
    db.session.delete(t)
    db.session.commit()
    return redirect(url_for("get_teachers"))

# ---------- Student ----------
@app.route("/students", methods=["GET"])
def get_students():
    students = (
        db.session.query(Student, Person, Course)
        .join(Person, Student.person_id == Person.person_id)
        .join(Course, Student.course_id == Course.course_id)
        .all()
    )
    persons = Person.query.all()
    courses = Course.query.all()
    return render_template("students.html", students=students, persons=persons, courses=courses)

@app.route("/students", methods=["POST"])
def add_student():
    s = Student(
        person_id=request.form["person_id"],
        course_id=request.form["course_id"],
        position_type=request.form["position_type"],
        start_date=request.form.get("start_date"),
        end_date=request.form.get("end_date") or None,
    )
    db.session.add(s)
    db.session.commit()
    return redirect(url_for("get_students"))

@app.route("/students/<int:id>/delete", methods=["POST"])
def delete_student(id):
    s = Student.query.get_or_404(id)
    db.session.delete(s)
    db.session.commit()
    return redirect(url_for("get_students"))

# ---------- Helper ----------
def model_as_dict(self):
    return {c.name: getattr(self, c.name) for c in self.__table__.columns}

Person.as_dict = model_as_dict
Course.as_dict = model_as_dict
Teacher.as_dict = model_as_dict
Student.as_dict = model_as_dict

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")











