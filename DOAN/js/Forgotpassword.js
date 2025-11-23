document.addEventListener("DOMContentLoaded", function () {
    var btnForgot = document.getElementById('btnForgot');
    if (btnForgot) {
        btnForgot.addEventListener('click', function () {
            document.body.style.transition = "opacity 0.3s ease";
            document.body.style.opacity = 0;

            setTimeout(function () {
                window.location.href = 'Forgotpassword.aspx';
            }, 500);
        });
    }
});

        document.addEventListener("DOMContentLoaded", function () {
        if (window.location.pathname.toLowerCase().includes("forgotpassword.aspx")) {
            var container = document.getElementById('container');
        if (container) {
            container.classList.remove('right-panel-active'); // Gỡ trượt tự động
            }

        var overlay = document.querySelector('.overlay-container');
        if (overlay) {
            overlay.style.display = 'block'; // giữ overlay
            }

        var registerForm = document.querySelector('.register-container');
        if (registerForm) {
            registerForm.style.display = 'none'; // Ẩn form đăng ký
            }

        var loginForm = document.querySelector('.login-container');
        if (loginForm) {
            loginForm.style.display = 'block'; // Hiện login/reset password
            }

        // 👉 Thay đổi nội dung overlay bên phải
        var overlayRight = document.querySelector('.overlay-panel.overlay-right');
        if (overlayRight) {
            overlayRight.innerHTML = `
                <h1 class="title">Forgot Password?</h1>
                <p>Remembered your password? Log in or Register here!</p>
                <button type="button" class="ghost" id="loginBtnForgot">
                    Login
                    <i class="lni lni-arrow-right login"></i>
                </button>
            `;
            }

        // 👉 Gắn sự kiện click vào nút Login để chuyển trang về trangchu.aspx
        var loginBtnForgot = document.getElementById('loginBtnForgot');
        if (loginBtnForgot) {
            loginBtnForgot.addEventListener('click', function () {
                document.body.style.transition = "opacity 0.1s ease";
                document.body.style.opacity = 0;

                setTimeout(function () {
                    window.location.href = 'trangchu.aspx'; // Chuyển về trangchu để đăng nhập
                }, 500);
            });
            }
        }
    });