package com.warr.ferr;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

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

	@GetMapping("/event-detail")
	public String testEventDetail(@RequestParam("contentId") Integer contentId) {
		log.info("testEventDetail called with eventId: {}", contentId);
        return switch (contentId) {
            case 1 -> "event_detail"; // event-detail.jsp
            case 2 -> "event_detail2"; // event-detail2.jsp
            default -> "event_detail";
        };
//		return "event_detail";
	}
	
	@GetMapping("/my-page")
	public String testMyPage() {
		return "my_page";
	}
}
