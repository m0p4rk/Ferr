package com.warr.ferr.service;

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

    @Transactional(readOnly = true)
    public EventParticipant getParticipant(int eventId, int userId) {
        return eventParticipantMapper.selectByEventIdAndUserId(eventId, userId);
    }

    @Transactional(readOnly = true)
    public List<EventParticipant> getParticipantsByEvent(int eventId) {
        return eventParticipantMapper.selectByEventId(eventId);
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
