<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="icon" href="<c:url value='/img/logo/logo.ico'/>" type="image/x-icon">
    <link
            href="https://fonts.googleapis.com/css2?family=Lemon&family=Libre+Baskerville:wght@400;700&family=Montserrat:wght@200;300;400;500;600;700&display=swap"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">


    <link rel="stylesheet" href="<c:url value='/css/film.css'/>">

    <title>Phim</title>
</head>
<body>

<div class="container-header">
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
                    <li><a href="<c:url value='/films'/>">Phim</a>
                    </li>
                    <li><a href="<c:url value ='/uudai'/>">Ưu Đãi</a></li>
                    <li><a href="<c:url value = '/contact'/>">Liên Hệ</a></li>
                    <div class="close-btn" id="close">
                        <i class="fa-solid fa-xmark"></i>
                    </div>
                </ul>
                <ul class="user">
                    <li>
                        <div class="search_user">
<%--                            <input type="text" placeholder="Search..." id="search_input">--%>
<%--                            <div class="search">--%>
<%--                                <!-- <a href="#" class="card1">--%>
<%--                                    <img src="img/the boys.jpg" alt="">--%>
<%--                                    <div class="cont">--%>
<%--                                        <h3 class=titl>The Boys </h3>--%>
<%--                                        <p>Action, 2021 , <span>IMDB</span><i class="fa-solid fa-star"></i> 9.6</p>--%>
<%--                                    </div>--%>
<%--                                </a> -->--%>

<%--                            </div>--%>
                        </div>
                    </li>
                    <li>
                        <a href=""><i class="fa-solid fa-user" id="user_icon"></i></a>
                    </li>
                </ul>
            </div>
        </nav>
    </header>
</div>
<div class="container status-container">
    <ul class="row status-nav">
        <li class="col status-item">
            <a class="nav-link active" href="#" id="now-showing">Phim Đang Chiếu</a>
        </li>
        <li class="col status-item">
            <a class="nav-link" href="#" id="upcoming-movies">Phim Sắp Chiếu</a>
        </li>
    </ul>
</div>

