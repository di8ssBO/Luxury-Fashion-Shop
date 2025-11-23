function checkDuplicate(type) {
    var inputId = "", errorId = "";

    if (type === "username") {
        inputId = "RegisterContent_txtUsername";    // id thực tế
        errorId = "usernameError";
    } else if (type === "email") {
        inputId = "RegisterContent_txtEmail";
        errorId = "emailError";
    } else if (type === "phone") {
        inputId = "RegisterContent_txtPhone";
        errorId = "phoneError";
    }

    var inputField = document.getElementById(inputId);
    var errorDiv = document.getElementById(errorId);

    if (!inputField || !errorDiv) return;

    var value = inputField.value.trim();
    if (value === "") {
        errorDiv.innerHTML = "";
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "CheckDuplicateRegister.aspx", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            if (xhr.responseText.trim() == "EXISTS") {
                errorDiv.innerHTML = "<span class='error-message'>❗ This " + type + " is already registered!</span>";
                inputField.classList.add('checkregister');
            } else {
                errorDiv.innerHTML = "";
                inputField.classList.remove('checkregister');
            }
        }
    };
    xhr.send("type=" + type + "&value=" + encodeURIComponent(value));
}
