package com.warr.ferr.controller;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.warr.ferr.api.KakaoAPI;
import com.warr.ferr.dto.UserDto;
import com.warr.ferr.model.UserPreferences;
import com.warr.ferr.model.Users;
import com.warr.ferr.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

	private final UserService userService;
	private final KakaoAPI kakaoApi;

	public UserController(UserService userService, KakaoAPI kakaoApi) {
		this.userService = userService;
		this.kakaoApi = kakaoApi;
	}

	// 일반 로그인 처리
	@RequestMapping(value = "/login", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView login(HttpServletRequest request, @RequestParam(required = false) String email,
			@RequestParam(required = false) String password, @RequestParam(required = false) String code) {
		ModelAndView mv = new ModelAndView();

		if (code != null) {
			return handleKakaoLogin(code, request);
		} else if (email != null && password != null) {
			return handleNormalLogin(email, password, request);
		} else {
			mv.setViewName("login");
			// 에러 메세지 보내야함
		}

		return mv;
	}

	private ModelAndView handleNormalLogin(String email, String password, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		var user = userService.loginUser(request, email, password);
		
		if (user != null) {
			HttpSession session = request.getSession(true);
			session.setAttribute("userEmail", user.getEmail()); // 이메일
			session.setAttribute("userId", user.getUserId()); // 사용자 ID 세션에 저장
			int regionPreference = userService.getUserRegionPreference((Integer)session.getAttribute("userId"));
			session.setAttribute("regionPreference", regionPreference);
			
			mv.setViewName("redirect:/");
		} else {
			mv.setViewName("login");
			mv.addObject("errorMessage", "Login failed: Incorrect email or password.");
		}
		return mv;
	}

	private ModelAndView handleKakaoLogin(String code, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		String accessToken = kakaoApi.getAccessToken(code);
		HashMap<String, Object> userInfo = kakaoApi.getUserInfo(accessToken);
		System.out.println(userInfo);
		if (userInfo.get("email") != null) {
			// 카카오 사용자 정보를 기반으로 사용자 로그인 또는 등록 처리
			userService.loginOrRegisterKakaoUser(userInfo);
			// 이메일을 기반으로 사용자 ID를 조회
			Integer userId = userService.findUserIdByEmail(userInfo.get("email").toString());
			
			HttpSession session = request.getSession(true);
			session.setAttribute("nickname", userInfo.get("nickname")); // 닉네임
			session.setAttribute("userId", userId); // 사용자 ID 세션에 저장
			System.out.println("userId status" + session.getAttribute("userId"));
			session.setAttribute("profileImageUrl", userInfo.get("profileImageUrl"));
			session.setAttribute("access_token", accessToken); // 카카오 액세스 토큰도 세션에 저장
			session.setAttribute("regionPreference", userService.getUserRegionPreference(userId) );
			System.out.println("login session value" + session.getAttribute("regionPreference"));
			mv.setViewName("redirect:/");
		} else {
			mv.setViewName("login");
			mv.addObject("errorMessage", "Kakao login failed.");
		}
		return mv;
	}

	@PostMapping("/register")
	public ModelAndView registerUser(HttpServletRequest request, UserDto userDto) {
		ModelAndView mv = new ModelAndView();

		// UserDto를 Users 객체로 변환
		Users user = new Users();
		user.setEmail(userDto.getEmail());
		user.setPassword(userDto.getPassword()); // 비밀번호는 서비스 계층에서 인코딩
		user.setNickname(userDto.getNickname());

		// UserService를 이용해 Users 객체 저장
		int success = userService.registerUser(user);

		if (success == 1) {
			HttpSession session = request.getSession(true);
			session.setAttribute("userId", user.getUserId());
			session.setAttribute("nickname", user.getNickname());
			session.setAttribute("userEmail", user.getEmail());
			mv.setViewName("redirect:/");
		} else {
			mv.addObject("registerError", "Registration failed. Please try again.");
			mv.setViewName("register");
		}
		return mv;
	}

	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			// 카카오 로그인을 통한 로그아웃 처리
			String accessToken = (String) session.getAttribute("access_token");
			if (accessToken != null) {
				kakaoApi.kakaoLogout(accessToken);
				session.removeAttribute("access_token"); // 카카오 액세스 토큰 세션에서 제거
			}
			session.invalidate(); // 애플리케이션 세션 무효화
		}
		return "redirect:/";
	}

	@GetMapping("/register")
	public String registerPage() {
		return "register";
	}

	 // my-page
//	@GetMapping("/preferences")
//	public String showPreferencesForm(Model model, HttpSession session) {
//		
//		// 세션에서 사용자 ID 가져오기
//		Integer userId = (Integer) session.getAttribute("userId");
//		
//		// 사용자 ID로 선호 사항 불러오기
//		UserPreferences preferences = userService.getUserPreferences(userId);
//		int regionPreference = userService.getUserRegionPreference(userId);
//
//		model.addAttribute("preferences", preferences);
//		model.addAttribute("regionPreference", regionPreference);
//		return "my-page";
//	}


	@PostMapping("/savePreferences")
	public String savePreferences(@RequestParam("regionPreference") int regionPreference, HttpSession session) {
	    
	    // 세션에서 사용자 ID 가져오기
	    Integer userId = (Integer) session.getAttribute("userId");
	    
	    // 선호 설정을 담을 새로운 UserPreferences 객체 생성
	    UserPreferences newPreferences = new UserPreferences();
	    
	    // userId 설정
	    newPreferences.setUserId(userId);
	    
	    // 선호 지역 설정
	    newPreferences.setPreferredLocation(regionPreference);
	    
	    System.out.println("regionPreference 값: " + regionPreference);
	    
	    // 세션에 regionPreference 값 저장하기
	    session.setAttribute("regionPreference", regionPreference);
	    
	    // 기존 선호 설정 불러오기
	    UserPreferences oldPreferences = userService.getUserPreferences(userId);

	    // 만약 기존 선호 설정이 null이 아니고, 새로운 설정과 다르다면 업데이트
	    if(oldPreferences != null && !oldPreferences.equals(newPreferences)) {    
	        userService.updateUserPreferences(newPreferences);
	    } else if(oldPreferences == null) {
	        userService.saveUserPreferences(newPreferences);
	    }

	    return "redirect:/my-page";
	}

}
