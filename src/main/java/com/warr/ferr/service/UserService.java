package com.warr.ferr.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.warr.ferr.model.Users;
import com.warr.ferr.mapper.UserMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

    @Autowired
    UserMapper userMapper;

    // 로그인 기능
    public Users loginUser(HttpServletRequest request, String email, String password) {
        Map<String, String> map = new HashMap<String, String>();
        map.put("email", email);
        map.put("password", password);
        System.out.println("email : " + email);
        System.out.println("password : " + password);
        Users user = userMapper.loginUser(map);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user); // 세션에 사용자 정보 저장
        }

        return user;
    }
    
    // 회원가입 기능
    public int insertUser(Users user) {
        return userMapper.insertUser(user);
    }
}
