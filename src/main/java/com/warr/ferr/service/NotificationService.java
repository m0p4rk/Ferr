package com.warr.ferr.service;

import com.warr.ferr.mapper.NotificationMapper;
import com.warr.ferr.model.Notification;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationMapper notificationMapper;

    public Notification createNotification(Notification notification, Integer userId) {
        // UserId가 유효한지 확인
        if (userId == null || userId == 0) {
            throw new IllegalArgumentException("Notification must have a valid userId");
        }

        // Notification 객체에 userId 설정
        notification.setUserId(userId);

        // Mapper를 통해 Notification 저장
        notificationMapper.createNotification(notification);
        
        // 저장된 Notification 객체(이제 ID 포함)를 반환
        return notification;
    }


    public void deleteNotificationById(int notificationId) {
        notificationMapper.deleteNotificationById(notificationId);
    }

    public List<Notification> findAllNotificationsByEventId(int eventId) {
        return notificationMapper.findAllNotificationsByEventId(eventId);
    }
    
    public List<Notification> findAllNotificationsByUserId(int userId) {
        return notificationMapper.findAllNotificationsByUserId(userId);
    }

 // 알림 업데이트 서비스 메서드
    public void updateNotification(Notification notification) {
        // Notification 객체 자체가 null인지 검증
        if (notification == null) {
            throw new IllegalArgumentException("Notification object cannot be null");
        }

        // NotificationId가 유효한지 확인 (여기서는 NotificationId의 타입이 Integer라고 가정)
        Integer notificationId = notification.getNotificationId();
        if (notificationId == null || notificationId == 0) {
            throw new IllegalArgumentException("Notification must have a valid notificationId");
        }

        // Mapper를 통해 Notification 업데이트
        notificationMapper.updateNotificationById(notification);
    }

}
