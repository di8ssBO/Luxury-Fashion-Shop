// Update the notification function in ProductPage.js
function showNotification(message) {
    console.log('Showing notification: ' + message);
    var notification = document.getElementById('notification');
    if (notification) {
        notification.innerHTML = message;
        notification.style.display = 'block';
        notification.className = 'notification-popup show';

        // Hide after 3 seconds
        setTimeout(function () {
            notification.className = 'notification-popup';
            setTimeout(function () {
                notification.style.display = 'none';
            }, 300);
        }, 3000);
    } else {
        console.error('Notification element not found!');
        alert(message); // Fallback to alert if notification element not found
    }
}

// Simple function to update cart count
function updateCartCount(count) {
    if (document.getElementById('cartCount')) {
        document.getElementById('cartCount').innerText = count;
    }
}