package com.warr.ferr.api;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.warr.ferr.dto.EventIdDTO;
import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.dto.ScheduleRequest;
import com.warr.ferr.model.Notification;
import com.warr.ferr.model.Schedule;
import com.warr.ferr.service.ChatService;
import com.warr.ferr.service.EventParticipantService;
import com.warr.ferr.service.NotificationService;
import com.warr.ferr.service.ScheduleService;

import jakarta.servlet.http.HttpSession;

@RestController
public class ScheduleAPI {

    private final ScheduleService scheduleService;
    private final EventParticipantService eventParticipantService;
    private final NotificationService notificationService;
    private final ChatService chatService;

    public ScheduleAPI(ScheduleService scheduleService, EventParticipantService eventParticipantService, NotificationService notificationService, ChatService chatService) {
        this.scheduleService = scheduleService;
        this.eventParticipantService = eventParticipantService;
        this.notificationService = notificationService; // 생성자를 통한 의존성 주입
        this.chatService = chatService;
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
                chatService.scheduleChatCreate(scheduleRequest); // 그룹채팅 자동생성 
            }

            return ResponseEntity.ok().body("일정이 성공적으로 저장되었습니다. Event ID: " + eventId);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("일정 저장 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    /**
     * 특정 eventId에 해당하는 Schedule 객체를 조회하는 엔드포인트.
     * @param eventId 조회하려는 Schedule의 eventId.
     * @return 조회된 Schedule 객체 또는 오류 메시지.
     */
    @GetMapping("/schedule/{eventId}")
    public ResponseEntity<?> getScheduleByEventId(@PathVariable Integer eventId) {
        try {
            Schedule schedule = scheduleService.findByEventId(eventId);
            if (schedule == null) {
                // 해당 eventId를 가진 Schedule이 존재하지 않는 경우
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("해당 eventId를 가진 일정을 찾을 수 없습니다: " + eventId);
            }
            // 성공적으로 Schedule 객체를 찾은 경우
            return ResponseEntity.ok(schedule);
        } catch (Exception e) {
            e.printStackTrace();
            // 서버 내부 오류 처리
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("일정 조회 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    @GetMapping("/schedules")
    public ResponseEntity<List<ScheduleListDto>> getAllSchedules() {
        List<ScheduleListDto> schedules = scheduleService.findAllSchedules();
        return ResponseEntity.ok(schedules); // 일정 목록을 JSON 형태로 반환
    }
    
    @PostMapping("/getNotifications")
    public ResponseEntity<?> getNotificationsByEventId(@RequestBody EventIdDTO eventIdDTO) {
        try {
            Integer eventId = eventIdDTO.getEventId();
            if (eventId == null) {
                return ResponseEntity.badRequest().body("Event ID is missing in the request.");
            }

            List<Notification> notifications = notificationService.findAllNotificationsByEventId(eventId);
            
            if (notifications.isEmpty()) {
                return ResponseEntity.ok().body("No notifications found for the given event ID.");
            }

            return ResponseEntity.ok(notifications);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving notifications: " + e.getMessage());
        }
    }

}
