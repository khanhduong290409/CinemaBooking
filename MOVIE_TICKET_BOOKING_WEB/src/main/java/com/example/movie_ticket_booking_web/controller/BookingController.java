package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.dao.BookingDAO;
import com.example.movie_ticket_booking_web.model.User;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/booking")
public class BookingController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        // ====== CHECK LOGIN ======
        HttpSession session = req.getSession(false);
        User currentUser = (session == null) ? null : (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Vui lòng đăng nhập để đặt vé\"}");
            return;
        }

        Gson gson = new Gson();

        try {
            BookingRequest br = gson.fromJson(req.getReader(), BookingRequest.class);

            if (br == null || br.showtimeId <= 0 || br.seats == null || br.seats.isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"Dữ liệu đặt vé không hợp lệ\"}");
                return;
            }

            BookingDAO dao = new BookingDAO();

            // ====== PASS USER ID ======
            dao.createBookingWithLock(
                    currentUser.getId(),
                    br.showtimeId,
                    br.total,
                    br.seats
            );

            resp.getWriter().write("{\"status\":\"success\"}");

        } catch (IllegalStateException e) {
            resp.setStatus(HttpServletResponse.SC_CONFLICT);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Ghế đã được đặt\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi hệ thống\"}");
        }
    }
}
