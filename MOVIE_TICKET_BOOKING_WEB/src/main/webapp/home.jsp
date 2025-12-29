<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <!-- giữ các link css/js khác y template -->
</head>

<body>
<%-- include header nếu template có dùng dungchung/header --%>
<%-- <jsp:include page="/dungchung/header.jsp" /> --%>

<!-- ... các phần HTML tĩnh giữ nguyên ... -->

<!-- Ví dụ: khu POPULAR MOVIES (thay đoạn JS render bằng SSR) -->
<div class="popular-movies">
    <c:forEach var="m" items="${popularMovies}">
        <div class="movie-card">
            <a href="${pageContext.request.contextPath}/film-detail?id=${m.id}">
                <img src="${m.poster}" alt="${m.title}">
            </a>
            <div class="movie-info">
                <h3>${m.title}</h3>
                <p>${m.genre}</p>
                <span class="age">${m.age}</span>
            </div>
        </div>
    </c:forEach>
</div>

<!-- ... phần còn lại giữ nguyên ... -->

<%-- include footer nếu có --%>
<%-- <jsp:include page="/dungchung/footer.jsp" /> --%>
</body>
</html>
