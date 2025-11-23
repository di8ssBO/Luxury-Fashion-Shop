document.addEventListener("DOMContentLoaded", function () {
    try {
        const registerButton = document.getElementById("register");
        const loginButton = document.getElementById("login");
        const container = document.getElementById("container");

        if (registerButton && loginButton && container) {
            registerButton.addEventListener("click", function (e) {
                e.preventDefault();
                container.classList.add("right-panel-active");
            });

            loginButton.addEventListener("click", function (e) {
                e.preventDefault();
                container.classList.remove("right-panel-active");
            });
        } else {
            console.error("Một hoặc nhiều phần tử không được tìm thấy!");
        }
    } catch (error) {
        console.error("Lỗi trong script.js:", error);
    }
});