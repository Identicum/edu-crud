document.addEventListener('DOMContentLoaded', () => {
    const darkModeToggle = document.getElementById('darkModeToggle');
    const body = document.body;

    // Check for user's preferred theme in local storage or system preference
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        if (savedTheme === 'dark') {
            body.classList.add('dark-mode');
            darkModeToggle.checked = true;
        }
    } else if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
        // If no theme saved, check system preference
        body.classList.add('dark-mode');
        darkModeToggle.checked = true;
    }

    darkModeToggle.addEventListener('change', () => {
        if (darkModeToggle.checked) {
            body.classList.add('dark-mode');
            localStorage.setItem('theme', 'dark');
        } else {
            body.classList.remove('dark-mode');
            localStorage.setItem('theme', 'light');
        }
    });
});