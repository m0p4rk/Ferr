package com.warr.ferr.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EventParticipant {
    private int eventId;
    private int userId;
    private String status;
    private Timestamp joinedAt;
}
