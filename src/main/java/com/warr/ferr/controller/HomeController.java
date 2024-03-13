package com.warr.ferr.controller;

import java.util.HashMap;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController {

	private final KakaoAPI kakaoApi;
	
	@Autowired
	public HomeController(KakaoAPI kakaoApi) {
        this.kakaoApi = kakaoApi;
    }
	
    @RequestMapping(value = "/login")
    public ModelAndView login(@RequestParam("code") String code, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        
        System.out.println("login call!");
        // 1번 인증코드 요청 전달
        String accessToken = kakaoApi.getAccessToken(code);
        System.out.println("accessToken! : " + accessToken);
        // 2번 인증코드로 토큰 전달
        HashMap<String, Object> userInfo = kakaoApi.getUserInfo(accessToken);
        System.out.println("userInfo! : " + userInfo.size());
        System.out.println("login info : " + userInfo.toString());

        if (userInfo.get("email") != null) {
            session.setAttribute("userId", userInfo.get("email"));
            session.setAttribute("access_token", accessToken);
        }
        mav.addObject("userId", userInfo.get("email"));
        mav.setViewName("index");
        return mav;
    }

    @RequestMapping(value = "/logout")
    public ModelAndView logout(HttpSession session) {
        ModelAndView mav = new ModelAndView();

        kakaoApi.kakaoLogout((String) session.getAttribute("access_token")); // 세션 키 값 수정
        session.removeAttribute("access_token"); // 세션 키 값 수정
        session.removeAttribute("userId");
        mav.setViewName("index");
        return mav;
    }
}