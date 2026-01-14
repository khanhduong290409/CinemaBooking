<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ưu đãi</title>

    <!-- BÁM TEMPLATE FE -->
    <link rel="stylesheet" href="<c:url value='/css/uudai.css'/>">
    <link rel="icon" href="<c:url value='/img/logo/logo.ico'/>" type="image/x-icon">
    <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css'>

    <link href="https://fonts.googleapis.com/css2?family=Lemon&family=Libre+Baskerville:wght@400;700&family=Montserrat:wght@200;300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <link rel="stylesheet" href="<c:url value='/dungchung/footer.css'/>">
    <link rel="stylesheet" href="<c:url value='/dungchung/nav.css'/>">
</head>

<body>
<%@ include file="/dungchung/nav.jsp" %>


<div class="main">
    <h1>KHUYẾN MÃI</h1>

    <main>
        <article>
            <img src="<c:url value='/img/uudai/labubu.png'/>" alt="rome"/>
            <a href="#" id="openModal1">Cơ hội sở hữu LABUBU FLIP WITH ME 40cm tại ONE</a>
            <p>
                SỞ HỮU LABUBU FLIP WITH ME TẠI ONE
                Trời ơi LABUBU đến với ONE rồi đây!!
                Để có thể sở hữu bé LABUBU siu hot này bạn chỉ cần
                mua 1 combo bất kì thôi đóoo :33
                Đến ONE mua combo để có cơ hội sở hữu LABUBU miễn phí ngay nhéee[...]
            </p>
        </article>

        <div id="modal1" class="modal">
            <div class="modal-content">
                <span class="close" id="closeModal1">&times;</span>
                <div class="modal-body">
                    <div class="modal-image">
                        <img src="<c:url value='/img/uudai/labubu.png'/>" alt="labubu" />
                        <div class="logo-container">
                            <img src="<c:url value='/img/uudai/facebook.png'/>" class="logo" alt="Facebook" />
                            <img src="<c:url value='/img/uudai/twitter.png'/>" class="logo" alt="Twitter" />
                            <img src="<c:url value='/img/uudai/instagram.png'/>" class="logo" alt="Instagram" />
                            <img src="<c:url value='/img/uudai/linkedin.png'/>" class="logo" alt="LinkedIn" />
                        </div>
                    </div>
                    <div class="modal-text">
                        <h2 style="color: #e50914;">Cơ hội sở hữu LABUBU FLIP WITH ME 40cm tại ONE !</h2>
                        <br>
                        <p style="color: gray;">05/10/2024</p>
                        <br>
                        <p>😍SỞ HỮU LABUBU FLIP WITH ME TẠI ONE 😍</p>
                        <p>
                            Trời ơi 😍 LABUBU đến với ONE rồi đây!!
                            Để có thể sở hữu bé LABUBU siu hot này 🔥 bạn chỉ cần mua 1 combo bất kì thôi đóoo :33
                            Đến ONE mua combo để có cơ hội sở hữu LABUBU miễn phí ngay nhéee
                            Hiện chương trình đang áp dụng tại các cụm rạp ONE toàn hệ thống ( trừ rạp Long Khánh & Phú Mỹ )
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <article>
            <img src="<c:url value='/img/uudai/bong1.jpg'/>" alt=""/>
            <a href="#" id="openModal2">Tháng 10 - Deal siêu hời khi mua qua Web/App ONE</a>
            <p>
                COMBO YÊU THƯƠNG NHÂN ĐÔI ĐIỂM THƯỞNG Khi đặt
                2 Combo bắp nước trên Web/App ONE,
                bạn sẽ được nhân đôi điểm thành viên nè!!!
                OL Single Combo 1: 1 bắp + 1 nước = 89k
                OL Couple Combo 2: 1 bắp + 2 nước = 119k
                Ngoài ra bạn còn được áp dụng […]
            </p>
        </article>

        <div id="modal2" class="modal">
            <div class="modal-content">
                <span class="close" id="closeModal2">&times;</span>
                <div class="modal-body">
                    <div class="modal-image">
                        <img src="<c:url value='/img/uudai/bong1.jpg'/>" alt="bong1" />
                        <div class="logo-container">
                            <img src="<c:url value='/img/uudai/facebook.png'/>" class="logo" alt="Facebook" />
                            <img src="<c:url value='/img/uudai/twitter.png'/>" class="logo" alt="Twitter" />
                            <img src="<c:url value='/img/uudai/instagram.png'/>" class="logo" alt="Instagram" />
                            <img src="<c:url value='/img/uudai/linkedin.png'/>" class="logo" alt="LinkedIn" />
                        </div>
                    </div>
                    <div class="modal-text">
                        <h2 style="color: #e50914;">Tháng 10 - Deal siêu hời khi mua qua Web/App ONE</h2>
                        <br>
                        <p style="color: gray;">05/10/2024</p>
                        <br>
                        <p>😍COMBO YÊU THƯƠNG NHÂN ĐÔI ĐIỂM THƯỞNG 😍</p>
                        <p>
                            Khi đặt 2 Combo bắp nước trên Web/App BHD Star, bạn sẽ được nhân đôi điểm thành viên nè!!! ❤
                            🔥 OL Single Combo 1: 1 bắp + 1 nước = 89k
                            🔥 OL Couple Combo 2: 1 bắp + 2 nước = 119k
                            Ngoài ra bạn còn được áp dụng giảm giá thành viên nữa đó 🤩
                            Chương trình áp dụng từ 01.10.2024 - 31.10.2024
                            Nhanh tay đặt combo ưu đãi và tích điểm thưởng ngay hôm nay! 🎉
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <article>
            <img src="<c:url value='/img/uudai/bong2.jpg'/>" alt=""/>
            <a href="#" id="openModal3">Tháng quà tặng - Ưu đãi từ ONE</a>
            <p>
                3 THÁNG LIÊN TỤC TẶNG 1 BẮP +
                1 NƯỚC KHI XEM PHIM Ai ai cũng có thể tham gia,
                thời gian tặng thì thoải mái bạt ngàn để các bạn chờ
                cho dịp xem những bộ phim mình yêu thích nè Tặng 1 bắp +
                1 nước tại quầy (sử dụng cho lần sau) […]
            </p>
        </article>

        <div id="modal3" class="modal">
            <div class="modal-content">
                <span class="close" id="closeModal3">&times;</span>
                <div class="modal-body">
                    <div class="modal-image">
                        <img src="<c:url value='/img/uudai/bong2.jpg'/>" alt="bong2" />
                        <div class="logo-container">
                            <img src="<c:url value='/img/uudai/facebook.png'/>" class="logo" alt="Facebook" />
                            <img src="<c:url value='/img/uudai/twitter.png'/>" class="logo" alt="Twitter" />
                            <img src="<c:url value='/img/uudai/instagram.png'/>" class="logo" alt="Instagram" />
                            <img src="<c:url value='/img/uudai/linkedin.png'/>" class="logo" alt="LinkedIn" />
                        </div>
                    </div>
                    <div class="modal-text">
                        <h2 style="color: #e50914;">Tháng quà tặng - Ưu đãi từ ONE</h2>
                        <br>
                        <p style="color: gray;">05/10/2024</p>
                        <br>
                        <p>3 THÁNG LIÊN TỤC TẶNG 1 BẮP + 1 NƯỚC KHI XEM PHIM 🥳</p>
                        <p>
                            Ai ai cũng có thể tham gia, thời gian tặng thì thoải mái bạt ngàn để các bạn chờ cho dịp xem những bộ phim mình yêu thích nè !
                            🍿 Tặng 1 bắp + 1 nước tại quầy (sử dụng cho lần sau) khi mua 2 combo bất kì trong 1 giao dịch Trực tiếp hoặc Online.
                            ⛳️ Áp dụng tại rạp ONE Hà Nội: Vincom Phạm Ngọc Thạch, Discovery Cầu Giấy, The Garden Mỹ Đình.
                            Càng đông, càng thêm vui! Xem phim tại ONE chỉ từ 45k/vé!
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<%@ include file="/dungchung/footer.jsp" %>


<script src="<c:url value='/dungchung/nav.js'/>"></script>
<script src="<c:url value='/js/uudai.js'/>"></script>
</body>
</html>
