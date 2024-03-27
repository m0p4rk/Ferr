package com.warr.ferr.service;

import java.util.List;
import org.springframework.stereotype.Service;
import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.dto.ScheduleUpdateDto;
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
    public void updateSchedule(Integer id, ScheduleUpdateDto scheduleUpdateDto) {
        scheduleMapper.updateByEventId(id, scheduleUpdateDto);
    }

    // 모든 스케줄 목록 조회
    public List<ScheduleListDto> findAllSchedules() {
        return scheduleMapper.findAllSchedules();
    }
}
