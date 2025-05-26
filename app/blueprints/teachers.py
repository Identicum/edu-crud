from flask import Blueprint, render_template, request, redirect, url_for, flash
from models import db, Person, Course, Teacher

teachers_bp = Blueprint('teachers', __name__)

@teachers_bp.route("/teachers", methods=["GET"])
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

@teachers_bp.route("/teachers", methods=["POST"])
def add_or_edit_teacher():
    teacher_id = request.form.get("teacher_id")
    if teacher_id:
        t = Teacher.query.get(teacher_id)
        if t:
            t.person_id = request.form["person_id"]
            t.course_id = request.form["course_id"]
            t.position_type = request.form["position_type"]
            t.start_date = request.form.get("start_date")
            t.end_date = request.form.get("end_date") or None
            flash('Teacher assignment updated successfully!', 'success')
        else:
            flash('Teacher assignment not found for update.', 'error')
    else:
        t = Teacher(
            person_id=request.form["person_id"],
            course_id=request.form["course_id"],
            position_type=request.form["position_type"],
            start_date=request.form.get("start_date"),
            end_date=request.form.get("end_date") or None,
        )
        db.session.add(t)
        flash('Teacher assignment added successfully!', 'success')
    db.session.commit()
    return redirect(url_for("teachers.get_teachers"))

@teachers_bp.route("/teachers/<int:id>/delete", methods=["POST"])
def delete_teacher(id):
    t = Teacher.query.get_or_404(id)
    db.session.delete(t)
    db.session.commit()
    flash('Teacher assignment deleted successfully!', 'success')
    return redirect(url_for("teachers.get_teachers"))