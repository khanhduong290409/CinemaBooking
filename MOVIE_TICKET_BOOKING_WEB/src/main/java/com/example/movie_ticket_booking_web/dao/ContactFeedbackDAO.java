package com.example.movie_ticket_booking_web.dao;

import com.example.movie_ticket_booking_web.db.DBConnection;
import com.example.movie_ticket_booking_web.model.ContactFeedback;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ContactFeedbackDAO {
    public boolean insert(ContactFeedback contactFeedback) {
        String sql = """
            INSERT INTO contact_feedback(city, name,email, phone, message)
            VALUES (?,?,?,?,?)
            """;
        try (Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, contactFeedback.getCity());
            ps.setString(2, contactFeedback.getName());
            ps.setString(3, contactFeedback.getEmail());
            ps.setString(4, contactFeedback.getPhone());
            ps.setString(5, contactFeedback.getMessage());
            return ps.executeUpdate() > 0;


        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;

    }


}
