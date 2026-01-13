package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.dao.MovieDAO;
import com.example.movie_ticket_booking_web.model.Movie;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/api/movie")
public class MovieApiController extends HttpServlet {

    private static String normalizePath(String p) {
        if (p == null) return null;
        // DB lưu kiểu: ../img/... => /img/...
        if (p.startsWith("../")) return "/" + p.substring(3);
        return p;
    }

    private static int parseMinutes(String runtime) {
        if (runtime == null) return 0;
        Matcher m = Pattern.compile("(\\d+)").matcher(runtime);
        return m.find() ? Integer.parseInt(m.group(1)) : 0;
    }

    static class MovieDTO {
        String title;
        String directed;
        String starring;
        String genre;
        int duration;
        String poster;
        String background;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String code = req.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            resp.setStatus(400);
            return;
        }

        MovieDAO dao = new MovieDAO();
        Movie m = dao.findByCode(code.trim());

        if (m == null) {
            resp.setStatus(404);
            return;
        }

        MovieDTO dto = new MovieDTO();
        dto.title = m.getTitle();
        dto.directed = m.getDirector();
        dto.starring = m.getActors();
        dto.genre = m.getGenre();
        dto.duration = parseMinutes(m.getRuntime());
        dto.poster = normalizePath(m.getPoster());
        dto.background = normalizePath(m.getImages());

        resp.setContentType("application/json; charset=UTF-8");
        new Gson().toJson(dto, resp.getWriter());
    }
}
