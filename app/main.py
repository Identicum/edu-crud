from flask import Flask, render_template
from models import db, Person, Course, Teacher, Student
import config as config
import os
from sherpa.utils.basics import Logger

from blueprints.persons import persons_bp
from blueprints.courses import courses_bp
from blueprints.teachers import teachers_bp
from blueprints.students import students_bp

app = Flask(__name__)
log_level = os.environ.get("LOG_LEVEL", "")
logger = Logger("edu-crud", log_level=log_level, log_path="/tmp/edu-crud.log")
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

# Register Blueprints
app.register_blueprint(persons_bp)
app.register_blueprint(courses_bp)
app.register_blueprint(teachers_bp)
app.register_blueprint(students_bp)

# ---------- Helper ----------
def model_as_dict(self):
    return {c.name: getattr(self, c.name) for c in self.__table__.columns}

Person.as_dict = model_as_dict
Course.as_dict = model_as_dict
Teacher.as_dict = model_as_dict
Student.as_dict = model_as_dict

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")