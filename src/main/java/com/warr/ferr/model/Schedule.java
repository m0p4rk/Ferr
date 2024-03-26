package com.warr.ferr.model;

import java.sql.Date;
import java.sql.Timestamp;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@Setter
@Entity
@NoArgsConstructor
@ToString
public class Schedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
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
    private String startLocation;

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
