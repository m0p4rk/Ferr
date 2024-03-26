package com.warr.ferr.api;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
    // Logger 인스턴스 생성
    private static final Logger logger = LoggerFactory.getLogger(UserAPI.class);

    public UserAPI(UserService userService) {
        this.userService = userService;
    }

    // 사용자 닉네임으로 검색
    @GetMapping("/search")
    public ResponseEntity<List<Users>> searchByNickname(@RequestParam("nickname") String nickname) {
        logger.info("Searching users by nickname: {}", nickname); // 검색 시작 로깅
        List<Users> users = userService.searchByNickname(nickname);
        if (users.isEmpty()) {
            logger.info("No users found with nickname: {}", nickname); // 검색 결과 없음 로깅
            return ResponseEntity.noContent().build();
        }
        logger.info("Found {} users with nickname: {}", users.size(), nickname); // 검색 결과 로깅
        return ResponseEntity.ok(users);
    }
}
