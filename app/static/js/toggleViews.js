function showForm() {
    document.getElementById('list-view').style.display = 'none';
    document.getElementById('form-view').style.display = 'block';
}

function showList() { // Renamed from hideForm for consistency
    document.getElementById('form-view').style.display = 'none';
    document.getElementById('list-view').style.display = 'block';
    // Reset forms - generalize or keep specific as needed per page
    if (document.getElementById('personForm')) {
        document.getElementById('personForm').reset();
        document.getElementById('person_id').value = '';
    }
    if (document.getElementById('courseForm')) {
        document.getElementById('courseForm').reset();
        document.getElementById('course_id').value = '';
    }
    if (document.getElementById('teacherForm')) { // Assuming a teacherForm will be added
        document.getElementById('teacherForm').reset();
        document.getElementById('teacher_id').value = '';
        document.querySelector('#teacherForm select[name="person_id"]').value = '';
        document.querySelector('#teacherForm select[name="course_id"]').value = '';
        document.querySelector('#teacherForm select[name="position_type"]').value = 'FULL-TIME';
    }
    if (document.getElementById('studentForm')) { // Assuming a studentForm will be added
        document.getElementById('studentForm').reset();
        document.getElementById('student_id').value = '';
        document.querySelector('#studentForm select[name="person_id"]').value = '';
        document.querySelector('#studentForm select[name="course_id"]').value = '';
        document.querySelector('#studentForm select[name="position_type"]').value = 'REGULAR';
    }
}

function editPerson(id, firstName, lastName, idNumber, dob, email) {
    document.getElementById('person_id').value = id;
    document.querySelector('input[name="first_name"]').value = firstName;
    document.querySelector('input[name="last_name"]').value = lastName;
    document.querySelector('input[name="id_number"]').value = idNumber;
    document.querySelector('input[name="dob"]').value = dob || '';
    document.querySelector('input[name="personal_email"]').value = email || '';

    showForm();
    document.getElementById('personForm').scrollIntoView();
}

function editCourse(id, courseName) {
    document.getElementById('course_id').value = id;
    document.getElementById('course_name').value = courseName;
    showForm();
    document.getElementById('courseForm').scrollIntoView();
}

// Placeholder for Teacher edit function
function editTeacher(id, personId, courseId, positionType, startDate, endDate) {
    document.getElementById('teacher_id').value = id;
    document.querySelector('#teacherForm select[name="person_id"]').value = personId;
    document.querySelector('#teacherForm select[name="course_id"]').value = courseId;
    document.querySelector('#teacherForm select[name="position_type"]').value = positionType;
    document.querySelector('#teacherForm input[name="start_date"]').value = startDate || '';
    document.querySelector('#teacherForm input[name="end_date"]').value = endDate || '';
    showForm();
    document.getElementById('teacherForm').scrollIntoView();
}

// Placeholder for Student edit function
function editStudent(id, personId, courseId, positionType, startDate, endDate) {
    document.getElementById('student_id').value = id;
    document.querySelector('#studentForm select[name="person_id"]').value = personId;
    document.querySelector('#studentForm select[name="course_id"]').value = courseId;
    document.querySelector('#studentForm select[name="position_type"]').value = positionType;
    document.querySelector('#studentForm input[name="start_date"]').value = startDate || '';
    document.querySelector('#studentForm input[name="end_date"]').value = endDate || '';
    showForm();
    document.getElementById('studentForm').scrollIntoView();
}