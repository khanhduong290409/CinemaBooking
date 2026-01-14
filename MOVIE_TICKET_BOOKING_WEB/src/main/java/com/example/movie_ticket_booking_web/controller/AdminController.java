package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.dao.*;
import com.example.movie_ticket_booking_web.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin")
public class AdminController extends HttpServlet {

    private final MovieDAO movieDAO = new MovieDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final BookingSeatDAO seatDAO = new BookingSeatDAO();
    private final ShowtimeDAO showtimeDAO = new ShowtimeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // Dashboard counts
        req.setAttribute("movieCount", movieDAO.countAll());
        req.setAttribute("bookingCount", bookingDAO.countAll());

        // Movies
        List<Movie> movies = movieDAO.findAll();
        req.setAttribute("movies", movies);

        // load edit movie if needed
        String action = req.getParameter("action");
        String idRaw = req.getParameter("id");

        if ("editMovie".equals(action) && idRaw != null) {
            try {
                int id = Integer.parseInt(idRaw);
                Movie editMovie = movieDAO.findById(id);
                req.setAttribute("editMovie", editMovie);
                req.setAttribute("activeTab", "movies");
            } catch (Exception ignored) {}
        } else {
            req.setAttribute("activeTab", "dashboard");
        }

        // delete movie
        if ("deleteMovie".equals(action) && idRaw != null) {
            try {
                int id = Integer.parseInt(idRaw);
                movieDAO.delete(id);
            } catch (Exception ignored) {}
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }

        // Bookings
        List<Booking> bookings = bookingDAO.findAll();
        req.setAttribute("bookings", bookings);

        Map<Integer, String> seatTextMap = new HashMap<>();
        Map<Integer, Showtime> showtimeMap = new HashMap<>();
        Map<Integer, Movie> movieMapById = new HashMap<>();

        for (Booking b : bookings) {
            // seats text
            List<BookingSeat> seats = seatDAO.findByBookingId(b.getId());
            StringBuilder sb = new StringBuilder();
            for (BookingSeat s : seats) {
                if (s.getSeatRow() == '\0') continue;
                if (sb.length() > 0) sb.append(", ");
                sb.append(s.getSeatRow()).append(s.getSeatNumber());
            }
            seatTextMap.put(b.getId(), sb.length() == 0 ? "-" : sb.toString());

            // showtime
            int stId = b.getShowtimeId();
            Showtime st = showtimeMap.get(stId);
            if (st == null) {
                st = showtimeDAO.findById(stId);
                if (st != null) showtimeMap.put(stId, st);
            }

            // movie
            if (st != null) {
                int mvId = st.getMovieId();
                if (!movieMapById.containsKey(mvId)) {
                    Movie mv = movieDAO.findById(mvId);
                    if (mv != null) movieMapById.put(mvId, mv);
                }
            }
        }

        req.setAttribute("seatTextMap", seatTextMap);
        req.setAttribute("showtimeMap", showtimeMap);
        req.setAttribute("movieMapById", movieMapById);

        req.getRequestDispatcher("/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (!"saveMovie".equals(action)) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }

        String idRaw = req.getParameter("id");

        Movie m = new Movie();
        if (idRaw != null && !idRaw.isBlank()) {
            try { m.setId(Integer.parseInt(idRaw)); } catch (Exception ignored) {}
        }

        m.setCode(req.getParameter("code"));
        m.setTitle(req.getParameter("title"));
        m.setStatus(req.getParameter("status"));

        try {
            String ratedRaw = req.getParameter("rated");
            m.setRated(ratedRaw == null || ratedRaw.isBlank() ? 0 : Double.parseDouble(ratedRaw));
        } catch (Exception e) {
            m.setRated(0);
        }

        String releasedRaw = req.getParameter("released");
        if (releasedRaw != null && !releasedRaw.isBlank()) {
            try { m.setReleased(Date.valueOf(releasedRaw)); } catch (Exception ignored) {}
        }

        m.setRuntime(req.getParameter("runtime"));
        m.setAge(req.getParameter("age"));
        m.setGenre(req.getParameter("genre"));
        m.setDirector(req.getParameter("director"));
        m.setActors(req.getParameter("actors"));
        m.setPlot(req.getParameter("plot"));
        m.setDescription(req.getParameter("description"));
        m.setLanguage(req.getParameter("language"));
        m.setCountry(req.getParameter("country"));
        m.setPoster(req.getParameter("poster"));
        m.setImages(req.getParameter("images"));
//        m.setVideoUrl(req.getParameter("videoUrl"));
        String rawVideo = req.getParameter("videoUrl");
        m.setVideoUrl(normalizeYoutubeEmbedWithAutoParams(rawVideo));


        if (m.getId() > 0) movieDAO.update(m);
        else movieDAO.insert(m);

        resp.sendRedirect(req.getContextPath() + "/admin");
    }
    private String extractYoutubeId(String url) {
        if (url == null) return null;
        url = url.trim();
        if (url.isEmpty()) return null;

        // already embed
        int idx = url.indexOf("youtube.com/embed/");
        if (idx != -1) {
            String id = url.substring(idx + "youtube.com/embed/".length());
            // cut query or extra path
            int cut = id.indexOf('?'); if (cut != -1) id = id.substring(0, cut);
            cut = id.indexOf('&');     if (cut != -1) id = id.substring(0, cut);
            cut = id.indexOf('/');     if (cut != -1) id = id.substring(0, cut);
            return id;
        }

        // youtu.be/VIDEO_ID
        idx = url.indexOf("youtu.be/");
        if (idx != -1) {
            String id = url.substring(idx + "youtu.be/".length());
            int cut = id.indexOf('?'); if (cut != -1) id = id.substring(0, cut);
            cut = id.indexOf('&');     if (cut != -1) id = id.substring(0, cut);
            cut = id.indexOf('/');     if (cut != -1) id = id.substring(0, cut);
            return id;
        }

        // watch?v=VIDEO_ID
        idx = url.indexOf("watch?v=");
        if (idx != -1) {
            String id = url.substring(idx + "watch?v=".length());
            int cut = id.indexOf('&'); if (cut != -1) id = id.substring(0, cut);
            cut = id.indexOf('?');     if (cut != -1) id = id.substring(0, cut);
            return id;
        }

        // short param v=VIDEO_ID (fallback)
        idx = url.indexOf("v=");
        if (idx != -1) {
            String id = url.substring(idx + 2);
            int cut = id.indexOf('&'); if (cut != -1) id = id.substring(0, cut);
            cut = id.indexOf('?');     if (cut != -1) id = id.substring(0, cut);
            return id;
        }

        return null;
    }

    private String normalizeYoutubeEmbedWithAutoParams(String rawUrl) {
        if (rawUrl == null) return null;
        String url = rawUrl.trim();
        if (url.isEmpty()) return "";

        // nếu không phải youtube thì giữ nguyên
        String lower = url.toLowerCase();
        if (!(lower.contains("youtube.com") || lower.contains("youtu.be"))) {
            return url;
        }

        String id = extractYoutubeId(url);
        if (id == null || id.isEmpty()) {
            // không parse được thì trả nguyên
            return url;
        }

        // base embed url
        String base = "https://www.youtube.com/embed/" + id;

        // luôn append param chuẩn (không phụ thuộc user nhập gì)
        return base + "?autoplay=1&loop=1&playlist=" + id;
    }

}
