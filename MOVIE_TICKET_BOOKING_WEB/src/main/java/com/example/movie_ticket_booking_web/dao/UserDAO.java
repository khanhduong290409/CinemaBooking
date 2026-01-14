package com.example.movie_ticket_booking_web.dao;

import com.example.movie_ticket_booking_web.db.DBConnection;
import com.example.movie_ticket_booking_web.model.User;
import com.example.movie_ticket_booking_web.util.PasswordHashUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

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
                    // nếu DB chưa có role thì dòng này có thể null
                    try {
                        u.setRole(rs.getString("role"));
                    } catch (SQLException ignore) {
                        u.setRole("USER");
                    }
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(User user) {
        String sql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole() == null ? "USER" : user.getRole());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Trả về User nếu login OK, null nếu sai
    public User login(String userOrEmail, String rawPassword) {
        User u = findByUsernameOrEmail(userOrEmail);
        if (u == null) return null;

        String stored = u.getPassword();

        // DB đã hash
        if (PasswordHashUtil.isHashed(stored)) {
            return PasswordHashUtil.verify(rawPassword, stored) ? u : null;
        }

        // DB còn plaintext (tài khoản cũ) -> cho login rồi auto-upgrade sang hash
        if (stored != null && stored.equals(rawPassword)) {
            String newHash = PasswordHashUtil.hash(rawPassword);
            boolean updated = updatePassword(u.getId(), newHash);
            if (updated) u.setPassword(newHash);
            return u;
        }

        return null;
    }

    private boolean updatePassword(int userId, String newHashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
