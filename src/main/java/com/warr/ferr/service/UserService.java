package com.warr.ferr.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.warr.ferr.mapper.UserMapper;
import com.warr.ferr.model.UserPreferences;
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

    // 채팅에서 사용중: 유저 검색 리스트 생성(본인제외 모든유저)
	public List<Users> searchUser(int userId) {
	List<Users> userList = userMapper.findAllUser();
	List<Users> searchUser = new ArrayList<>();
	
	for (int i = 0; i < userList.size(); i++) {
		if(userList.get(i).getUserId() != userId) {
			searchUser.add(userList.get(i));
		}
	}
	return searchUser;
	}
	// 채팅에서 사용중: userId로 user검색
	public Users findUserById(int userId) {
		return userMapper.findUserByUserId(userId);
	}

	public int getUserIdByEmail(String email) {
		// 이메일로 사용자 정보 가져오기
		int user = -1;
		user = userMapper.getUserByEmail(email);

		return user;
	}

	public UserPreferences getUserPreferences(int userId) {
		System.out.println("service sending" + userMapper.getUserPreferences(userId));
		return userMapper.getUserPreferences(userId);
	}

	public void saveUserPreferences(UserPreferences preferences) {
		userMapper.saveUserPreferences(preferences);
	}

	public void updateUserPreferences(UserPreferences preferences) {
		userMapper.updateUserPreferences(preferences);
	}
	// 채팅에서 임시로 사용
//	public List<Users> findUserByRoomId(int chatroomId) {
//		List<Users> allUsers = userMapper.findUserByRoomId(chatroomId);
//		List<Users> chatroomUsers = new ArrayList<>();
//		for (int i = 0; i < allUsers.size(); i++) {
//			if(allUsers.get(i).)
//		}
//		
//        return ;
//    }

	public int getUserRegionPreference(int userId) {
	    try {
	        UserPreferences preferences = userMapper.getUserPreferences(userId);
	        System.out.println("preferences list: " + preferences);

	        // preferences 객체가 null이 아니면 선호 지역 반환, null이면 기본값 반환
	        if (preferences != null) {
	            return preferences.getPreferredLocation();
	        } else {
	            // 기본값으로 설정할 선호 지역 ID. 예를 들어, '0'이 기본값일 수 있습니다.
	            return 0; 
	        }
	    } catch (Exception e) {
	        // 예외 발생 시 스택 트레이스를 콘솔에 출력
	        e.printStackTrace();
	        // 예외 발생 시 기본값 반환 또는 적절한 예외 처리를 수행
	        return 0;
	    }
	}
	public List<Users> searchByNickname(String nickname) {
        return userMapper.findByNickname(nickname);
    }

	// 3/31 3:25 am 추가 닉네임 출력기능
	public String findNicknameByUserId(int userId) {
		return userMapper.findNicknameByUserId(userId);
	}

}
