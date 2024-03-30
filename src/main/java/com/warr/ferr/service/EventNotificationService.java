package com.warr.ferr.service;

import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.warr.ferr.mapper.EventNotificationMapper;
import com.warr.ferr.model.EventNotification;
import com.warr.ferr.model.EventParticipant;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class EventNotificationService {

    private final EventNotificationMapper eventNotificationMapper;
    private final EventParticipantService eventParticipantService;

    // 숨김 처리된 알림 ID를 세션에 추가
    @SuppressWarnings("unchecked")
    public void hideNotificationForUser(Integer notificationId, HttpSession session) {
        // hiddenNotifications 집합을 최초 한 번만 초기화
        Set<Integer> hiddenNotifications = (Set<Integer>) session.getAttribute("hiddenNotifications");
        if (hiddenNotifications == null) {
            hiddenNotifications = new HashSet<>();
            session.setAttribute("hiddenNotifications", hiddenNotifications);
        }
        hiddenNotifications.add(notificationId);
    }

    // 사용자별 숨김 처리되지 않은 알림 조회
    @SuppressWarnings("unchecked")
    public List<EventNotification> findVisibleNotificationsByUserId(Integer userId, HttpSession session) {
        // effectively final 문제를 해결하기 위해 새로운 final 변수에 할당
        final Set<Integer> hiddenNotifications;
        if (session.getAttribute("hiddenNotifications") != null) {
            hiddenNotifications = (Set<Integer>) session.getAttribute("hiddenNotifications");
        } else {
            hiddenNotifications = Collections.emptySet();
        }

        List<EventNotification> allNotifications = eventNotificationMapper.findAllEventsAndNotificationsByUserId(userId);
        return allNotifications.stream()
                .filter(notification -> !hiddenNotifications.contains(notification.getNotificationId()))
                .collect(Collectors.toList());
    }

    // 사용자 ID에 따라 모든 알림을 조회
    public List<EventNotification> findAllNotificationsByUserId(Integer userId) {
        return eventNotificationMapper.findAllEventsAndNotificationsByUserId(userId);
    }

    // 스케줄된 알림 전송
    @Scheduled(cron = "0 * * * * *") // 매분 실행, 실제로는 요구사항에 맞게 조정
    public void sendScheduledNotifications() {
        List<EventNotification> dueNotifications = eventNotificationMapper.findDueNotifications(new Date());
        dueNotifications.forEach(this::sendNotification);
    }

    private void sendNotification(EventNotification notification) {
        // 알림 전송 로직, 예: 이메일, SMS, 푸시 알림 등
        System.out.println("Sending notification: " + notification);
    }
    
    public List<EventNotification> findVisibleNotificationsForUser(Integer userId, HttpSession session) {
        System.out.println("Checking visible notifications for user: " + userId);
        
        List<EventNotification> allVisibleNotifications = findVisibleNotificationsByUserId(userId, session);
        System.out.println("Total visible notifications before filtering: " + allVisibleNotifications.size());
        
        List<EventNotification> filteredNotifications = allVisibleNotifications.stream()
            .filter(notification -> {
                System.out.println("Checking event participants for event: " + notification.getEventId());
                List<EventParticipant> participants = eventParticipantService.getParticipantsByEvent(notification.getEventId());
                boolean isUserParticipant = participants.stream()
                                                        .anyMatch(participant -> participant.getUserId() == userId);
                System.out.println("Is user a participant for event " + notification.getEventId() + ": " + isUserParticipant);
                return isUserParticipant;
            })
            .collect(Collectors.toList());

        System.out.println("Total visible notifications after filtering: " + filteredNotifications.size());
        return filteredNotifications;
    }


}
