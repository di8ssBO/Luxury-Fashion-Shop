// Format number with thousands separator and specified decimal places
function formatNumber(num, decimals = 2) {
    return parseFloat(num).toFixed(decimals).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Parse price text to number
function parsePrice(priceText) {
    // Remove $, commas and non-numeric characters
    const cleanPrice = priceText.replace(/[^\d.]/g, '');
    return parseFloat(cleanPrice);
}

// Prevent form submission when Enter is pressed in input
function preventFormSubmit(event) {
    if (event.key === "Enter") {
        event.preventDefault();
        validateAndUpdateTotal(event.target);
        event.target.blur();
        return false;
    }
    return true;
}

// Validate input and update total when user types in quantity field
function validateAndUpdateTotal(input) {
    // Get current value
    let value = input.value.trim();

    // Remove non-numeric characters
    value = value.replace(/[^\d]/g, '');

    // Convert to integer (minimum value is 1)
    let quantity = parseInt(value);

    // If not a valid number, set to 1
    if (isNaN(quantity) || quantity < 1) {
        quantity = 1;
    }

    // Update input value
    input.value = quantity;

    // Update row total
    updateRowTotal(input);

    // Update cart total
    updateCartTotal();
}

// Decrease quantity
function decreaseQuantity(btn) {
    const row = btn.closest('tr');
    const input = row.querySelector('input[type="text"]');
    const currentValue = parseInt(input.value);

    if (currentValue > 1) {
        input.value = currentValue - 1;
        updateRowTotal(input);
        updateCartTotal();
    }
}

// Increase quantity
function increaseQuantity(btn) {
    const row = btn.closest('tr');
    const input = row.querySelector('input[type="text"]');
    const currentValue = parseInt(input.value);

    input.value = currentValue + 1;
    updateRowTotal(input);
    updateCartTotal();
}

// Update total for a specific row
function updateRowTotal(input) {
    const quantity = parseInt(input.value) || 1; // Default to 1 if invalid
    const row = input.closest('tr');
    const priceCell = row.cells[3]; // Price is in the 4th column (index 3)
    const totalPriceCell = row.cells[5]; // Total Price is in the 6th column (index 5)

    if (priceCell && totalPriceCell) {
        // Parse the price (remove currency symbol and formatting)
        const price = parsePrice(priceCell.textContent);

        // Calculate total price
        const totalPrice = price * quantity;

        // Update total price cell
        totalPriceCell.textContent = totalPrice.toFixed(2);
    }
}

// Remove item from cart
//function removeItem(btn) {
//    if (confirm('Are you sure you want to delete this product?')) {
//        const row = btn.closest('tr');
//        const variantID = row.querySelector('[id$=VariantIDLabel]').textContent;

//        // Gọi AJAX để xóa sản phẩm trên server
//        $.ajax({
//            type: "POST",
//            url: "WebForm-GioHang.aspx/RemoveItemFromCart",
//            data: JSON.stringify({ variantID: parseInt(variantID) }),
//            contentType: "application/json; charset=utf-8",
//            dataType: "json",
//            success: function (response) {
//                // Xóa dòng trên giao diện
//                row.remove();
//                updateCartTotal();

//                // Cập nhật thông báo
//                const remainingItems = parseInt(response.d);
//                const debugLabel = document.querySelector('#DebugLabel');

//                if (remainingItems === 0) {
//                    if (debugLabel) {
//                        debugLabel.textContent = "🛒 Không có sản phẩm nào trong giỏ.";
//                    }
//                } else {
//                    if (debugLabel) {
//                        debugLabel.textContent = `🛒 Có ${remainingItems} sản phẩm trong giỏ.`;
//                    }
//                }
//            },
//            error: function (error) {
//                console.log("Lỗi khi xóa sản phẩm:", error);
//            }
//        });
//    }
//}

// Toggle all checkboxes
function toggleAllCheckboxes() {
    const mainCheckbox = document.querySelector('th input[type="checkbox"]');
    const checkboxes = document.querySelectorAll('td input[type="checkbox"]');

    checkboxes.forEach(checkbox => {
        checkbox.checked = mainCheckbox.checked;
    });

    updateCartTotal();
}

// Update cart total
function updateCartTotal() {
    let total = 0;
    const rows = document.querySelectorAll('tr');

    rows.forEach(row => {
        // Skip header row
        if (row.querySelector('th')) return;

        const checkbox = row.querySelector('input[type="checkbox"]');
        if (checkbox && checkbox.checked) {
            const quantityInput = row.querySelector('input[type="text"]');
            const priceCell = row.cells[3]; // Price column

            if (quantityInput && priceCell) {
                const price = parsePrice(priceCell.textContent);
                const quantity = parseInt(quantityInput.value) || 1;
                total += price * quantity;
            }
        }
    });

    // Update total payment display
    const totalPaymentElement = document.querySelector('#cartTotalValue');
    if (totalPaymentElement) {
        totalPaymentElement.textContent = '$' + formatNumber(total);
    }
}

// Proceed to checkout
function proceedToCheckout() {
    // Count selected items
    const selectedItems = document.querySelectorAll('input[type="checkbox"]:checked').length;

    if (selectedItems === 0) {
        alert('Please select at least one product to purchase.');
        return;
    }

    alert('Proceeding to checkout...');
    // Here you would redirect to checkout page or process
}

// Initialize page
window.onload = function () {
    // Initial calculation for each row
    const rows = document.querySelectorAll('tr');

    rows.forEach(row => {
        // Skip header row
        if (row.querySelector('th')) return;

        const quantityInput = row.querySelector('input[type="text"]');
        if (quantityInput) {
            // Set up event listeners for quantity inputs
            quantityInput.addEventListener('change', function () {
                validateAndUpdateTotal(this);
            });

            quantityInput.addEventListener('keyup', function () {
                validateAndUpdateTotal(this);
            });

            // Initial calculation
            updateRowTotal(quantityInput);
        }
    });

    // Add listeners to all minus buttons
    document.querySelectorAll('.quantity button:first-child').forEach(button => {
        button.addEventListener('click', function () {
            decreaseQuantity(this);
        });
    });

    // Add listeners to all plus buttons
    document.querySelectorAll('.quantity button:last-child').forEach(button => {
        button.addEventListener('click', function () {
            increaseQuantity(this);
        });
    });

    // Add listeners to checkboxes
    document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
        checkbox.addEventListener('change', updateCartTotal);
    });

    // Set up main checkbox
    const mainCheckbox = document.querySelector('th input[type="checkbox"]');
    if (mainCheckbox) {
        mainCheckbox.addEventListener('change', toggleAllCheckboxes);
    }

    // Initial cart total
    updateCartTotal();
};


