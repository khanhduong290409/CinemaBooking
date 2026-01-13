package com.example.movie_ticket_booking_web.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookingSeat {
    private int bookingId;
    private char seatRow;
    private int seatNumber;
}
