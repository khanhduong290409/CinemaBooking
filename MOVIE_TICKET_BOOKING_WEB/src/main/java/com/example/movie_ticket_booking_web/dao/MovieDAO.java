package com.example.movie_ticket_booking_web.dao;

import com.example.movie_ticket_booking_web.db.DBConnection;
import com.example.movie_ticket_booking_web.model.Movie;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO {

    private Movie mapRow(ResultSet rs) throws SQLException {
        Movie m = new Movie();
        m.setId(rs.getInt("id"));
        m.setTitle(rs.getString("title"));
        m.setAge(rs.getString("age"));
        m.setRated(rs.getDouble("rated"));
        m.setReleased(rs.getDate("released"));
        m.setRuntime(rs.getString("runtime"));
        m.setGenre(rs.getString("genre"));
        m.setDirector(rs.getString("director"));
        m.setActors(rs.getString("actors"));
        m.setDescription(rs.getString("description"));
        m.setPlot(rs.getString("plot"));
        m.setLanguage(rs.getString("language"));
        m.setCountry(rs.getString("country"));
        m.setPoster(rs.getString("poster"));
        m.setImages(rs.getString("images"));
        m.setBookingUrl(rs.getString("booking_url"));
        m.setVideoUrl(rs.getString("video_url"));
        m.setStatus(rs.getString("status"));
        return m;
    }
    public List<Movie> findTopRatedNowShowing(int limit) {
        String sql = "SELECT * FROM movies WHERE status='NOW_SHOWING' ORDER BY rated DESC, released DESC LIMIT ?";
        List<Movie> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Movie> findTopNowShowingForCarousel(int limit) {
        // bạn có thể đổi order theo released DESC nếu muốn
        String sql = "SELECT * FROM movies WHERE status='NOW_SHOWING' ORDER BY released DESC, rated DESC LIMIT ?";
        List<Movie> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Movie findById(int id) {
        String sql = "SELECT * FROM movies WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Movie> findByStatus(String status) {
        String sql = "SELECT * FROM movies WHERE status = ? ORDER BY released DESC";
        List<Movie> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Movie> findNowShowing() {
        return findByStatus("NOW_SHOWING");
    }

    public List<Movie> findUpcoming() {
        return findByStatus("UPCOMING");
    }
}
