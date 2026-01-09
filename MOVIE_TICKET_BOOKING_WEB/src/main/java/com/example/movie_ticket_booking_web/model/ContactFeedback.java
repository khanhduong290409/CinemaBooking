package com.example.movie_ticket_booking_web.model;

import lombok.*;

import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ContactFeedback {
    private int id;
    private String city;
    private String name;
    private String email;
    private String phone;
    private String message;
    private Timestamp createdAt;
    public ContactFeedback(String city, String name, String email, String phone, String message ) {
        this.city = city;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.message = message;
    }


}
