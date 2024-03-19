package com.warr.ferr.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.warr.ferr.api.KakaoAPI;
import com.warr.ferr.dto.UserDto;
import com.warr.ferr.model.UserPreferences;
import com.warr.ferr.model.UserPreferences.AdmissionFeePreference;
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
		if (userInfo.get("email") != null) {
			// 카카오 사용자 정보를 기반으로 사용자 로그인 또는 등록 처리
			userService.loginOrRegisterKakaoUser(userInfo);
			// 이메일을 기반으로 사용자 ID를 조회
			Integer userId = userService.findUserIdByEmail(userInfo.get("email").toString());
			HttpSession session = request.getSession(true);
			session.setAttribute("nickname", userInfo.get("nickname")); // 닉네임
			session.setAttribute("userId", userId); // 사용자 ID 세션에 저장
			session.setAttribute("access_token", accessToken); // 카카오 액세스 토큰도 세션에 저장
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
	@GetMapping("/preferences")
	public String showPreferencesForm(Model model, HttpSession session) {
		
		// 세션에서 사용자 ID 가져오기
		Integer userId = (Integer) session.getAttribute("userId");
		
		// 사용자 ID로 선호 사항 불러오기
		UserPreferences preferences = userService.getUserPreferences(userId);

		// 불러온 선호 사항 확인

		model.addAttribute("preferences", preferences);
		return "my-page";
	}


	@PostMapping("/savePreferences")
	public String savePreferences(@RequestParam("regionPreference") String regionPreference,
	                              @RequestParam("midCategory") String midCategory,
	                              @RequestParam(value = "subCategory", required = false) List<String> subCategories,
	                              HttpSession session) {
	    
	    // 세션에서 사용자 ID 가져오기
	    Integer userId = (Integer) session.getAttribute("userId");
	    
	    // 선호 설정을 담을 새로운 UserPreferences 객체 생성
	    UserPreferences newPreferences = new UserPreferences();
	    
	    // userId 설정
	    newPreferences.setUserId(userId);
	    
	    newPreferences.setAdmissionFeePreference(AdmissionFeePreference.ALL);
	    
	    // 선호 지역 설정
	    newPreferences.setPreferredLocation(regionPreference);
	    
	    // 대분류 설정은 고정값으로 설정 (인문)
	    newPreferences.setCategoryCodeLarge("A02");
	    
	    // 중분류 설정
	    newPreferences.setCategoryCodeMedium(midCategory);
	    
	    // 소분류 설정
	    if (subCategories != null && !subCategories.isEmpty()) {
	        // 여러 개의 소분류를 하나의 문자열로 합침
	        String combinedSubCategories = String.join(",", subCategories);
	        newPreferences.setCategoryCodeSmall(combinedSubCategories);
	    } else {
	        newPreferences.setCategoryCodeSmall(""); // 빈 문자열로 설정
	    }
	    
	    // 기존 선호 설정 불러오기
	    UserPreferences oldPreferences = userService.getUserPreferences(userId);

	    // 만약 기존 선호 설정이 null이 아니고, 새로운 설정과 다르다면 업데이트
	    if(oldPreferences == null) {    
	        // 설정 저장
	        userService.saveUserPreferences(newPreferences);
	    } else {
	        // 기존선호설정이 null이 아닌 경우 -> 한번이라도 설정한 경우
	        // 업데이트
	        userService.updateUserPreferences(newPreferences);
	    }

	    return "redirect:/my-page";
	}
}
