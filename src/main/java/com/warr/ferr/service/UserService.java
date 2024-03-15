package com.warr.ferr.service;

import java.util.HashMap;
import java.util.List;

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
            session.setAttribute("nickname", user.getNickname());
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

    public void loginOrRegisterKakaoUser(HashMap<String, Object> userInfo) {
        String email = userInfo.get("email").toString();
        Long kakaoId = (Long) userInfo.get("kakaoId");
        String profileImageUrl = userInfo.get("profileImageUrl").toString();
        String nickname = userInfo.get("nickname").toString();

        Users existingUser = userMapper.loginUser(email);
        if (existingUser == null) {
            // 이메일에 해당하는 사용자가 없으면 새로 추가
            Users newUser = new Users();
            newUser.setEmail(email);
            newUser.setNickname(nickname); // 카카오 API에서 받은 닉네임 사용
            newUser.setKakaoId(String.valueOf(kakaoId)); // 카카오 고유 ID 저장
            newUser.setProfileImageUrl(profileImageUrl); // 프로필 이미지 URL 저장
            // 카카오 로그인 시 비밀번호는 사용하지 않으므로 비밀번호 필드는 설정하지 않음
            userMapper.insertUser(newUser);
        } else {
            // 기존 사용자가 있으면 정보 업데이트
            existingUser.setKakaoId(String.valueOf(kakaoId));
            existingUser.setProfileImageUrl(profileImageUrl);
            existingUser.setNickname(nickname);
            userMapper.updateUser(existingUser);
        }
    }

    // 채팅에서 임시로 사용중
	public List<Users> findAllUser(Object userId) {
			
	List<Users> userList = userMapper.findAllUser(userId);
	
	return userList;
	}

}
