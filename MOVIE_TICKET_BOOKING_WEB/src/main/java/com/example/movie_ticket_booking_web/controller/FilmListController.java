package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.dao.MovieDAO;
import com.example.movie_ticket_booking_web.model.Movie;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/films")
public class FilmListController extends HttpServlet {

    private MovieDAO movieDAO;

    @Override
    public void init() {
        movieDAO = new MovieDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Movie> nowShowing = movieDAO.findNowShowing();
        List<Movie> upcoming = movieDAO.findUpcoming();

        request.setAttribute("nowShowingMovies", nowShowing);
        request.setAttribute("upcomingMovies", upcoming);

        request.getRequestDispatcher("/film.jsp").forward(request, response);
    }
}
