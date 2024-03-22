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
    private int eventId;
    private int userId;
    private String contentId;
    private String eventTitle;
    private Timestamp eventStartDate;
    private Timestamp eventEndDate;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private Timestamp createdAt;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date promiseDate;
    private String startLocation;

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