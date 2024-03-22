package com.warr.ferr.controller;

import java.util.List;
import java.util.Optional;

import com.warr.ferr.dto.ScheduleUpdateDto;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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

    // Note 내용은 Notification Controller에서 받고 Notification 객체 생성

    // Main -> Schedule List
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

    // Dashboard -> Schedule-Detail
    @GetMapping("/schedule-detail")
    public String scheduleDetail(@RequestParam("id") Integer eventId,
                                 Model model) {

        log.info("id={}", eventId);
        Optional<Schedule> optFindSchedule = scheduleService.findByEventId(eventId);
        log.info("optFindSchedule={}", optFindSchedule);

        if (optFindSchedule.isPresent()) {
            Schedule findSchedule = optFindSchedule.get();
            model.addAttribute("schedule", findSchedule);
        } else {
            return "error_page";
        }

        return "schedule_detail";
    }

    // Schedule-Detail -> Logic(Delete) -> Schedule List
    @GetMapping("/schedule-detail/delete/{eventId}")
    public String deleteSchedule(@PathVariable Integer eventId,
                                 Model model) {

        scheduleService.deleteSchedule(eventId);
        List<ScheduleListDto> callSchedules = scheduleService.findSchedules();
        log.info("callSchedules={}", callSchedules);
        model.addAttribute("schedules", callSchedules);

        return "dashboard_schedule"; // Sample Data 안쓸때부터 Redirect:/schedulelist로 변경
    }

    // Schedule-Detail -> Logic(Update : contentId, promiseDate) -> Schedule List
    @PostMapping("/schedule-detail/update/{eventId}")
    public String updateSchedule(@PathVariable Integer eventId,
                                 @ModelAttribute ScheduleUpdateDto scheduleUpdateDto,
                                 Model model) {

        log.info("eventId={}, scheduleUpdateDto={}", eventId, scheduleUpdateDto);
        scheduleService.updateSchedule(eventId, scheduleUpdateDto);

        List<ScheduleListDto> callSchedules = scheduleService.findSchedules();
        log.info("callSchedules={}", callSchedules);
        model.addAttribute("schedules", callSchedules);

        return "dashboard_schedule"; // Sample Data 안쓸때부터 Redirect:/schedulelist로 변경
    }

}

