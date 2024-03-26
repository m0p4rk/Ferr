package com.warr.ferr.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.dto.ScheduleUpdateDto;
import com.warr.ferr.mapper.ScheduleMapper;
import com.warr.ferr.model.Schedule;
import com.warr.ferr.repository.ScheduleRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;
    private final ScheduleMapper scheduleMapper;

    public void save(Schedule schedule) {
        scheduleRepository.saveInDB(schedule);
    }

    public Optional<Schedule> findByEventId(Integer id) {
        return scheduleRepository.findByEventId(id);
    }

    public void deleteSchedule(Integer id) {
        scheduleRepository.deleteByEventId(id);
    }

    public void updateSchedule(Integer id, ScheduleUpdateDto scheduleUpdateDto) {
        scheduleRepository.updateByEventId(id, scheduleUpdateDto);
    }

    public List<ScheduleListDto> findSchedules() {
        return scheduleRepository.findAllSchedules();
    }

    public int saveSchedule(Schedule schedule) {
        // Schedule 객체를 데이터베이스에 저장
        scheduleMapper.saveSchedule(schedule);
        
        // 저장된 Schedule 객체로부터 eventId 반환
        return schedule.getEventId();
    }


}