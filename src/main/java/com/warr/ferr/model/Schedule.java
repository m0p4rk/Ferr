package com.warr.ferr.model;

import lombok.*;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

@Getter
@Setter
public class Schedule {
    private int eventId;
    private int userId;
    private String contentId;
    private String eventTitle;
    private Timestamp eventStartDate;
    private Timestamp eventEndDate;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private Timestamp createdAt;
    private Date promiseDate;

    public Schedule() {

    }

    public Schedule(int userId, String contentId, String eventTitle, Timestamp eventStartDate, Timestamp eventEndDate, BigDecimal latitude, BigDecimal longitude, Timestamp createdAt, Date promiseDate) {
        this.userId = userId;
        this.contentId = contentId;
        this.eventTitle = eventTitle;
        this.eventStartDate = eventStartDate;
        this.eventEndDate = eventEndDate;
        this.latitude = latitude;
        this.longitude = longitude;
        this.createdAt = createdAt;
        this.promiseDate = promiseDate;
    }

}
