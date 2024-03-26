package com.warr.ferr;

import lombok.extern.slf4j.Slf4j;
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
	
	@GetMapping("/search")
	public String testSearch() {
		return "search_result";
	}
	
	@GetMapping("/my-page")
	public String testMyPage() {
		return "my_page";
	}
	
	@GetMapping("/schedule-detail-sample")
	public String testCreateSchedule() {
	    return "create_schedule";
	}
	
	@GetMapping("/dashboard-schedule")
	public String testDashboardSchedule() {
	    return "dashboard_schedule_sample";
	}

	
}
