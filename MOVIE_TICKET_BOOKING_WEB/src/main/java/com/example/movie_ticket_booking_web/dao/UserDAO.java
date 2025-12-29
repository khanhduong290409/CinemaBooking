package com.example.movie_ticket_booking_web.dao;

import com.example.movie_ticket_booking_web.db.DBConnection;
import com.example.movie_ticket_booking_web.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
//    public User getAll() {
//        String sql = "SELECT * FROM uses";
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps
//
//    }
    public User findByUsernameOrEmail(String userOrEmail) {
        String sql = "SELECT * FROM users WHERE username = ? OR email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userOrEmail);
            ps.setString(2, userOrEmail);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(User user) {
        String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // thực tế nên hash mật khẩu

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            // có thể do trùng username/email
            e.printStackTrace();
            return false;
        }
    }

    public boolean checkLogin(String userOrEmail, String password) {
        User u = findByUsernameOrEmail(userOrEmail);
        if (u == null) return false;

        // nếu dùng hash thì ở đây phải so sánh hash
        return password.equals(u.getPassword());
    }
}
