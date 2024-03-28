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
	
	@GetMapping("/search")
	public String testSearch() {
		return "search_result";
	}
	
	@GetMapping("/my-page")
	public String testMyPage() {
		return "my_page";
	}
	
}
