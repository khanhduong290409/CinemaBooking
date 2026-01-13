package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.dao.ShowtimeDAO;
import com.example.movie_ticket_booking_web.model.Showtime;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/api/showtimes")
public class ShowtimeController extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String movieCode = req.getParameter("movie");
        Date date = Date.valueOf(req.getParameter("date"));

        ShowtimeDAO dao = new ShowtimeDAO();
        List<Showtime> list = dao.getShowtimesByMovieAndDate(movieCode, date);

        resp.setContentType("application/json");
        new Gson().toJson(list, resp.getWriter());
    }
}
