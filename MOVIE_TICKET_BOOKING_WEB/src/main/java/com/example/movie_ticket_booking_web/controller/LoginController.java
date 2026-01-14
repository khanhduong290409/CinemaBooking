package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.dao.UserDAO;
import com.example.movie_ticket_booking_web.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userOrEmail = request.getParameter("User");
        String password = request.getParameter("pass");

        User u = userDAO.login(userOrEmail, password);

        if (u != null) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", u); // LƯU OBJECT

            if ("ADMIN".equalsIgnoreCase(u.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("loginError", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
