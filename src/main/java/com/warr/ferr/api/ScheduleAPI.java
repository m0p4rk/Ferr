package com.warr.ferr.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.warr.ferr.model.Schedule;
import com.warr.ferr.service.ScheduleService;

import jakarta.servlet.http.HttpSession;

// Spring REST 컨트롤러로 정의
@RestController
public class ScheduleAPI {

    // ScheduleService 의존성 주입
    @Autowired
    private ScheduleService scheduleService;

    // 클라이언트로부터 받은 일정 데이터를 처리하는 엔드포인트 정의
    @PostMapping("/saveSchedule")
    @ResponseBody
    public String saveSchedule(@RequestBody Schedule schedule, HttpSession session) {
        try {
            // 받은 일정 데이터를 데이터베이스에 저장
        	System.out.println(schedule);
            scheduleService.saveSchedule(schedule, session);
            return "일정이 성공적으로 저장되었습니다.";
        } catch (Exception e) {
            e.printStackTrace();
            return "일정 저장 중 오류가 발생했습니다.";
        }
    }
}
