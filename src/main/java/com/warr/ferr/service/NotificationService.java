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

	public void createNotification(Notification notification, Integer userId) {
		// UserId가 유효한지 확인
		if (userId == null || userId == 0) {
			throw new IllegalArgumentException("Notification must have a valid userId");
		}

		// Notification 객체에 userId 설정
		notification.setUserId(userId);

		// Mapper를 통해 Notification 저장
		notificationMapper.createNotification(notification);
	}

	public void deleteNotificationById(int notificationId) {
		notificationMapper.deleteNotificationById(notificationId);
	}

	public List<Notification> findAllNotificationsByEventId(int eventId) {
		return notificationMapper.findAllNotificationsByEventId(eventId);
	}
}
