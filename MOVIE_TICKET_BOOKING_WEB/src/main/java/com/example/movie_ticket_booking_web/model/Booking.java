package com.example.movie_ticket_booking_web.model;

import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
public class Booking {
    private int id;
    private Integer userId;
    private int showtimeId;
    private int totalPrice;

}
