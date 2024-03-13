package com.warr.ferr.service;

import com.warr.ferr.mapper.UserMapper;
import com.warr.ferr.model.Users;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserMapper usermapper;

    public void saveUserInfo(String email, String nickname) {
        Users user = new Users();
        user.setEmail(email);
        user.setNickname(nickname);
        user.setRealName(nickname); 

        //userRepository.save(user);
        int result = usermapper.kakaoUsers(user);
        
        System.out.println("result : " + result);
    }
}
