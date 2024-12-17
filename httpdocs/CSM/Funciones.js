function ErrorMessages() {
    const urlParams = new URLSearchParams(window.location.search);
    
    // Manejar errores para la página de registro
    if (urlParams.get('error') === '1') {
        if (document.getElementById('error-message_register')) {
            document.getElementById('error-message_register').textContent = 'El nombre de usuario o el correo electrónico ya están registrados.';
        }
    }
    
    // Manejar errores para la página de login
    if (urlParams.get('error') === '1') {
        if (document.getElementById('error-message_login')) {
            document.getElementById('error-message_login').textContent = 'El correo electrónico/usuario o la contraseña son incorrectos.';
        }
    }
}

window.onload = ErrorMessages;