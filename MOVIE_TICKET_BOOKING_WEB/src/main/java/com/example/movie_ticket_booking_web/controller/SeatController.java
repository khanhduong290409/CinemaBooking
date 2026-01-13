package com.example.movie_ticket_booking_web.controller;
import com.example.movie_ticket_booking_web.dao.SeatDAO;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
@WebServlet("/api/seats")
public class SeatController extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int showtimeId = Integer.parseInt(req.getParameter("showtimeId"));
        SeatDAO dao = new SeatDAO();

        resp.setContentType("application/json");
        new Gson().toJson(dao.getBookedSeats(showtimeId), resp.getWriter());
    }
}

