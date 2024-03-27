package com.warr.ferr.api;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.warr.ferr.dto.ScheduleRequest;
import com.warr.ferr.model.Schedule;
import com.warr.ferr.service.EventParticipantService;
import com.warr.ferr.service.ScheduleService;

import jakarta.servlet.http.HttpSession;

@RestController
public class ScheduleAPI {

    private final ScheduleService scheduleService;
    private final EventParticipantService eventParticipantService;

    public ScheduleAPI(ScheduleService scheduleService, EventParticipantService eventParticipantService) {
        this.scheduleService = scheduleService;
        this.eventParticipantService = eventParticipantService;
    }

    @PostMapping("/saveSchedule")
    public ResponseEntity<?> saveSchedule(@RequestBody ScheduleRequest scheduleRequest, HttpSession session) {
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not logged in.");
            }

            System.out.println("Received ScheduleRequest: " + scheduleRequest);
            if (scheduleRequest.getSchedule() == null) {
                System.out.println("Schedule object is null inside ScheduleRequest");
                return ResponseEntity.badRequest().body("Schedule object is missing in the request");
            }

            Schedule schedule = scheduleRequest.getSchedule();
            schedule.setUserId(userId);

            // Schedule 객체를 데이터베이스에 저장하고, 생성된 eventId 반환
            int eventId = scheduleService.saveSchedule(schedule);
            System.out.println(eventId);

            // 기본 'status' 값 설정을 포함한 참가자 정보 저장 로직
            // 예를 들어, 모든 참가자를 'INVITED' 상태로 추가
            if (scheduleRequest.getParticipantUserIds() != null) {
                eventParticipantService.saveParticipantsWithDefaultStatus(eventId, scheduleRequest.getParticipantUserIds(), "INVITED");
            }

            return ResponseEntity.ok().body("일정이 성공적으로 저장되었습니다. Event ID: " + eventId);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("일정 저장 중 오류가 발생했습니다: " + e.getMessage());
        }
    }


}
