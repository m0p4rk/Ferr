package com.warr.ferr.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.warr.ferr.dto.ScheduleUpdateDto;
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

//    // Event Detail -> Logic(Create) -> Schedule Detail(Feat. Update, Delete, Note, Group Manage, PathFinder, Review)
//    @PostMapping("/saveSchedule")
//    public String saveSchedule(@ModelAttribute("Schedule") Schedule schedule,
//                               HttpSession httpSession) {
//        scheduleService.saveSchedule(schedule, httpSession);
//        return "redirect:/schedule_detail";
//    }


    // Main -> Event Detail
    @GetMapping("/event-detail")
    public String moveEventDetail(@RequestParam("contentId") Integer contentId) {
        log.info("contentId={}", contentId);
        return "event_detail";
    }

    // Main -> Schedule List
    // Redirect : Schedule List
    @GetMapping("/dashboard-schedule")
    public String scheduleList(Model model) {

        List<ScheduleListDto> callSchedules = scheduleService.findSchedules();
        model.addAttribute("schedules", callSchedules);
        return "dashboard_schedule";
    }


    // Schedule List -> Schedule Detail(Feat. Update, Delete, Note, Group Manage, PathFinder, Review)
    @GetMapping("/schedule-detail")
    public String scheduleDetail(@RequestParam("id") Integer eventId,
                                 Model model) {

        Optional<Schedule> optFindSchedule = scheduleService.findByEventId(eventId);

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

        return "redirect:/dashboard-schedule";
    }

    // Schedule-Detail -> Logic(Update : contentId, promiseDate) -> Schedule List
    @PostMapping("/schedule-detail/update/{eventId}")
    public String updateSchedule(@PathVariable Integer eventId,
                                 @ModelAttribute ScheduleUpdateDto scheduleUpdateDto,
                                 Model model) {

        scheduleService.updateSchedule(eventId, scheduleUpdateDto);

        return "redirect:/dashboard-schedule";
    }
    
    // 행사위치 지도표시
    @GetMapping("/destination/{eventId}")
    public String getDestination(@PathVariable int eventId, Model model) {
    	Map<String, Double> locationInfo = scheduleService.getLatitudeLongitude(eventId); 
    	model.addAttribute("latitude", locationInfo.get("latitude"));
    	model.addAttribute("longitude", locationInfo.get("longitude"));
    	return "schedule_detail";
    	
    }
    
    
}



