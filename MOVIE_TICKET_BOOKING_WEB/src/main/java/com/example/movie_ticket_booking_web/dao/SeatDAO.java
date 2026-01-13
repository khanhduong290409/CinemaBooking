package com.example.movie_ticket_booking_web.dao;

import com.example.movie_ticket_booking_web.db.DBConnection;

import java.sql.*;
import java.util.*;

public class SeatDAO {

    public Map<String, List<Integer>> getBookedSeats(int showtimeId) {
        Map<String, List<Integer>> map = new HashMap<>();

        String sql = """
            SELECT bs.seat_row, bs.seat_number
            FROM booking_seats bs
            JOIN booking b ON bs.booking_id = b.id
            WHERE b.showtime_id = ?
        """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, showtimeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String row = rs.getString("seat_row");
                int number = rs.getInt("seat_number");
                map.computeIfAbsent(row, k -> new ArrayList<>()).add(number);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
}
