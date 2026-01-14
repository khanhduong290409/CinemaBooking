package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.dao.UserDAO;
import com.example.movie_ticket_booking_web.model.User;
import com.example.movie_ticket_booking_web.util.PasswordHashUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("pass");
        String repass = request.getParameter("repass");

        if (username == null || email == null || password == null || repass == null
                || username.trim().isEmpty() || email.trim().isEmpty()
                || password.isEmpty() || repass.isEmpty()) {

            request.setAttribute("signupError", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (!password.equals(repass)) {
            request.setAttribute("signupError", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setRole("USER");
        user.setPassword(PasswordHashUtil.hash(password)); // HASH

        boolean ok = userDAO.insert(user);

        if (!ok) {
            request.setAttribute("signupError", "Tài khoản hoặc email đã tồn tại!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        request.setAttribute("signupSuccess", "Đăng ký thành công, hãy đăng nhập!");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