<div class="container">
    <div id="content">

        <!-- ===================== NOW SHOWING ===================== -->
        <div id="now-showing-content" class="movie-list row row-cols-2 row-cols-md-3 row-cols-lg-4 g-4">
            <c:if test="${empty nowShowingMovies}">
                <div class="col-12">
                    <div class="alert alert-warning mb-0">Chưa có phim đang chiếu.</div>
                </div>
            </c:if>

            <c:forEach items="${nowShowingMovies}" var="m">
                <!-- URL detail -->
                <c:url var="detailUrl" value="/film-detail">
                    <c:param name="id" value="${m.id}" />
                </c:url>

                <!-- URL booking (nếu có) -->
                <c:choose>
                    <c:when test="${not empty m.bookingUrl}">
                        <c:url var="bookingUrl" value="/${m.bookingUrl}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="bookingUrl" value="#" />
                    </c:otherwise>
                </c:choose>

                <!-- poster fallback -->
                <c:choose>
                    <c:when test="${not empty m.poster}">
                        <c:url var="posterUrl" value="/${m.poster}" />
                    </c:when>
                    <c:otherwise>
                        <c:url var="posterUrl" value="/img/default-poster.png" />
                    </c:otherwise>
                </c:choose>

                <div class="col mb-4">
                    <div class="card card-movie">
                        <div class="position-relative">
                            <div class="movie-age" data-age="${m.age}">${m.age}</div>
                        </div>

                        <!-- Template FE: <a ... class="card card-movie"> -->
                        <a href="${detailUrl}" class="card card-movie">
                            <img src="${posterUrl}" class="card-img-top movie-list-item-img" alt="${fn:escapeXml(m.title)}">
                            <div class="card-body">
                                <h5 class="card-title">${m.title}</h5>
                                <span class="movie_genre">${m.genre}</span>

                                <div class="row row-cols-2 align-items-center">
                                    <div class="col movie_star">
                                        <span class="movie_info">
                                            <i class="fas fa-star text-warning"></i> ${m.rated}
                                        </span>
                                    </div>
                                    <div class="col">
                                        <c:choose>
                                            <c:when test="${not empty m.bookingUrl}">
                                                <a href="${bookingUrl}" class="btn btn-danger float-end btn-buy">Mua vé</a>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn btn-secondary float-end btn-buy" disabled>Chưa mở bán</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                            </div>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- ===================== UPCOMING ===================== -->
        <div id="upcoming-content" class="movie-list row row-cols-2 row-cols-md-3 row-cols-lg-4 g-4 d-none">
            <c:if test="${empty upcomingMovies}">
                <div class="col-12">
                    <div class="alert alert-warning mb-0">Chưa có phim sắp chiếu.</div>
                </div>
            </c:if>

            <c:forEach items="${upcomingMovies}" var="m">
                <c:url var="detailUrl" value="/film-detail">
                    <c:param name="id" value="${m.id}" />
                </c:url>

                <c:choose>
                    <c:when test="${not empty m.bookingUrl}">
                        <c:url var="bookingUrl" value="/${m.bookingUrl}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="bookingUrl" value="#" />
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${not empty m.poster}">
                        <c:url var="posterUrl" value="/${m.poster}" />
                    </c:when>
                    <c:otherwise>
                        <c:url var="posterUrl" value="/img/default-poster.png" />
                    </c:otherwise>
                </c:choose>

                <div class="col mb-4">
                    <div class="card card-movie">
                        <div class="position-relative">
                            <div class="movie-age" data-age="${m.age}">${m.age}</div>
                        </div>

                        <a href="${detailUrl}" class="card card-movie">
                            <img src="${posterUrl}" class="card-img-top movie-list-item-img" alt="${fn:escapeXml(m.title)}">
                            <div class="card-body">
                                <h5 class="card-title">${m.title}</h5>
                                <span class="movie_genre">${m.genre}</span>

                                <div class="row row-cols-2 align-items-center">
                                    <div class="col movie_star">
                                        <span class="movie_info">
                                            <i class="fas fa-star text-warning"></i>
                                            <c:choose>
                                                <c:when test="${m.rated != 0}">${m.rated}</c:when>
                                                <c:otherwise>--</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="col">
                                        <c:choose>
                                            <c:when test="${not empty m.bookingUrl}">
                                                <a href="${bookingUrl}" class="btn btn-danger float-end btn-buy">Mua vé</a>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn btn-secondary float-end btn-buy" disabled>Chưa mở bán</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                            </div>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>

    </div>
</div>
<footer class="footer">
    <div class="footer-advise">
        <div>
            <ul>
                <li><a href="../html/contact.html#gioithieu">Giới Thiệu</a></li>
                <li><a href="../html/contact.html#lienhe">LIÊN HỆ</a></li>
                <li><a href="../html/contact.html#chinhsach">CHÍNH SÁCH</a></li>
                <li><a href="../html/contact.html#huongdan">HƯỚNG DẪN</a></li>
            </ul>
        </div>
        <div class="advise-text">
            <p>
                <small>Địa chỉ trụ sở: 3 Đ. Cầu Giấy, Ngọc Khánh, Đống Đa, Hà Nội, Việt Nam
                </small>
            </p>
            <p>
                <small>
                    Giấy chứng nhận ĐKKD số: 0106633482 - Đăng ký lần đầu ngày 08/09/2014 tại Sở Kế hoạch và Đầu tư
                    Thành phố Hà Nội
                </small>
            </p>
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
            <a href="https://play.google.com/store/apps/details?id=com.cgv.android.movieapp" target="_blank"><img
                    src="../img/footer/01.jpg" alt=""></a>
            <a href="https://apps.apple.com/vn/app/cgv-cinemas/id1067166194" target="_blank"><img
                    src="../img/footer/02.jpg" alt=""></a>
        </div>
    </div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/js/film.js'/>"></script>
<script src="<c:url value='/dungchung/nav.js'/>"></script>

</body>
</html>
