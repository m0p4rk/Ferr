package com.warr.ferr.dto;

import java.util.List;

import com.warr.ferr.model.Schedule;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString

public class ScheduleRequest {
    private Schedule schedule;
    private List<Integer> participantUserIds; // 참가자 userId 목록
    private int userId; 
    // Getters and setters
}

