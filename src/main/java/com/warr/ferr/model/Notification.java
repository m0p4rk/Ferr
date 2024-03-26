package com.warr.ferr.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.sql.Date;
import java.sql.Timestamp;

@Getter
@Setter
@Entity
@ToString
public class Notification {
    @Id
    private int notificationId;
    private int eventId;
    private int userId;
    private String content;
    private Date notificationTime;
    private Timestamp createdAt;

    public Notification() {

    }

    public Notification(int notificationId, int eventId, int userId, String content, Date notificationTime, Timestamp createdAt) {
        this.notificationId = notificationId;
        this.eventId = eventId;
        this.userId = userId;
        this.content = content;
        this.notificationTime = notificationTime;
        this.createdAt = createdAt;
    }
}
