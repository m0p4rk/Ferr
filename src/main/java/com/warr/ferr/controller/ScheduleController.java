package com.warr.ferr.controller;



import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.model.Schedule;
import com.warr.ferr.service.ScheduleService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor

public class ScheduleController {

    private final ScheduleService scheduleService;   
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


    // JSON Object가 뿌려졌다 가정
    // Test Data Init으로 Schedule 객체(유저아이디, 내용, 행사명, 시작 시간, 종료 시간, 위도, 경도, 생성 시간)를 추가

    // Event-Detail에서 GET 요청과 함께
    // Controller에서 Test Data의 위도, 경도를 넘기면서 weatherService를 호출하고, WeatherResponse를 얻는다
    // 그리고 /schedule-detail?userId= 으로 모델 데이터를 뿌린다

    // Note 내용은 Notification Controller에서 받고 Notification 객체 생성

    // 일정 추가 누르면
    // 스케줄디테일페이지에 데이터를 뿌릴때는 자바 객체만 생성해서 뿌리고
    // 내 일정에 뿌릴 때는 DB에 저장

    @GetMapping("/schedulelist")
    public String schedules(Model model) {
        List<Schedule> testSchedules = scheduleService.testDataInit();
        Schedule schedule1 = testSchedules.get(0);
        Schedule schedule2 = testSchedules.get(1);
        scheduleService.save(schedule1);
        scheduleService.save(schedule2);

        List<ScheduleListDto> callSchedules = scheduleService.findSchedules();
        log.info("callSchedules={}", callSchedules);
        model.addAttribute("schedules", callSchedules);
        return "dashboard_schedule";
    }


}

