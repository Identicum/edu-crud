function showForm() {
    document.getElementById('list-view').style.display = 'none';
    document.getElementById('form-view').style.display = 'block';
}

function hideForm() {
    document.getElementById('form-view').style.display = 'none';
    document.getElementById('list-view').style.display = 'block';
    document.getElementById('personForm').reset();
    document.getElementById('person_id').value = '';
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
