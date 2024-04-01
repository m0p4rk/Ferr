package com.warr.ferr.service;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.mapper.ScheduleMapper;
import com.warr.ferr.model.Chatrooms;
import com.warr.ferr.model.Schedule;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ScheduleService {
    private final ScheduleMapper scheduleMapper;
    private final ChatService chatService;

    // 스케줄 저장 후 자동 생성된 이벤트 ID를 반환
    public int saveSchedule(Schedule schedule) {
        scheduleMapper.saveSchedule(schedule);
        return schedule.getEventId();
    }

    // 이벤트 ID로 특정 스케줄 조회
    public Schedule findByEventId(Integer id) {
        return scheduleMapper.findByEventId(id);
    }

    // 이벤트 ID로 스케줄 삭제
    public void deleteSchedule(Integer id) {
        scheduleMapper.deleteByEventId(id);
    }

    // 이벤트 ID와 업데이트 정보를 바탕으로 스케줄 업데이트
    public void updateScheduleDate(Integer eventId, Date promiseDate) {
        // java.util.Date를 java.sql.Date로 변환
        java.sql.Date sqlPromiseDate = new java.sql.Date(promiseDate.getTime());

        scheduleMapper.updateScheduleDateByEventId(eventId, sqlPromiseDate);
    }


    // 모든 스케줄 목록 조회
    public List<ScheduleListDto> findAllSchedules() {
    	List<ScheduleListDto> scheduleListDto = scheduleMapper.findAllSchedules();
    	List<Chatrooms> chatrooms = chatService.findChatroomByEventId();
    	for(int i = 0; i <scheduleListDto.size(); i++) {
    		for(int j = 0; j < chatrooms.size(); j++) {
    			if(scheduleListDto.get(i).getEventId() == chatrooms.get(j).getEventId()) {
    				scheduleListDto.get(i).setChatroomId(chatrooms.get(j).getChatroomId());
    			}
    		}
    	}
        return scheduleListDto;
    }

 // 이벤트 ID에 해당하는 위도와 경도 정보를 조회하여 반환
    public Map<String, BigDecimal> getLatitudeLongitude(int eventId) {
        // 이벤트 ID를 사용하여 데이터베이스에서 위도와 경도 조회
        return scheduleMapper.getLatitudeLongitude(eventId);
    }

}