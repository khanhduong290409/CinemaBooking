<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--<c:if test="${empty sessionScope.currentUser || !(sessionScope.currentUser eq 'admin' || fn:startsWith(sessionScope.currentUser,'admin@'))}">--%>
<%--    <c:redirect url="/home"/>--%>
<%--</c:if>--%>
<c:choose>
    <c:when test="${empty sessionScope.currentUser}">
        <c:redirect url="/login"/>
    </c:when>

    <c:when test="${sessionScope.currentUser.role ne 'ADMIN'}">
        <c:redirect url="/home"/>
    </c:when>
</c:choose>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin</title>

    <link href="https://fonts.googleapis.com/css2?family=Lemon&family=Montserrat:wght@200;300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="icon" href="<c:url value='/img/logo/logo.ico'/>" type="image/x-icon">

    <link rel="stylesheet" href="<c:url value='/dungchung/nav.css'/>">
    <link rel="stylesheet" href="<c:url value='/dungchung/footer.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">

    <style>
        /* tab sections */
        .admin-tab-section{ display:none; }
        .admin-tab-section.active{ display:block; }
    </style>
</head>
<body>

<div class="container">
    <header class="header" id="header">
        <div class="logo"><h1>movie</h1></div>
        <nav class="navBar">
            <div class="open-btn" id="open"><i class="fa-solid fa-bars"></i></div>
            <div class="nav-items">
                <ul class="list">
                    <li><a href="#" class="adminTabLink active" data-tab="dashboard">Dashboard</a></li>
                    <li><a href="#" class="adminTabLink" data-tab="movies">Quản lí phim</a></li>
                    <li><a href="#" class="adminTabLink" data-tab="bookings">Vé đã đặt</a></li>
                    <li><a href="<c:url value='/home'/>">Về trang chủ</a></li>
                    <div class="close-btn" id="close"><i class="fa-solid fa-xmark"></i></div>
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
</div>

