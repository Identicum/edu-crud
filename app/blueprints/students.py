from flask import Blueprint, render_template, request, redirect, url_for, flash
from models import db, Person, Course, Student

students_bp = Blueprint('students', __name__)

@students_bp.route("/students", methods=["GET"])
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

@students_bp.route("/students", methods=["POST"])
def add_or_edit_student():
    student_id = request.form.get("student_id")
    if student_id:
        s = Student.query.get(student_id)
        if s:
            s.person_id = request.form["person_id"]
            s.course_id = request.form["course_id"]
            s.position_type = request.form["position_type"]
            s.start_date = request.form.get("start_date")
            s.end_date = request.form.get("end_date") or None
            flash('Student assignment updated successfully!', 'success')
        else:
            flash('Student assignment not found for update.', 'error')
    else:
        s = Student(
            person_id=request.form["person_id"],
            course_id=request.form["course_id"],
            position_type=request.form["position_type"],
            start_date=request.form.get("start_date"),
            end_date=request.form.get("end_date") or None,
        )
        db.session.add(s)
        flash('Student assignment added successfully!', 'success')
    db.session.commit()
    return redirect(url_for("students.get_students"))

@students_bp.route("/students/<int:id>/delete", methods=["POST"])
def delete_student(id):
    s = Student.query.get_or_404(id)
    db.session.delete(s)
    db.session.commit()
    flash('Student assignment deleted successfully!', 'success')
    return redirect(url_for("students.get_students"))