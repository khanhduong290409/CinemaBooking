package com.example.movie_ticket_booking_web.controller;

import java.util.List;


public class BookingRequest {
    public int showtimeId;
    public List<String> seats; // ví dụ: ["A1","A2"]
    public int total;
}
