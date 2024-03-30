package com.warr.ferr.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.warr.ferr.model.Notification;
import com.warr.ferr.service.NotificationService;
import org.springframework.web.server.ResponseStatusException;

@RestController
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    @PostMapping("/newNotification")
    public ResponseEntity<?> newNotification(@RequestBody Notification notification,
                                             @SessionAttribute("userId") Integer userId) {
        try {
            notification.setUserId(userId); // Optional: 세션에서 가져온 userId 설정
            Notification createdNotification = notificationService.createNotification(notification, userId);
            System.out.println("Received notification: " + notification);// 수정된 부분
            return ResponseEntity.ok(createdNotification);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid date", e);
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error creating notification(Internal Server Error): ", e);
        }
    }


    @PostMapping("/notification/delete/{notificationId}")
    public ResponseEntity<?> deleteNotification(@PathVariable("notificationId") Integer notificationId) {
        try {
            notificationService.deleteNotificationById(notificationId);
            return ResponseEntity.ok("Notification deleted successfully.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error deleting notification: " + e.getMessage());
        }
    }

    @PostMapping("/notification/update")
    public ResponseEntity<?> updateNotification(@RequestBody Notification notification) {
        try {
            // 여기서는 notification 객체에 userId를 설정할 필요가 없습니다.
            // 이미 기존에 있는 notification의 id를 기반으로 업데이트하므로
            notificationService.updateNotification(notification);
            return ResponseEntity.ok("Notification updated successfully.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error updating notification: " + e.getMessage());
        }
    }
}
