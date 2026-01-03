<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://fonts.googleapis.com/css2?family=Lemon&family=Libre+Baskerville:wght@400;700&family=Montserrat:wght@200;300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />

    <link rel="icon" href="<c:url value='/img/logo/logo.ico'/>" type="image/x-icon">
    <link rel="stylesheet" href="<c:url value='/css/home.css'/>">

    <title>Movie Cinema</title>
</head>

<body>
<div class="container">
    <header class="header" id="header">
        <div class="logo">
            <h1>movie</h1>
        </div>

        <nav class="navBar">
            <div class="open-btn" id="open">
                <i class="fa-solid fa-bars"></i>
            </div>

            <div class="nav-items">
                <ul class="list">
                    <li><a href="<c:url value='/home'/>">Trang Chủ</a></li>
                    <li><a href="<c:url value='/films'/>">Phim</a></li>
                    <li><a href="#">Ưu Đãi</a></li>
                    <li><a href="#">Liên Hệ</a></li>

                    <div class="close-btn" id="close">
                        <i class="fa-solid fa-xmark"></i>
                    </div>
                </ul>

                <ul class="user">
                    <li>
                        <div class="search_user">
                            <input type="text" placeholder="Search..." id="search_input">
                            <!-- FIX: ẩn dropdown search ngay từ JSP để không hiện "khối vuông đen" -->
                            <div class="search" style="display:none;"></div>
                        </div>
                    </li>
                    <li>
                        <a href="">
                            <i class="fa-solid fa-user" id="user_icon"></i>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
    </header>
</div>

<div class="swiper mySwiper">
    <div class="swiper-wrapper">

        <c:forEach items="${heroMovies}" var="m">
            <c:choose>
                <c:when test="${not empty m.images}">
                    <c:set var="bgRel" value="${fn:replace(fn:trim(m.images), '../', '')}" />
                    <c:set var="bgSrc" value="${pageContext.request.contextPath}/${bgRel}" />
                </c:when>
                <c:otherwise>
                    <c:set var="bgSrc" value="" />
                </c:otherwise>
            </c:choose>

            <c:url var="detailUrl" value="/film-detail">
                <c:param name="id" value="${m.id}"/>
            </c:url>

            <div class="swiper-slide"
                    <c:if test="${not empty bgSrc}">
                        style="background-image:url('${bgSrc}'); background-size:cover; background-position:center;"
                    </c:if>
            >
                <div class="swiper-container">

                    <div class="type">
                        <c:choose>
                            <c:when test="${not empty m.genre}">
                                <c:forEach items="${fn:split(m.genre, ',')}" var="g" varStatus="st">
                                    <c:if test="${st.index < 3}">
                                        <p>${fn:trim(g)}</p>
                                        <c:if test="${st.index < 2}">
                                            <div class="line"></div>
                                        </c:if>
                                    </c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p>Movie</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="movie-title">
                        <h2>${fn:escapeXml(m.title)}</h2>

                        <c:choose>
                            <c:when test="${not empty m.plot && fn:length(m.plot) > 260}">
                                <p>${fn:escapeXml(fn:substring(m.plot,0,260))}...</p>
                            </c:when>
                            <c:when test="${not empty m.plot}">
                                <p>${fn:escapeXml(m.plot)}</p>
                            </c:when>
                            <c:otherwise>
                                <p>${fn:escapeXml(m.description)}</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="movie-rating">
                        <div>
                            <p>IMDb: <fmt:formatNumber value="${m.rated}" minFractionDigits="1" maxFractionDigits="1"/></p>
                        </div>
                        <div>
                            <p><c:out value="${m.runtime}"/></p>
                        </div>
                        <div class="rect">
                            <p><c:out value="${m.age}"/></p>
                        </div>
                    </div>

                    <div class="movie-btn">
                        <button class="btn-1" type="button" onclick="window.location.href='${detailUrl}'">Watch Now</button>
                        <button class="btn-2" type="button">Add List</button>
                    </div>

                </div>
            </div>
        </c:forEach>

        <c:if test="${empty heroMovies}">
            <div class="swiper-slide">
                <div class="swiper-container">
                    <div class="type">
                        <p>Movie</p>
                    </div>
                    <div class="movie-title">
                        <h2>Chưa có dữ liệu phim</h2>
                        <p>Hãy insert phim vào database (movies) và reload trang.</p>
                    </div>
                    <div class="movie-rating">
                        <div><p>IMDb: --</p></div>
                        <div><p>--</p></div>
                        <div class="rect"><p>--</p></div>
                    </div>
                    <div class="movie-btn">
                        <button class="btn-1" type="button">Watch Now</button>
                        <button class="btn-2" type="button">Add List</button>
                    </div>
                </div>
            </div>
        </c:if>

    </div>

    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
</div>

