document.addEventListener("DOMContentLoaded", function () {
    const passwordInput = document.getElementById('password');
    const togglePasswordButton = document.getElementById('toggle-password');

    if (!passwordInput || !togglePasswordButton) {
        console.error("Elementos 'password' o 'toggle-password' no encontrados.");
        return;
    }

    togglePasswordButton.addEventListener('click', function () {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);

        // Cambiar el ícono entre "mostrar" y "ocultar"
        const icon = togglePasswordButton.querySelector('i');
        if (type === 'password') {
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        } else {
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        }
    });
});