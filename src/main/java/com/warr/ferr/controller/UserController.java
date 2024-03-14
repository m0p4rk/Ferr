package com.warr.ferr.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.warr.ferr.api.KakaoAPI;
import com.warr.ferr.dto.UserDto;
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
	@RequestMapping(value = "/login", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView login(HttpServletRequest request,
                              @RequestParam(required = false) String email,
                              @RequestParam(required = false) String password,
                              @RequestParam(required = false) String code) {
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
        var userInfo = kakaoApi.getUserInfo(accessToken);
        if (userInfo.get("email") != null) {
            userService.loginOrRegisterKakaoUser(userInfo.get("email").toString(), accessToken);
            var userId = userService.findUserIdByEmail(userInfo.get("email").toString());
            HttpSession session = request.getSession(true);
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
}
