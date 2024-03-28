package com.warr.ferr.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Getter
@Setter
@Data
public class ScheduleUpdateDto {

    private int eventId;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date promiseDate;
}
