document.addEventListener("DOMContentLoaded", function () {
    const btnPlus = document.getElementById("btnPlus");
    const btnMinus = document.getElementById("btnMinus");
    const txtQty = document.getElementById("txtQty");

    btnPlus.addEventListener("click", () => {
        txtQty.value = parseInt(txtQty.value) + 1;
    });
    btnMinus.addEventListener("click", () => {
        let v = parseInt(txtQty.value);
        if (v > 1) txtQty.value = v - 1;
    });
});