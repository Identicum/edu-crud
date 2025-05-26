from flask import Blueprint, render_template, request, redirect, url_for, flash # Import flash
from models import db, Person #

persons_bp = Blueprint('persons', __name__) #

@persons_bp.route("/persons", methods=["GET"]) #
def get_persons():
    persons = Person.query.all() #
    return render_template("persons.html", persons=persons) #

@persons_bp.route("/persons", methods=["POST"]) #
def add_or_edit_person():
    person_id = request.form.get("person_id") #
    if person_id:
        person = Person.query.get(person_id) #
        if person:
            person.first_name = request.form["first_name"] #
            person.last_name = request.form["last_name"] #
            person.id_number = request.form["id_number"] #
            person.dob = request.form["dob"] #
            person.personal_email = request.form.get("personal_email") #
            flash('Person updated successfully!', 'success') # Flash message for update
        else:
            flash('Person not found for update.', 'error') # Flash message if not found
    else:
        person = Person(
            first_name=request.form["first_name"], #
            last_name=request.form["last_name"], #
            id_number=request.form["id_number"], #
            dob=request.form["dob"], #
            personal_email=request.form.get("personal_email") #
        )
        db.session.add(person) #
        flash('Person added successfully!', 'success') # Flash message for add
    db.session.commit() #
    return redirect(url_for("persons.get_persons")) #

@persons_bp.route("/persons/<int:id>/delete", methods=["POST"]) #
def delete_person(id):
    p = Person.query.get_or_404(id) #
    db.session.delete(p) #
    db.session.commit() #
    flash('Person deleted successfully!', 'success') # Flash message for delete
    return redirect(url_for("persons.get_persons")) #