<div class="admin-wrap">

    <!-- ================= DASHBOARD ================= -->
    <section id="tab-dashboard" class="admin-tab-section active">
        <div class="admin-title">
            <h2>Admin Dashboard</h2>
            <p>Chuyển tab không reload (ẩn/hiện bằng JS)</p>
        </div>

        <div class="admin-cards">
            <div class="admin-card">
                <div class="admin-card-icon"><i class="fa-solid fa-film"></i></div>
                <div class="admin-card-content">
                    <h3>${movieCount}</h3>
                    <p>Tổng số phim</p>
                </div>
                <a class="admin-card-link" href="#" onclick="return openAdminTab('movies')">Manage</a>
            </div>

            <div class="admin-card">
                <div class="admin-card-icon"><i class="fa-solid fa-ticket"></i></div>
                <div class="admin-card-content">
                    <h3>${bookingCount}</h3>
                    <p>Tổng vé đã đặt</p>
                </div>
                <a class="admin-card-link" href="#" onclick="return openAdminTab('bookings')">View</a>
            </div>
        </div>


    </section>

    <!-- ================= MOVIES ================= -->
    <section id="tab-movies" class="admin-tab-section">
        <div class="admin-title">
            <h2>Quản lý phim</h2>
            <p>Thêm / Sửa / Xóa phim</p>
        </div>

        <div class="admin-section">
            <div class="admin-section-head">
                <h3>
                    <c:choose>
                        <c:when test="${empty editMovie}">Thêm phim mới</c:when>
                        <c:otherwise>Sửa phim #${editMovie.id}</c:otherwise>
                    </c:choose>
                </h3>
                <p class="hint">Poster/Background nhập dạng: ../img/...</p>
            </div>

            <form class="admin-form" method="post" action="<c:url value='/admin'/>">
                <input type="hidden" name="action" value="saveMovie">
                <input type="hidden" name="id" value="${editMovie.id}">

                <!-- code + status -->
                <div class="admin-field">
                    <label>Code</label>
                    <input name="code" value="${editMovie.code}" placeholder="VD: JACK, ROBOT, NXCMCT..." required>
                </div>

                <div class="admin-field">
                    <label>Status</label>
                    <select name="status" required>
                        <option value="NOW_SHOWING" ${editMovie.status eq 'NOW_SHOWING' ? 'selected' : ''}>NOW_SHOWING</option>
                        <option value="UPCOMING" ${editMovie.status eq 'UPCOMING' ? 'selected' : ''}>UPCOMING</option>
                    </select>
                </div>

                <div class="admin-field span-1">
                    <label>Age</label>
                    <input name="age" value="${editMovie.age}" placeholder="VD: PG-13">
                </div>

                <!-- title -->
                <div class="admin-field span-3">
                    <label>Title</label>
                    <input name="title" value="${editMovie.title}" placeholder="Tên phim" required>
                </div>

                <!-- rated + released + runtime -->
                <div class="admin-field">
                    <label>Rated</label>
                    <input name="rated" value="${editMovie.rated}" placeholder="VD: 8.5">
                </div>

                <div class="admin-field">
                    <label>Released</label>
                    <input type="date" name="released" value="${editMovie.released}">
                </div>

                <div class="admin-field">
                    <label>Runtime</label>
                    <input name="runtime" value="${editMovie.runtime}" placeholder="VD: 111 phút">
                </div>

                <!-- genre + director -->
                <div class="admin-field span-2">
                    <label>Genre</label>
                    <input name="genre" value="${editMovie.genre}" placeholder="VD: Hành động, Kinh dị...">
                </div>

                <div class="admin-field">
                    <label>Director</label>
                    <input name="director" value="${editMovie.director}">
                </div>

                <!-- actors -->
                <div class="admin-field span-3">
                    <label>Actors</label>
                    <input name="actors" value="${editMovie.actors}">
                </div>

                <!-- language + country -->
                <div class="admin-field">
                    <label>Language</label>
                    <input name="language" value="${editMovie.language}" placeholder="VD: Vietnamese">
                </div>

                <div class="admin-field">
                    <label>Country</label>
                    <input name="country" value="${editMovie.country}" placeholder="VD: Vietnam">
                </div>

                <div class="admin-field">
                    <label>Video URL (iframe src)</label>
                    <input name="videoUrl" value="${editMovie.videoUrl}" placeholder="https://www.youtube.com/embed/...">
                </div>

                <!-- poster + images -->
                <div class="admin-field span-3">
                    <label>Poster (VD: ../img/poster/xxx.jpg)</label>
                    <input name="poster" value="${editMovie.poster}" placeholder="../img/poster/abc.jpg">
                </div>

                <div class="admin-field span-3">
                    <label>Background / Images (VD: ../img/bg/xxx.jpg)</label>
                    <input name="images" value="${editMovie.images}" placeholder="../img/bg/abc.jpg">
                </div>

                <!-- plot + description -->
                <div class="admin-field span-3">
                    <label>Plot</label>
                    <textarea name="plot" placeholder="Nội dung tóm tắt...">${editMovie.plot}</textarea>
                </div>

                <div class="admin-field span-3">
                    <label>Description</label>
                    <textarea name="description" placeholder="Mô tả chi tiết...">${editMovie.description}</textarea>
                </div>

                <!-- actions -->
                <div class="admin-actions span-3">
                    <button class="btn btn-primary" type="submit">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </button>

                    <a class="btn btn-ghost" href="<c:url value='/admin'/>"
                       onclick="localStorage.setItem('adminActiveTab','movies')">
                        <i class="fa-solid fa-rotate-left"></i> Reset
                    </a>
                </div>
            </form>

        </div>

        <div class="admin-section">
            <div class="admin-section-head">
                <h3>Danh sách phim</h3>
                <p class="hint">${fn:length(movies)} phim</p>
            </div>

            <div class="table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Poster</th>
                        <th>Code</th>
                        <th>Title</th>
                        <th>Status</th>
                        <th>Rated</th>
                        <th>Released</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${movies}" var="m">
                        <tr>
                            <td>${m.id}</td>
                            <td>
                                <c:if test="${not empty m.poster}">
                                    <img class="poster-mini" src="<c:url value='${fn:replace(m.poster,"../","/")}'/>" alt="">
                                </c:if>
                            </td>
                            <td><span class="badge">${m.code}</span></td>
                            <td>${m.title}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${m.status eq 'NOW_SHOWING'}">
                                        <span class="badge badge-green">NOW_SHOWING</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-red">UPCOMING</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${m.rated}</td>
                            <td>${m.released}</td>
                            <td class="cell-actions">
                                <a class="btn btn-ghost"
                                   href="<c:url value='/admin?action=editMovie&id=${m.id}'/>"
                                   onclick="localStorage.setItem('adminActiveTab','movies')">
                                    <i class="fa-solid fa-pen"></i> Edit
                                </a>
                                <a class="btn btn-danger"
                                   onclick="localStorage.setItem('adminActiveTab','movies'); return confirm('Xóa phim này?');"
                                   href="<c:url value='/admin?action=deleteMovie&id=${m.id}'/>">
                                    <i class="fa-solid fa-trash"></i> Delete
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- ================= BOOKINGS ================= -->
    <section id="tab-bookings" class="admin-tab-section">
        <div class="admin-title">
            <h2>Danh sách vé đã đặt</h2>
            <p>Booking + Showtime + Seats</p>
        </div>

        <div class="admin-section">
            <div class="admin-section-head">
                <h3>Bookings</h3>
                <p class="hint">${fn:length(bookings)} bookings</p>
            </div>

            <div class="table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>User ID</th>
                        <th>Movie</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Format</th>
                        <th>Seats</th>
                        <th>Total</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${bookings}" var="b">
                        <c:set var="st" value="${showtimeMap[b.showtimeId]}"/>
                        <c:set var="mv" value="${st != null ? movieMapById[st.movieId] : null}"/>

                        <tr>
                            <td><span class="badge">${b.id}</span></td>
                            <td>${b.userId}</td>
                            <td>${mv != null ? mv.title : '-'}</td>
                            <td>${st != null ? st.showDate : '-'}</td>
                            <td>${st != null ? st.showTime : '-'}</td>
                            <td>${st != null ? st.format : '-'}</td>
                            <td>${seatTextMap[b.id]}</td>
                            <td><fmt:formatNumber value="${b.totalPrice}" type="number"/>đ</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

