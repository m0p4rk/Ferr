package com.warr.ferr.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.warr.ferr.model.Users;
import com.warr.ferr.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;


@Controller
public class UserController {

    @Autowired
    UserService userService;

    
    // 로그인 페이지
    @GetMapping("/login")
    public String loginForm(HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            return "redirect:/main";
        }
        return "main";
    }

    // 로그인 처리
    @PostMapping("/login")
    public ModelAndView loginUser(HttpServletRequest request, String email, String password) {
        Users user = userService.loginUser(request, email, password);

        ModelAndView mv = new ModelAndView();
        if (user != null) {
            HttpSession session = request.getSession();
            System.out.println("user DTO : " + user);
            session.setAttribute("user", user);
            mv.setViewName("redirect:/");
        } else {
            mv.setViewName("register");
            mv.addObject("error", "Invalid email or password");
        }
        return mv;
    }

    // 회원가입 페이지
    @GetMapping("/register")
    public String registrationForm(HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            return "redirect:/main";
        }
        return "register";
    }

    // 회원가입 처리
    @PostMapping("/register")
    public ModelAndView insertUser(Users user) {
        int result = userService.insertUser(user);

        ModelAndView mv = new ModelAndView();
        mv.setViewName("register");
        mv.addObject("result", result);

        return mv;
    }

    // 로그아웃 처리
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.removeAttribute("user"); 
        return "redirect:/";
    }
    
    // 세션 확인
    @GetMapping("/checkSession")
    public ModelAndView checkSession(HttpServletRequest request) {
		HttpSession session = request.getSession();
		boolean sessionExists = (session.getAttribute("user") != null);
		ModelAndView mv = new ModelAndView();
		mv.addObject("sessionExists", sessionExists);
		return mv;
	}
}
