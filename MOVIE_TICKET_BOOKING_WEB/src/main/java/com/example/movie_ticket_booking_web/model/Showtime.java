package com.example.movie_ticket_booking_web.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Date;
import java.sql.Time;

@Getter
@Setter
public class Showtime {
    private int id;
    private int movieId;
    private Date showDate;
    private Time showTime;
    private String format;
    private int price;

}
