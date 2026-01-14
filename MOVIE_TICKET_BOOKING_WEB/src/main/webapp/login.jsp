<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/login.css">
    <link rel="icon" href="img/logo/logo.ico" type="image/x-icon">
    <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css'>
    <link
            href="https://fonts.googleapis.com/css2?family=Lemon&family=Libre+Baskerville:wght@400;700&family=Montserrat:wght@200;300;400;500;600;700&display=swap"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="dungchung/nav.css">
    <link rel="stylesheet" href="dungchung/footer.css">
    <title>Login</title></head>
<body>
<%@ include file="/dungchung/nav.jsp" %>


<div class="main">
    <div class="form">
        <div class="design">
            <div class="round_point"></div>
            <div class="btns">
                <a href="javascript:void(0)" id="login" class="active" onclick="switchForm('login')">Login</a>
                <a href="javascript:void(0)" id="signup" onclick="switchForm('signup')">Sign Up</a>
            </div>
        </div>
        <div class="box active" id="loginBox">
            <div class="login">
                <form action="login" method = "post" name="log">
                    <h3>Login</h3>
                    <div class="login_field">
                        <i class="bi bi-envelope-fill"></i>
                        <input type="text" name="User" class="login_input" placeholder="User name / Email">
                    </div>
                    <div class="login_field">
                        <i class="bi bi-shield-lock-fill"></i>
                        <input type="password" name="pass" class="login_input" placeholder="Password">
                    </div>
                    <!-- Hiển thị lỗi login nếu có -->
                    <%
                        String loginError = (String) request.getAttribute("loginError");
                        String signupSuccess = (String) request.getAttribute("signupSuccess");
                        if (loginError != null) {
                    %>
                    <p style="color: red;"><%= loginError %></p>
                    <%
                        }
                        if (signupSuccess != null) {
                    %>
                    <p style="color: green;"><%= signupSuccess %></p>
                    <%
                        }
                    %>
                    <input class="button" type="submit" value="Log In Now">
                    <!-- <button>Log In Now</button> -->
                </form>
            </div>
        </div>
        <div class="box" id="signupBox">
            <div class="signup">
                <form action="register" method = "post" name="Sign">
                    <h3>Sign Up</h3>

                    <div class="login_field">
                        <i class="bi bi-person-fill"></i>
                        <input type="text" name="username" class="login_input" placeholder="User name">
                    </div>

                    <div class="login_field">
                        <i class="bi bi-envelope-fill"></i>
                        <input type="email" name="email" class="login_input" placeholder="Email">
                    </div>

                    <div class="login_field">
                        <i class="bi bi-shield-lock-fill"></i>
                        <input type="password" name="pass" class="login_input" placeholder="Password">
                    </div>
                    <div class="login_field">
                        <i class="bi bi-shield-lock-fill"></i>
                        <input type="password" name="repass" class="login_input" placeholder="RePassword">
                    </div>
                    <!-- Hiển thị lỗi sign up nếu có -->
                    <%
                        String signupError = (String) request.getAttribute("signupError");
                        if (signupError != null) {
                    %>
                    <p style="color: red;"><%= signupError %></p>
                    <%
                        }
                    %>
                    <input class="button" type="submit" value="Sign Up Now">
                    <!-- <button>Sign In Now</button> -->
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/dungchung/footer.jsp" %>


<script src="dungchung/nav.js"></script>
<script src="js/login.js"></script>

<% if (signupError != null) { %>
<script>
    // Khi có lỗi đăng ký → tự chuyển sang tab Sign Up
    window.addEventListener('load', function () {
        if (typeof switchForm === 'function') {
            switchForm('signup');
        }
    });
</script>
<% } %>
</body>
</html>
