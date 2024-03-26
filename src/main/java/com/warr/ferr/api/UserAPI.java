package com.warr.ferr.api;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.warr.ferr.model.Users;
import com.warr.ferr.service.UserService;

@RestController
@RequestMapping("/api/users")
public class UserAPI {

    private final UserService userService;

    public UserAPI(UserService userService) {
        this.userService = userService;
    }

    // 사용자 닉네임으로 검색
    @GetMapping("/search")
    public ResponseEntity<List<Users>> searchByNickname(@RequestParam("nickname") String nickname) {
        List<Users> users = userService.searchByNickname(nickname);
        if (users.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(users);
    }
}
