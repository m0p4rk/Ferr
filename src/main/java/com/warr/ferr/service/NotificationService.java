package com.warr.ferr.service;

import com.warr.ferr.mapper.NotificationMapper;
import com.warr.ferr.model.Notification;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationMapper notificationMapper;

    public void createNotification(Notification notification,
                                   HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        if (session != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            notification.setUserId(userId);
        } else {
            log.warn("경고 : Session 만료 상태로 알림 저장 시도");
        }
        notificationMapper.createNotification(notification);
    }

    public void deleteNotificationById(Integer id) {
        notificationMapper.deleteNotificationById(id);
    }

    Optional<Notification> findNotificationByEventId(Integer id) {
        return notificationMapper.findNotificationByEventId(id);
    }

    public List<Notification> findAllNotificationsByEventId(Integer id) {
        return notificationMapper.findAllNotificationsByEventId(id);
    }

}
