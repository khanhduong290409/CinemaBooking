<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
                    <li><a href="<c:url value='/films'/>">Phim</a></li>
                    <li><a href="<c:url value='/uudai'/>">Ưu Đãi</a></li>
                    <li><a href="<c:url value='/contact'/>">Liên Hệ</a></li>

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
</div>
