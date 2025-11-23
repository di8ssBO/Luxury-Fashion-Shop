<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm-FirstPage.aspx.cs" Inherits="DOAN_TMDT.WebForm_FirstPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Fashion Playlist Page</title>
    <link rel="stylesheet" href="../css/CSS-FirstPage.css" />        
</head>
<body>
    <form id="form1" runat="server">
        <!-- Container chứa tất cả video -->
        <div class="video-container">
            <video class="bg-video" muted preload="auto">
                <source class="videoSource1" src="../Video/DIOR11.mp4" type="video/mp4" />
                Trình duyệt không hỗ trợ video.
            </video>
            <video class="bg-video" muted preload="auto">
                <source class="videoSource2" src="../Video/DIOR2.mp4" type="video/mp4" />
                Trình duyệt không hỗ trợ video.
            </video>
            <video class="bg-video" muted preload="auto">
                <source class="videoSource3" src="../Video/LV21.mp4" type="video/mp4" />
                Trình duyệt không hỗ trợ video.
            </video>
            <video class="bg-video" muted preload="auto">
                <source class="videoSource4" src="../Video/LV.mp4" type="video/mp4" />
                Trình duyệt không hỗ trợ video.
            </video>
            <video class="bg-video" muted preload="auto">
                 <source class="videoSource5" src="../Video/Gucci1.mp4" type="video/mp4" />
                 Trình duyệt không hỗ trợ video.
            </video>
            <video class="bg-video" muted preload="auto">
                 <source class="videoSource6" src="../Video/Gucci2.mp4" type="video/mp4" />
                Trình duyệt không hỗ trợ video.
            </video>
            <video class="bg-video" muted preload="auto">
                <source class="videoSource7" src="../Video/Chanel.mp4" type="video/mp4" />
                Trình duyệt không hỗ trợ video.
            </video>
            <video class="bg-video" muted preload="auto">
                <source class="videoSource7" src="../Video/Chanel3.mp4" type="video/mp4" />
                Trình duyệt không hỗ trợ video.
                </video>
      
        </div>

        <!-- AUDIO nền dùng chung -->
        <audio id="bgMusic" autoplay loop>
            <source src="../Audio/Opening.mp3" type="audio/mp3" />
        </audio>

        <!-- Nút bật/tắt âm thanh -->
        <button type="button" id="toggleMusicBtn" class="music-toggle">🔊</button>

        <!-- Nội dung phủ lên -->
        <div class="overlay-content">
            <h1 class="brand-logo">Luxury Fashion </h1>
            <p class="subtitle">The Fall Winter 2025 catwalks have wrapped up across fashion capitals.<br> 
                We’re ready to highlight the season’s top accessory trends.</p>
            <a href="../SignIn_Up/trangchu.aspx" class="explore-btn">Shop now</a>
        </div>
    </form>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const videoContainer = document.querySelector(".video-container");
            const videos = document.querySelectorAll(".bg-video");
            const sources = document.querySelectorAll(".bg-video source");
            const audio = document.getElementById("bgMusic");
            const toggleBtn = document.getElementById("toggleMusicBtn");
            const brandLogo = document.querySelector(".brand-logo");

            const playlist = [
                "../Video/DIOR11.mp4",
                "../Video/DIOR2.mp4",
                "../Video/LV21.mp4",
                "../Video/LV.mp4",
                "../Video/Gucci2.mp4",
                "../Video/Gucci1.mp4",
                "../Video/Chanel.mp4",
                "../Video/Chanel2.mp4",

            ];
            let currentIndex = 0;
            let isFirstVideo = true;

            // Hàm chuyển đổi video
            function switchVideo() {
                const currentVideo = videos[currentIndex];
                const nextIndex = (currentIndex + 1) % playlist.length;
                const nextVideo = videos[nextIndex];

                // Cập nhật nguồn video tiếp theo
                sources[nextIndex].src = playlist[nextIndex];
                nextVideo.load();

                nextVideo.onerror = () => {
                    console.error("Lỗi tải video:", playlist[nextIndex]);
                    switchVideo(); // Chuyển sang video tiếp theo nếu lỗi
                };

                nextVideo.onloadedmetadata = () => {
                    nextVideo.oncanplay = () => {
                        // Tắt video hiện tại
                        currentVideo.pause();
                        let opacity = 1;
                        const fadeOut = setInterval(() => {
                            if (opacity > 0) {
                                opacity -= 0.1;
                                currentVideo.style.opacity = opacity;
                            } else {
                                clearInterval(fadeOut);
                                currentVideo.style.opacity = 0;
                            }
                        }, 50); // Tốc độ fade out (20fps)

                        // Bật video tiếp theo với fade in
                        nextVideo.style.opacity = 0;
                        nextVideo.play().catch(err => {
                            console.warn("Không thể phát video:", err);
                        });
                        let nextOpacity = 0;
                        const fadeIn = setInterval(() => {
                            if (nextOpacity < 1) {
                                nextOpacity += 0.1;
                                nextVideo.style.opacity = nextOpacity;
                            } else {
                                clearInterval(fadeIn);
                                nextVideo.style.opacity = 1;
                            }
                        }, 50); // Tốc độ fade in (20fps)

                        currentIndex = nextIndex;

                        if (isFirstVideo) {
                            brandLogo.classList.add("moved");
                            document.querySelector(".subtitle").classList.add("moved");
                            document.querySelector(".explore-btn").classList.add("moved");
                            isFirstVideo = false;
                        }

                        // Lên lịch chuyển video tiếp theo khi video hiện tại kết thúc
                        nextVideo.addEventListener("ended", switchVideo);
                    };
                };
            }

            // Khởi động video đầu tiên
            const initialVideo = videos[0];
            sources[0].src = playlist[0];
            initialVideo.load();
            initialVideo.onloadedmetadata = () => {
                initialVideo.oncanplay = () => {
                    initialVideo.style.opacity = 1;
                    initialVideo.play().catch(err => {
                        console.warn("Không thể phát video đầu tiên:", err);
                    });
                    initialVideo.addEventListener("ended", switchVideo);
                };
            };

            // Tắt/mở nhạc nền
            toggleBtn.addEventListener("click", function () {
                if (audio.paused) {
                    audio.play();
                    this.textContent = "🔊";
                } else {
                    audio.pause();
                    this.textContent = "🔇";
                }
            });

            // Cố phát audio khi trang tải
            audio.play().catch(err => {
                console.warn("Trình duyệt có thể chặn autoplay audio:", err);
            });
        });
    </script>
</body>
</html>