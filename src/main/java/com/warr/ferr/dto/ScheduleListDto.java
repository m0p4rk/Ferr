package com.warr.ferr.dto;

import lombok.*;
import lombok.extern.slf4j.Slf4j;

import java.sql.Date;
import java.sql.Timestamp;

@Slf4j
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
