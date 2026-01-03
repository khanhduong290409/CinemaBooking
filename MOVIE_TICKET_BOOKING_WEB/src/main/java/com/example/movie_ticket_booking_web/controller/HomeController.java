package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.dao.MovieDAO;
import com.example.movie_ticket_booking_web.model.Movie;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeController extends HttpServlet {

    private MovieDAO movieDAO;

    @Override
    public void init() {
        movieDAO = new MovieDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Hero slider (swiper)
        List<Movie> heroMovies = movieDAO.findTopRatedNowShowing(5);

        // Movie Selection (owl carousel)
        List<Movie> carouselMovies = movieDAO.findTopNowShowingForCarousel(12);

        request.setAttribute("heroMovies", heroMovies);
        request.setAttribute("carouselMovies", carouselMovies);

        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
