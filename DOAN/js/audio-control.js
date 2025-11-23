<script>
    const audio = document.getElementById("bgMusic");
    const toggleBtn = document.getElementById("toggleMusicBtn");

    // Tự động phát sau một chút delay (để tránh bị chặn)
    window.addEventListener("load", () => {
        setTimeout(() => {
            const playPromise = audio.play();

            // Nếu bị chặn, ghi cảnh báo
            if (playPromise !== undefined) {
                playPromise.catch((error) => {
                    console.warn("Trình duyệt đang chặn autoplay:", error);
                });
            }
        }, 300); // Delay nhẹ để tránh autoplay policy
    });

    // Nút bật/tắt nhạc
toggleBtn.addEventListener("click", function (e) {
    e.preventDefault(); // ❗ Chặn hành vi mặc định của nút (submit + reload)

    if (audio.paused) {
        audio.play();
        toggleBtn.textContent = "🔊";
    } else {
        audio.pause();
        toggleBtn.textContent = "🔇";
    }
});

</script>
