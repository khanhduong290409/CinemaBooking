package com.example.movie_ticket_booking_web.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/uudai")
public class UuDaiController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Nếu có load data ưu đãi từ DB thì setAttribute ở đây

        // Forward tới JSP
        req.getRequestDispatcher("uudai.jsp").forward(req, resp);

        // ✅ Nếu chị đặt JSP trong /WEB-INF/views/ (khuyên dùng)
        // req.getRequestDispatcher("/WEB-INF/views/uudai.jsp").forward(req, resp);
    }
}
