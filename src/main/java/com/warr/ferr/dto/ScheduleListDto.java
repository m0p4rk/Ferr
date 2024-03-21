package com.warr.ferr.dto;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Data
public class ScheduleListDto {
    private int eventId;
    private String eventTitle;
    private Timestamp eventStartDate;
    private Timestamp eventEndDate;
    private Date promiseDate;
    private String contentId;
}
