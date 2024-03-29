package com.warr.ferr.api;

import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.warr.ferr.model.EventNotification;
import com.warr.ferr.service.EventNotificationService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class EventNotificationAPI {

    private final EventNotificationService eventNotificationService;

    // 사용자의 모든 알림 조회
    @GetMapping
    public ResponseEntity<List<EventNotification>> getAllNotifications(HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId"); // 세션에서 userId 추출
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build(); // userId가 세션에 없으면 401 Unauthorized 응답
        }
        List<EventNotification> notifications = eventNotificationService.findAllNotificationsByUserId(userId);
        return ResponseEntity.ok(notifications);
    }

    // 사용자별 숨김 처리되지 않은 알림 조회
    @GetMapping("/visible")
    public ResponseEntity<List<EventNotification>> getVisibleNotifications(HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("Session UserId: " + userId); // 사용자 ID 출력
        
        if (userId == null) {
            System.out.println("Unauthorized access attempt."); // 비인증 접근 시도 메시지 출력
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        List<EventNotification> visibleNotifications = eventNotificationService.findVisibleNotificationsForUser(userId, session);
        System.out.println("Number of visible notifications: " + visibleNotifications.size()); // 반환되는 알림의 수 출력
        
        return ResponseEntity.ok(visibleNotifications);
    }



    // 알림 숨기기 요청 처리
    @PostMapping("/hide/{notificationId}")
    public ResponseEntity<Void> hideNotification(@PathVariable Integer notificationId, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId"); // 세션에서 userId 추출
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build(); // userId가 세션에 없으면 401 Unauthorized 응답
        }
        eventNotificationService.hideNotificationForUser(notificationId, session);
        return ResponseEntity.ok().build();
    }
}
