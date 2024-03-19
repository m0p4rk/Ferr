package com.warr.ferr.model;


import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
public class Schedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int userId;
    private String contentId;
    private String eventTitle;
    private Date eventStartDate;
    private Date eventEndDate;
    private double latitude;
    private double longitude;
    private Timestamp createdAt;
}