package com.warr.ferr.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Notification {
    private int notificationId;
    private int eventId;
    private int userId;
    private String content;
    private Timestamp notificationTime;
    private Timestamp createdAt;
}
