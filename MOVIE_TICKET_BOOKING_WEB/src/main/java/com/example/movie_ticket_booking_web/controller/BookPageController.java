package com.example.movie_ticket_booking_web.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/book")
public class BookPageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String movieCode = req.getParameter("movie");
        if (movieCode == null || movieCode.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/films");
            return;
        }

        req.setAttribute("movieCode", movieCode);

        // forward tới JSP
        req.getRequestDispatcher("book.jsp").forward(req, resp);
    }
}
