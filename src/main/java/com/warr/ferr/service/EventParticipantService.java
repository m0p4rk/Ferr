package com.warr.ferr.service;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.warr.ferr.mapper.EventParticipantMapper;
import com.warr.ferr.model.EventParticipant;

@Service
public class EventParticipantService {

    private final EventParticipantMapper eventParticipantMapper;

    public EventParticipantService(EventParticipantMapper eventParticipantMapper) {
        this.eventParticipantMapper = eventParticipantMapper;
    }

    @Transactional
    public void addParticipant(EventParticipant eventParticipant) {
        eventParticipantMapper.insert(eventParticipant);
    }

    // 여러 참가자를 추가하는 메서드
    @Transactional
    public void saveParticipants(int eventId, List<Integer> participantUserIds) {
        for (Integer userId : participantUserIds) {
            EventParticipant eventParticipant = new EventParticipant();
            eventParticipant.setEventId(eventId);
            eventParticipant.setUserId(userId);
            // 추가적인 참가자 정보 설정이 필요한 경우 여기에 코드 추가
            addParticipant(eventParticipant);
        }
    }
    
    public void saveParticipantsWithDefaultStatus(int eventId, List<Integer> participantUserIds, String defaultStatus) {
        for (Integer userId : participantUserIds) {
            EventParticipant eventParticipant = new EventParticipant();
            eventParticipant.setEventId(eventId);
            eventParticipant.setUserId(userId);
            eventParticipant.setStatus(defaultStatus); // 기본 상태 설정
            // 현재 시간을 joinedAt으로 설정
            eventParticipant.setJoinedAt(new Timestamp(System.currentTimeMillis()));
            eventParticipantMapper.insert(eventParticipant);; // 데이터베이스에 삽입
        }
    }

    @Transactional(readOnly = true)
    public EventParticipant getParticipant(int eventId, int userId) {
        return eventParticipantMapper.selectByEventIdAndUserId(eventId, userId);
    }

    @Transactional(readOnly = true)
    public List<EventParticipant> getParticipantsByEvent(int eventId) {
        List<EventParticipant> participants = eventParticipantMapper.selectByEventId(eventId);
        System.out.println("Event ID: " + eventId + " has participants: ");
        for (EventParticipant participant : participants) {
            System.out.println("Participant ID: " + participant.getUserId());
        }
        return participants;
    }


    @Transactional
    public void updateParticipantStatus(int eventId, int userId, String status) {
        eventParticipantMapper.updateStatusByEventIdAndUserId(eventId, userId, status);
    }

    @Transactional
    public void removeParticipant(int eventId, int userId) {
        eventParticipantMapper.deleteByEventIdAndUserId(eventId, userId);
    }
    
    
}

