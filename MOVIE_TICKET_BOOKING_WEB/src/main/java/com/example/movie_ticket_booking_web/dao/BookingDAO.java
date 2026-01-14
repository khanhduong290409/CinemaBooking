package com.example.movie_ticket_booking_web.dao;

import com.example.movie_ticket_booking_web.db.DBConnection;
import com.example.movie_ticket_booking_web.model.Booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public List<Booking> findAll() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT id, user_id, showtime_id, total_price FROM booking ORDER BY id DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking b = new Booking();
                b.setId(rs.getInt("id"));

                int uid = rs.getInt("user_id");
                if (rs.wasNull()) b.setUserId(null);
                else b.setUserId(uid);

                b.setShowtimeId(rs.getInt("showtime_id"));
                b.setTotalPrice(rs.getInt("total_price"));
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM booking";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Tạo booking + lưu ghế trong 1 transaction
     * Lock ghế để tránh đặt trùng (dựa theo showtime_id trong bảng booking)
     */
    public void createBookingWithLock(Integer userId, int showtimeId, int totalPrice, List<String> seats) throws Exception {
        if (seats == null || seats.isEmpty()) {
            throw new IllegalArgumentException("Seats is empty");
        }

        Connection c = null;
        try {
            c = DBConnection.getConnection();
            c.setAutoCommit(false);

            // 1) lock/check ghế đã có trong showtime này chưa
            String lockSql = """
                SELECT 1
                FROM booking_seats bs
                JOIN booking b ON bs.booking_id = b.id
                WHERE b.showtime_id = ?
                  AND bs.seat_row = ?
                  AND bs.seat_number = ?
                FOR UPDATE
            """;

            try (PreparedStatement lockPs = c.prepareStatement(lockSql)) {
                for (String s : seats) {
                    String row = s.substring(0, 1);
                    int num = Integer.parseInt(s.substring(1));

                    lockPs.setInt(1, showtimeId);
                    lockPs.setString(2, row);
                    lockPs.setInt(3, num);

                    try (ResultSet rs = lockPs.executeQuery()) {
                        if (rs.next()) {
                            throw new IllegalStateException("Seat already booked");
                        }
                    }
                }
            }

            // 2) insert booking
            int bookingId;
            String bookingSql = "INSERT INTO booking(user_id, showtime_id, total_price) VALUES (?, ?, ?)";

            try (PreparedStatement ps = c.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
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

            // 3) insert booking_seats (KHÔNG có showtime_id)
            String seatSql = "INSERT INTO booking_seats(booking_id, seat_row, seat_number) VALUES (?, ?, ?)";

            try (PreparedStatement ps = c.prepareStatement(seatSql)) {
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
