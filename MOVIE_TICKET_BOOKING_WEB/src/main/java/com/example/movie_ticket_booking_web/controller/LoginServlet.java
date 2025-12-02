package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // tên input trong form JSP: name="User" và name="pass"
        String userOrEmail = request.getParameter("User");
        String password = request.getParameter("pass");

        boolean ok = userDAO.checkLogin(userOrEmail, password);

        if (ok) {
            // tạo session
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", userOrEmail);

            // chuyển đến home (ví dụ home.jsp)
            response.sendRedirect(request.getContextPath() + "/home.jsp");
        } else {
            // báo lỗi lại cho login.jsp
            request.setAttribute("loginError", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // nếu ai đó truy cập GET /login → chuyển về login.jsp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
