package com.example.movie_ticket_booking_web.model;

import lombok.*;

import java.sql.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Movie {
    private int id;
    private String title;
    private String age;
    private double rated;
    private Date released;
    private String runtime;
    private String genre;
    private String director;
    private String actors;
    private String description;
    private String plot;
    private String language;
    private String country;
    private String poster;     // VD: ../img/poster/xxx.jpg (giữ nguyên DB)
    private String images;     // VD: ../img/bg/xxx.jpg (giữ nguyên DB)
    private String bookingUrl; // VD: ../html/book.html?Robot hoặc book?code=Robot
    private String videoUrl;   // iframe src
    private String status;     // NOW_SHOWING / UPCOMING
}
