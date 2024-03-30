package com.warr.ferr.controller;

import java.math.BigDecimal;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.model.Notification;
import com.warr.ferr.model.Schedule;
import com.warr.ferr.service.NotificationService;
import com.warr.ferr.service.ScheduleService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ScheduleController {

    private final ScheduleService scheduleService;
    private final NotificationService notificationService;

    /**
     * 이벤트 상세 페이지로 이동
     */
    @GetMapping("/event-detail")
    public String moveEventDetail(@RequestParam("contentId") Integer contentId, Model model) {
        log.info("Moving to Event Detail Page, contentId={}", contentId);
        model.addAttribute("contentId", contentId);
        return "event_detail";
    }

    /**
     * 스케줄 목록 페이지 조회
     */
    @GetMapping("/dashboard-schedule")
    public String scheduleList(Model model) {
        List<ScheduleListDto> schedules = scheduleService.findAllSchedules();
        model.addAttribute("schedules", schedules);
        return "dashboard_schedule";
    }

    /**
     * 스케줄 상세 페이지 조회
     */
    @GetMapping("/schedule-detail")
    public String scheduleDetail(@RequestParam("id") Integer eventId, Model model) {
        Schedule schedule = scheduleService.findByEventId(eventId);

        if (schedule != null) {
            model.addAttribute("schedule", schedule);
            List<Notification> notifications = notificationService.findAllNotificationsByEventId(eventId);
            model.addAttribute("notifications", notifications);
        } else {
            log.warn("Schedule not found, eventId={}", eventId);
            return "error_page";
        }

        return "schedule_detail";
    }

    /**
     * 스케줄 삭제 후 스케줄 목록 페이지로 리다이렉트
     */
    @GetMapping("/schedule-detail/delete/{eventId}")
    public String deleteSchedule(@PathVariable Integer eventId) {
        scheduleService.deleteSchedule(eventId);
        return "redirect:/dashboard-schedule";
    }

    /**
     * 스케줄 업데이트 후 스케줄 목록 페이지로 리다이렉트
     */
    @PostMapping("/schedule-detail/update/date/{eventId}")
    public String updateScheduleDate(@PathVariable Integer eventId, 
                                     @RequestParam("promiseDate") String promiseDateString) {
        try {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date parsedDate = format.parse(promiseDateString);
            Date sqlDate = new Date(parsedDate.getTime());

            scheduleService.updateScheduleDate(eventId, sqlDate);
            return "redirect:/dashboard-schedule";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/error"; // 적절한 에러 처리 페이지로 리다이렉트
        }
    }
    
    // 축제위치 DB -> JS
    @GetMapping("/destination/{eventId}")
    @ResponseBody // JSON 형식으로 응답
    public ResponseEntity<Map<String, BigDecimal>> getDestination(@PathVariable int eventId, Model model) {
        Map<String, BigDecimal> locationInfo = scheduleService.getLatitudeLongitude(eventId); 
        return ResponseEntity.ok().body(locationInfo);
    }

    
    
    
    
}
