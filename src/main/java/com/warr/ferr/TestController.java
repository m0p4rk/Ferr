package com.warr.ferr;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

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
	
	@GetMapping("/schedulelist")
	public String testDashboardSchedule() {
		return "dashboard_schedule";
	}
	
	@GetMapping("/schedule-detail")
	public String testScheduleDetail() {
		return "schedule_detail";
	}
}
