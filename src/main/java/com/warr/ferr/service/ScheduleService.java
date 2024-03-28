package com.warr.ferr.service;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.mapper.ScheduleMapper;
import com.warr.ferr.model.Schedule;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ScheduleService {
    private final ScheduleMapper scheduleMapper;

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
        return scheduleMapper.findAllSchedules();
    }

 // 이벤트 ID에 해당하는 위도와 경도 정보를 조회하여 반환
    public Map<String, Double> getLatitudeLongitude(int eventId) {
        // 이벤트 ID를 사용하여 데이터베이스에서 위도와 경도 조회
        Map<String, Double> locationInfo = scheduleMapper.getLatitudeAndLongitude(eventId);
        
        // 조회된 위치 정보가 null이 아닌 경우, 해당 정보를 반환
        if (locationInfo != null) {
            return locationInfo;
        }
        
        // 조회된 위치 정보가 없는 경우, 기본값으로 설정하여 반환
        Map<String, Double> defaultLocationInfo = new HashMap<>();
        defaultLocationInfo.put("latitude", 0.0);
        defaultLocationInfo.put("longitude", 0.0);
        return defaultLocationInfo;
    }
}
