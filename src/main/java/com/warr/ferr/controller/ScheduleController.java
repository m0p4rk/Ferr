package com.warr.ferr.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.warr.ferr.model.Schedule;
import com.warr.ferr.service.ScheduleService;

@Controller
public class ScheduleController {

    private final ScheduleService scheduleService;

    @Autowired
    public ScheduleController(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
    }
    
    
    @PostMapping("/saveSchedule")
    @ResponseBody
    public String saveSchedule(@RequestBody Schedule schedule) {
        try {
            scheduleService.saveSchedule(schedule);
            return "일정이 성공적으로 저장되었습니다.";
        } catch (Exception e) {
            e.printStackTrace();
            return "일정 저장 중 오류가 발생했습니다.";
        }
    }
}