</div>

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
            <a href="#"><i class="fa-brands fa-instagram"></i></a>
            <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
            <a href="#"><i class="fa-brands fa-threads"></i></a>
        </div>
    </div>

    <div class="moblie-app">
        <h4>Movie App</h4>
        <div class="link-title">
            <a href="#"><img src="<c:url value='/img/footer/01.jpg'/>" alt=""></a>
            <a href="#"><img src="<c:url value='/img/footer/02.jpg'/>" alt=""></a>
        </div>
    </div>
</footer>

<script src="<c:url value='/dungchung/nav.js'/>"></script>

<script>
    function openAdminTab(tab){
        // hide all
        document.querySelectorAll('.admin-tab-section').forEach(s => s.classList.remove('active'));
        document.querySelectorAll('.adminTabLink').forEach(a => a.classList.remove('active'));

        // show selected
        const sec = document.getElementById('tab-' + tab);
        if (sec) sec.classList.add('active');

        const link = document.querySelector('.adminTabLink[data-tab="' + tab + '"]');
        if (link) link.classList.add('active');

        localStorage.setItem('adminActiveTab', tab);
        return false;
    }

    // click nav
    document.querySelectorAll('.adminTabLink').forEach(a => {
        a.addEventListener('click', function(e){
            e.preventDefault();
            openAdminTab(this.dataset.tab);
        });
    });

    // restore tab
    (function(){
        const fromServer = "${activeTab}";
        const saved = localStorage.getItem('adminActiveTab');
        const tab = fromServer && fromServer !== "" ? fromServer : (saved || "dashboard");
        openAdminTab(tab);
    })();
</script>

</body>
</html>
