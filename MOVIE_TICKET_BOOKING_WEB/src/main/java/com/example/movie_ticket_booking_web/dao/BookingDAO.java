package com.example.movie_ticket_booking_web.dao;

import com.example.movie_ticket_booking_web.db.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public int createBooking(Integer userId, int showtimeId, int totalPrice) throws Exception {
        String sql = "INSERT INTO booking(user_id, showtime_id, total_price) VALUES (?, ?, ?)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (userId == null) ps.setNull(1, Types.INTEGER);
            else ps.setInt(1, userId);

            ps.setInt(2, showtimeId);
            ps.setInt(3, totalPrice);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public void saveSeats(int bookingId, List<String> seats) throws Exception {
        String sql = "INSERT INTO booking_seats(booking_id, seat_row, seat_number) VALUES (?, ?, ?)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            for (String s : seats) {
                ps.setInt(1, bookingId);
                ps.setString(2, s.substring(0, 1));
                ps.setInt(3, Integer.parseInt(s.substring(1)));
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    /**
     * Tạo booking + check ghế đã được đặt (lock).
     * Nếu ghế đã tồn tại trong booking_seats của cùng showtime -> throw IllegalStateException.
     */
    public void createBookingWithLock(Integer userId, int showtimeId, int totalPrice, List<String> seats) throws Exception {
        if (seats == null || seats.isEmpty()) {
            throw new IllegalArgumentException("Seats is empty");
        }

        Connection c = null;
        try {
            c = DBConnection.getConnection();
            c.setAutoCommit(false);

            // ===== 1) Check ghế đã đặt (JOIN booking để dùng b.showtime_id) =====
            // Tạo IN (?, ?, ?, ...)
            StringBuilder in = new StringBuilder();
            for (int i = 0; i < seats.size(); i++) {
                if (i > 0) in.append(",");
                in.append("?");
            }

            String checkSql =
                    "SELECT bs.seat_row, bs.seat_number " +
                            "FROM booking_seats bs " +
                            "JOIN booking b ON bs.booking_id = b.id " +
                            "WHERE b.showtime_id = ? " +
                            "AND CONCAT(bs.seat_row, bs.seat_number) IN (" + in + ") " +
                            "FOR UPDATE";

            try (PreparedStatement ps = c.prepareStatement(checkSql)) {
                int idx = 1;
                ps.setInt(idx++, showtimeId);
                for (String code : seats) {
                    ps.setString(idx++, code);
                }

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // có ít nhất 1 ghế trùng
                        throw new IllegalStateException("Seat already booked");
                    }
                }
            }

            // ===== 2) Insert booking =====
            int bookingId;
            String insertBookingSql = "INSERT INTO booking(user_id, showtime_id, total_price) VALUES (?, ?, ?)";

            try (PreparedStatement ps = c.prepareStatement(insertBookingSql, Statement.RETURN_GENERATED_KEYS)) {
                if (userId == null) ps.setNull(1, Types.INTEGER);
                else ps.setInt(1, userId);

                ps.setInt(2, showtimeId);
                ps.setInt(3, totalPrice);

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) throw new SQLException("Cannot get booking id");
                    bookingId = rs.getInt(1);
                }
            }

            // ===== 3) Insert booking_seats =====
            String insertSeatSql = "INSERT INTO booking_seats(booking_id, seat_row, seat_number) VALUES (?, ?, ?)";

            try (PreparedStatement ps = c.prepareStatement(insertSeatSql)) {
                for (String s : seats) {
                    ps.setInt(1, bookingId);
                    ps.setString(2, s.substring(0, 1));
                    ps.setInt(3, Integer.parseInt(s.substring(1)));
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            c.commit();

        } catch (Exception e) {
            if (c != null) {
                try { c.rollback(); } catch (Exception ignored) {}
            }
            throw e;
        } finally {
            if (c != null) {
                try { c.setAutoCommit(true); } catch (Exception ignored) {}
                try { c.close(); } catch (Exception ignored) {}
            }
        }
    }
}
