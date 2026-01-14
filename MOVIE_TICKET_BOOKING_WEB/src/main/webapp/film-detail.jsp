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
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css">
    <link rel="stylesheet" href="<c:url value='/css/film-detail.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Lemon&family=Libre+Baskerville:wght@400;700&family=Montserrat:wght@200;300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="icon" href="<c:url value='/img/logo/logo.ico'/>" type="image/x-icon">

    <title>Chi Tiết Phim</title>
</head>
<body>

<c:set var="m" value="${movie}" />

<!-- ====== Normalize paths (GIỮ NGUYÊN DB ../img/... nhưng hiển thị đúng) ====== -->
<c:choose>
    <c:when test="${not empty m.poster}">
        <c:set var="posterRel" value="${fn:replace(m.poster, '../', '')}" />
        <c:set var="posterSrc" value="${pageContext.request.contextPath}/${posterRel}" />
    </c:when>
    <c:otherwise>
        <c:set var="posterSrc" value="${pageContext.request.contextPath}/img/default-poster.jpg" />
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${not empty m.images}">
        <c:set var="bgRel" value="${fn:replace(m.images, '../', '')}" />
        <c:set var="bgSrc" value="${pageContext.request.contextPath}/${bgRel}" />
    </c:when>
    <c:otherwise>
        <c:set var="bgSrc" value="" />
    </c:otherwise>
</c:choose>

<c:set var="bookingHref"
       value="${pageContext.request.contextPath}/book?movie=${m.code}" />


<!-- ====== HEADER + FEATURE (template giữ nguyên) ====== -->
<div class="container_header">
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
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <li>
                                <a href="<c:url value='/logout'/>" title="Đăng xuất">
                                    <i class="fa-solid fa-right-from-bracket" id="user_icon"></i>
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li>
                                <a href="<c:url value='/login'/>" title="Đăng nhập">
                                    <i class="fa-solid fa-user" id="user_icon"></i>
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </nav>
    </header>

    <div class="nmtitle-wrapper with-fixed-header">
        <div class="feature">
            <div class="feature__bg">

                <!-- Video (template) - nếu không có video thì bạn vẫn có thể để trống -->
                <div class="feature__bg--video video-onl">
                    <iframe class="object-fit-sm-cover"
                            id="movieVideo2"
                            width="100%" height="100%"
                            src="${m.videoUrl}"
                            allow="autoplay"
                    ></iframe>
                </div>

            </div>

            <div class="container">
                <div class="row align-items-center feature-content">
                    <div class="col-lg-7 col-md-12">
                        <div class="movie-info">
                            <span class="movie-age" id="movieAge" data-age="${m.age}">${m.age}</span>
                            <h1 class="movie-title" id="movieTitle">${fn:escapeXml(m.title)}</h1>

                            <!-- Meta: Released | Runtime | Country | Genre -->
                            <p class="movie-meta" id="movieMeta">
                                <c:set var="hasMeta" value="false" />

                                <c:if test="${not empty m.released}">
                                    <span class="movie-meta-item">
                                        <fmt:formatDate value="${m.released}" pattern="dd/MM/yyyy"/>
                                    </span>
                                    <c:set var="hasMeta" value="true" />
                                </c:if>

                                <c:if test="${not empty m.runtime}">
                                    <c:if test="${hasMeta}">
                                        <span class="movie-meta-separator">|</span>
                                    </c:if>
                                    <span class="movie-meta-item">${fn:escapeXml(m.runtime)}</span>
                                    <c:set var="hasMeta" value="true" />
                                </c:if>

                                <c:if test="${not empty m.country}">
                                    <c:if test="${hasMeta}">
                                        <span class="movie-meta-separator">|</span>
                                    </c:if>
                                    <span class="movie-meta-item">${fn:escapeXml(m.country)}</span>
                                    <c:set var="hasMeta" value="true" />
                                </c:if>

                                <c:if test="${not empty m.genre}">
                                    <c:if test="${hasMeta}">
                                        <span class="movie-meta-separator">|</span>
                                    </c:if>
                                    <span class="movie-meta-item">${fn:escapeXml(m.genre)}</span>
                                </c:if>
                            </p>

                            <p class="movie-desc" id="movieDecs">${fn:escapeXml(m.description)}</p>
                        </div>

                        <div class="row align-items-center">
                            <div class="col-12 col-sm-3 col-lg-3 col-xxl-2">
                                <a href="${bookingHref}"
                                   class="btn btn-danger buy-btn"
                                   id="Booking">
                                    Mua vé
                                </a>

                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- ====== CONTENT / INFO ====== -->
<c:set var="plotFull" value="${m.plot}" />
<c:choose>
    <c:when test="${not empty plotFull and fn:length(plotFull) > 130}">
        <c:set var="plotShort" value="${fn:substring(plotFull,0,130)}..." />
        <c:set var="canTogglePlot" value="true" />
    </c:when>
    <c:otherwise>
        <c:set var="plotShort" value="${plotFull}" />
        <c:set var="canTogglePlot" value="false" />
    </c:otherwise>
</c:choose>

<div class="row d-flex justify-content-center">
    <div class="col-11 col-sm-5 col-lg-4">
        <div class="info-wrap">
            <h5 class="movie-content">Nội dung</h5>
            <p class="movie-plot-short" id="moviePlotShort">${fn:escapeXml(plotShort)}</p>
            <p class="movie-plot-full" id="moviePlotFull" style="display:none;">${fn:escapeXml(plotFull)}</p>

            <c:if test="${canTogglePlot}">
                <span class="toggle-text" id="toggleText">Xem thêm</span>
            </c:if>
        </div>
    </div>

    <div class="col-11 col-sm-6">
        <div class="info-wrap">
            <div class="row">
                <div class="col-12">
                    <h5 class="movie-content">Thông tin</h5>
                </div>
                <div class="col-12 col-lg-4">
                    <div class="info-item">
                        <h5>Đạo diễn</h5>
                        <p id="director">${fn:escapeXml(m.director)}</p>
                    </div>
                </div>
                <div class="col-12 col-lg-4">
                    <div class="info-item">
                        <h5>Diễn viên</h5>
                        <p id="actors">${fn:escapeXml(m.actors)}</p>
                    </div>
                </div>
                <div class="col-12 col-lg-4">
                    <div class="info-item item-last">
                        <h5>Ngôn ngữ</h5>
                        <p id="language">${fn:escapeXml(m.language)}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ====== FOOTER giữ nguyên template (bạn có thể copy y nguyên) ====== -->
<%@ include file="/dungchung/footer.jsp" %>


<script src="<c:url value='/js/film-detail.js'/>"></script>
<script src="<c:url value='/dungchung/nav.js'/>"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>