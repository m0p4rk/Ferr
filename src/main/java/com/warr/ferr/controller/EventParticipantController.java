package com.warr.ferr.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.warr.ferr.model.EventParticipant;
import com.warr.ferr.service.EventParticipantService;

import jakarta.servlet.http.HttpSession;

@RestController
public class EventParticipantController {
	
	@Autowired
	private EventParticipantService eventParticipantService;
	
	@GetMapping("/getParticipantsByEvent/{eventId}")
    public ResponseEntity<?> getParticipantsByEvent(@PathVariable("eventId") int eventId, HttpSession session) {
        // 현재 세션의 사용자 ID 가져오기
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
        }

        List<EventParticipant> participants = eventParticipantService.getParticipantsByEvent(eventId);
        for (EventParticipant participant : participants) {
            if (participant.getUserId() == userId) {
                return ResponseEntity.ok(true);
            }
        }

        return ResponseEntity.ok(false);
    }
	
}
