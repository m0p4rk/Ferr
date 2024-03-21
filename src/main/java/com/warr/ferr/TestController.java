package com.warr.ferr;

import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Slf4j
@Controller
public class TestController {
	@GetMapping("/")
	public String testhome() {
		return "main";
	}
	
	@GetMapping("/signup")
	public String testRegister() {
		return "register";
	}
	
	@GetMapping("/signup-social")
	public String testSocialRegister() {
		return "register_social";
	}
	
//	@GetMapping("/schedulelist")
//	public String testDashboardSchedule() {
//		return "dashboard_schedule";
//	}
	
	@GetMapping("/schedule-detail")
	public String testScheduleDetail() {
		return "schedule_detail";
	}
	
	@GetMapping("/search")
	public String testSearch() {
		return "search_result";
	}

	@GetMapping("/event-detail")
	public String testEventDetail(@Param("contentId") Integer contentId) {
		log.info("testEventDetail called with eventId: {}", contentId);
        return switch (contentId) {
            case 1 -> "event_detail"; // event-detail.jsp
            case 2 -> "event_detail2"; // event-detail2.jsp
            default -> "event_detail";
        };
	}
	
	@GetMapping("/my-page")
	public String testMyPage() {
		return "my_page";
	}
}
