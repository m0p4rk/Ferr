package com.warr.ferr.model;

import java.util.Date;
import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.Id;

import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
@Getter
@Setter
@Entity
public class Schedule {
    @Id
    private int eventId; // auto
    private int userId; // static
    private String contentId; // input
    private String eventTitle; // title -> api1
    private Timestamp eventStartDate; // eventStartDate -> api2
    private Timestamp eventEndDate; // eventEndDate -> api2
    private BigDecimal latitude; // mapx -> api1
    private BigDecimal longitude; // mapy -> api1
    private Timestamp createdAt; // auto(default: current_timestamp)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date promiseDate; // input
    private String startLocation; // input

    public Schedule() {

    }

    public Schedule(int userId, String contentId, String eventTitle, Timestamp eventStartDate, Timestamp eventEndDate, BigDecimal latitude, BigDecimal longitude, Timestamp createdAt, Date promiseDate, String startLocation) {
        this.userId = userId;
        this.contentId = contentId;
        this.eventTitle = eventTitle;
        this.eventStartDate = eventStartDate;
        this.eventEndDate = eventEndDate;
        this.latitude = latitude;
        this.longitude = longitude;
        this.createdAt = createdAt;
        this.promiseDate = promiseDate;
        this.startLocation = startLocation;
    }

}