<div class="slider-container">
    <div class="slider-content">
        <h1>Movie Selection</h1>
    </div>

    <div class="owl-container">
        <div class="owl-carousel owl-theme" id="movieCarousel">
            <c:forEach items="${carouselMovies}" var="m">
                <c:url var="detailUrl" value="/film-detail">
                    <c:param name="id" value="${m.id}"/>
                </c:url>

                <c:choose>
                    <c:when test="${not empty m.poster}">
                        <c:set var="posterRel" value="${fn:replace(fn:trim(m.poster), '../', '')}" />
                        <c:set var="posterSrc" value="${pageContext.request.contextPath}/${posterRel}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="posterSrc" value="${pageContext.request.contextPath}/img/default-poster.jpg" />
                    </c:otherwise>
                </c:choose>

                <div class="cards">
                    <div class="card-img">
                        <a href="${detailUrl}">
                            <img src="${posterSrc}" alt="${fn:escapeXml(m.title)}"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/default-poster.jpg';">
                        </a>
                        <div class="img-title">
                            <h4><fmt:formatNumber value="${m.rated}" minFractionDigits="1" maxFractionDigits="1"/></h4>
                            <p>IMDb</p>
                        </div>
                    </div>

                    <div class="card-title">
                        <a href="${detailUrl}">
                            <h3>${fn:escapeXml(m.title)}</h3>
                        </a>
                        <p><c:out value="${m.genre}"/></p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<div class="slider-event">
    <div class="slider-content">
        <h1>Event</h1>
    </div>

    <div class="owl-container">
        <div class="owl-carousel owl-theme">
            <div class="cards"><div class="card-img"><a href="#"><img src="<c:url value='/img/event/1.png'/>" alt=""></a></div></div>
            <div class="cards"><div class="card-img"><a href="#"><img src="<c:url value='/img/event/2.png'/>" alt=""></a></div></div>
            <div class="cards"><div class="card-img"><a href="#"><img src="<c:url value='/img/event/3.jpg'/>" alt=""></a></div></div>
            <div class="cards"><div class="card-img"><a href="#"><img src="<c:url value='/img/event/4.png'/>" alt=""></a></div></div>
            <div class="cards"><div class="card-img"><a href="#"><img src="<c:url value='/img/event/5.jpg'/>" alt=""></a></div></div>
        </div>
    </div>
</div>

<!-- ================== FOOTER ================== -->
<footer class="footer">
    <div class="footer-advise">
        <div>
            <ul>
                <li><a href="#">Giới Thiệu</a></li>
                <li><a href="#">LIÊN HỆ</a></li>
                <li><a href="#">CHÍNH SÁCH</a></li>
                <li><a href="#">HƯỚNG DẪN</a></li>
            </ul>
        </div>
        <div class="advise-text">
            <p><small>Địa chỉ trụ sở: 3 Đ. Cầu Giấy, Ngọc Khánh, Đống Đa, Hà Nội, Việt Nam</small></p>
            <p><small>Giấy chứng nhận ĐKKD số: 0106633482 - Đăng ký lần đầu ngày 08/09/2014 tại Sở KH&ĐT Hà Nội</small></p>
        </div>
    </div>

    <div>
        <h4>Follow Us</h4>
        <div class="footer-social">
            <a href="https://www.instagram.com/sqw_uli"><i class="fa-brands fa-instagram"></i></a>
            <a href="https://www.facebook.com/Siluq.16"><i class="fa-brands fa-facebook-f"></i></a>
            <a href="https://www.threads.net/@sqw_uli"><i class="fa-brands fa-threads"></i></a>
        </div>
    </div>

    <div class="moblie-app">
        <h4>Movie App</h4>
        <div class="link-title">
            <a href="https://play.google.com/store/apps/details?id=com.cgv.android.movieapp" target="_blank">
                <img src="<c:url value='/img/footer/01.jpg'/>" alt="">
            </a>
            <a href="https://apps.apple.com/vn/app/cgv-cinemas/id1067166194" target="_blank">
                <img src="<c:url value='/img/footer/02.jpg'/>" alt="">
            </a>
        </div>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>

<script src="<c:url value='/dungchung/nav.js'/>"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const searchBox = document.querySelector('.search_user .search');
        if (searchBox) searchBox.style.display = 'none';

        // Swiper
        new Swiper(".mySwiper", {
            slidesPerView: 1,
            spaceBetween: 30,
            loop: true,
            navigation: {
                nextEl: ".swiper-button-next",
                prevEl: ".swiper-button-prev",
            },
        });

        // Owl movie carousel
        $('#movieCarousel').owlCarousel({
            loop: true,
            margin: 0,
            nav: true,
            responsive: {
                0: { items: 1 },
                500: { items: 2 },
                700: { items: 3 },
                800: { items: 3 },
                1000: { items: 4 },
                1200: { items: 5 },
                1300: { items: 6 }
            }
        });

        // Owl event carousel
        $('.slider-event .owl-carousel').owlCarousel({
            loop: true,
            margin: 0,
            nav: true,
            responsive: {
                0: { items: 1 },
                600: { items: 2 },
                800: { items: 2 },
                1000: { items: 3 },
                1200: { items: 4 }
            }
        });
    });
</script>

</body>
</html>
