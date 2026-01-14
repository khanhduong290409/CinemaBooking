package com.example.movie_ticket_booking_web.dao;

import com.example.movie_ticket_booking_web.db.DBConnection;
import com.example.movie_ticket_booking_web.model.BookingSeat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookingSeatDAO {

    public List<BookingSeat> findByBookingId(int bookingId) {
        List<BookingSeat> list = new ArrayList<>();
        String sql = """
            SELECT booking_id, seat_row, seat_number
            FROM booking_seats
            WHERE booking_id = ?
            ORDER BY seat_row ASC, seat_number ASC
        """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BookingSeat s = new BookingSeat();
                s.setBookingId(rs.getInt("booking_id"));
//                s.setSeatRow(rs.getString("seat_row").charAt(0));
                s.setSeatRow(rs.getString("seat_row").charAt(0));

                s.setSeatNumber(rs.getInt("seat_number"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
