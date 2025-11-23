// Client-side validation
document.getElementById('form1').addEventListener('submit', function (e) {
    var recipient = document.getElementById('recipient').value.trim();
    var address = document.getElementById('address').value.trim();
    var phone = document.getElementById('phone').value.trim();

    if (!recipient || !address || !phone) {
        e.preventDefault();
        alert('Please fill in all required fields.');
        return false;
    }

    // Basic phone validation
    var phonePattern = /^\d{10,12}$/;
    if (!phonePattern.test(phone.replace(/[^\d]/g, ''))) {
        e.preventDefault();
        alert('Please enter a valid phone number.');
        return false;
    }

    return true;
});

// OrdersPay.js - Client-side functionality for the OrdersPay page

document.addEventListener('DOMContentLoaded', function() {
    // Form validation
    const form = document.getElementById('form1');
    if (form) {
        form.addEventListener('submit', validateForm);
    }
    
    // Payment method selection
    const paymentOptions = document.querySelectorAll('.payment-option');
    if (paymentOptions.length > 0) {
        paymentOptions.forEach(option => {
            option.addEventListener('click', function() {
                // Find the radio input inside this option and select it
                const radio = this.querySelector('input[type="radio"]');
                if (radio) {
                    radio.checked = true;
                }
            });
        });
    }
    
    // Delivery method selection
    const deliveryOptions = document.querySelectorAll('.delivery-options');
    if (deliveryOptions.length > 0) {
        deliveryOptions.forEach(option => {
            option.addEventListener('click', function() {
                // Find the radio input inside this option and select it
                const radio = this.querySelector('input[type="radio"]');
                if (radio) {
                    radio.checked = true;
                }
            });
        });
    }
});

// Validate form before submission
function validateForm(e) {
    const recipient = document.getElementById('recipient').value.trim();
    const address = document.getElementById('address').value.trim();
    const phone = document.getElementById('phone').value.trim();
    
    let isValid = true;
    let errorMessage = '';
    
    // Check if required fields are filled
    if (!recipient) {
        errorMessage = "Please enter the recipient's name.";
        isValid = false;
    } else if (!address) {
        errorMessage = "Please enter the delivery address.";
        isValid = false;
    } else if (!phone) {
        errorMessage = "Please enter a phone number.";
        isValid = false;
    }
    
    // Basic phone number validation
    if (isValid && phone) {
        const digitsOnly = phone.replace(/\D/g, '');
        if (digitsOnly.length < 10 || digitsOnly.length > 12) {
            errorMessage = "Please enter a valid phone number.";
            isValid = false;
        }
    }
    
    // If validation fails, prevent form submission and show error
    if (!isValid) {
        e.preventDefault();
        alert(errorMessage);
        return false;
    }
    
    return true;
}

// Format currency (optional utility function)
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(amount);
}