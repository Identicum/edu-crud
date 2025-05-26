from flask import Blueprint, render_template, request, redirect, url_for, flash
from models import db, Course

courses_bp = Blueprint('courses', __name__)

@courses_bp.route("/courses", methods=["GET"])
def get_courses():
    courses = Course.query.all()
    return render_template("courses.html", courses=courses)

@courses_bp.route("/courses", methods=["POST"])
def add_or_edit_course():
    course_id = request.form.get("course_id")
    if course_id:
        course = Course.query.get(course_id)
        if course:
            course.course_name = request.form["course_name"]
            flash('Course updated successfully!', 'success')
        else:
            flash('Course not found for update.', 'error')
    else:
        course = Course(
            course_name=request.form["course_name"]
        )
        db.session.add(course)
        flash('Course added successfully!', 'success')
    db.session.commit()
    return redirect(url_for("courses.get_courses"))

@courses_bp.route("/courses/<int:id>/delete", methods=["POST"])
def delete_course(id):
    c = Course.query.get_or_404(id)
    db.session.delete(c)
    db.session.commit()
    flash('Course deleted successfully!', 'success')
    return redirect(url_for("courses.get_courses"))