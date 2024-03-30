package com.warr.ferr.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class EventNotification {

    // user_events 테이블 필드
    private Integer eventId;
    private Integer userId;
    private String contentId;
    private String eventTitle;
    private Date eventStartDate;
    private Date eventEndDate;
    private Double latitude;
    private Double longitude;
    private Date createdAt;
    private Date promiseDate;
    private String startLocation;

    // schedule_notifications 테이블 필드
    private Integer notificationId;
    private String Content;
    private Date notificationTime;
    private Date notificationCreatedAt;
}
