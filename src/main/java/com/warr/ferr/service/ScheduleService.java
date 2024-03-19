package com.warr.ferr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.warr.ferr.mapper.ScheduleMapper;
import com.warr.ferr.model.Schedule;

@Service
public class ScheduleService {

    private final ScheduleMapper scheduleMapper;

    @Autowired
    public ScheduleService(ScheduleMapper scheduleMapper) {
        this.scheduleMapper = scheduleMapper;
    }

    public void saveSchedule(Schedule schedule) {
        scheduleMapper.saveSchedule(schedule);
    }


}