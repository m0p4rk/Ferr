package com.warr.ferr.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.warr.ferr.dto.UserDto;
import com.warr.ferr.mapper.UserMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

    @Autowired
    UserMapper userMapper;

    // 로그인 기능
    public UserDto loginUser(HttpServletRequest request, String email, String password) {
        Map<String, String> map = new HashMap<String, String>();
        map.put("email", email);
        map.put("password", password);
        System.out.println("email : " + email);
        System.out.println("password : " + password);
        UserDto userDto = userMapper.loginUser(map);

        if (userDto != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", userDto); // 세션에 사용자 정보 저장
        }

        return userDto;
    }
    
    // 회원가입 기능
    public int insertUser(UserDto userDto) {
        return userMapper.insertUser(userDto);
    }
}
