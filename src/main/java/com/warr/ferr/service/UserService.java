package com.warr.ferr.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.warr.ferr.mapper.UserMapper;
import com.warr.ferr.model.Users;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserMapper userMapper, PasswordEncoder passwordEncoder) {
        this.userMapper = userMapper;
        this.passwordEncoder = passwordEncoder;
    }
    
    public Integer findUserIdByEmail(String email) {
    	Integer userId = userMapper.findUserIdByEmail(email);
    	return userId;
    }

    public Users loginUser(HttpServletRequest request, String email, String password) {
        Users user = userMapper.loginUser(email);
        if (user != null && passwordEncoder.matches(password, user.getPassword())) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            return user;
        }
        return null;
    }

    public int registerUser(Users user) {
        // 사용자 객체의 비밀번호를 인코딩하여 저장
        String encodedPassword = passwordEncoder.encode(user.getPassword());
        user.setPassword(encodedPassword);
        // 기존 사용자가 있는지 확인 후 없으면 삽입
        Users existingUser = userMapper.loginUser(user.getEmail());
        if (existingUser == null) {
            return userMapper.insertUser(user);
        } else {
            return 0; // 이미 존재하는 사용자
        }
    }

    public void loginOrRegisterKakaoUser(String email, String accessToken) {
        Users existingUser = userMapper.loginUser(email);
        if (existingUser == null) {
            // 이메일에 해당하는 사용자가 없으면 새로 추가
            Users newUser = new Users();
            newUser.setEmail(email);
            // 이메일에서 닉네임 추출 (이메일 앞부분을 닉네임으로 사용)
            String nickname = email.substring(0, email.indexOf('@'));
            newUser.setNickname(nickname);
            newUser.setKakaoId(accessToken); // 카카오 로그인 시 비밀번호는 사용하지 않으므로, 토큰을 저장 / 토큰 해싱 처리 고려
            userMapper.insertUser(newUser);
        } else {
            // 기존 사용자가 있으면 카카오 ID만 업데이트
            existingUser.setKakaoId(accessToken);
            userMapper.updateUser(existingUser);
        }
    }


}
