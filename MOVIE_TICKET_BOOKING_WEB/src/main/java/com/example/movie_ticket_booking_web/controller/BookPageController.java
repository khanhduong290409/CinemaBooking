package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/book")
public class BookPageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session == null) ? null : (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            // (tuỳ chọn) lưu lại trang user muốn vào để login xong quay lại
            String url = req.getRequestURI();
            String qs = req.getQueryString();
            String full = (qs == null) ? url : (url + "?" + qs);

            String redirect = URLEncoder.encode(full, StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + redirect);
            return;
        }

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
