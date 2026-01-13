package com.example.movie_ticket_booking_web.dao;


import com.example.movie_ticket_booking_web.db.DBConnection;
import com.example.movie_ticket_booking_web.model.Showtime;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class ShowtimeDAO {

    public List<Showtime> getShowtimesByMovieAndDate(String movieCode, Date date) {
        List<Showtime> list = new ArrayList<>();
        String sql = """
            SELECT s.*
            FROM showtimes s
            JOIN movies m ON s.movie_id = m.id
            WHERE m.code = ? AND s.show_date = ?
        """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, movieCode);
            ps.setDate(2, date);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Showtime s = new Showtime();
                s.setId(rs.getInt("id"));
                s.setMovieId(rs.getInt("movie_id"));
                s.setShowDate(rs.getDate("show_date"));
                s.setShowTime(rs.getTime("show_time"));
                s.setFormat(rs.getString("format"));
                s.setPrice(rs.getInt("price"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}