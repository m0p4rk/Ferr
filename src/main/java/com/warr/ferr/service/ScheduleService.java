package com.warr.ferr.service;

import com.warr.ferr.model.Schedule;
import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.mapper.ScheduleMapper;
import com.warr.ferr.repository.ScheduleRepository;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;
    private final ScheduleMapper scheduleMapper;

    public List<Schedule> testDataInit() {
        return scheduleRepository.createTestSchedule();
    }

    public void save(Schedule schedule) {
        scheduleRepository.saveInDB(schedule);
    }

    public Optional<Schedule> findByEventId(Integer id) {
        return scheduleRepository.findByEventId(id);
    }

    public List<ScheduleListDto> findSchedules() {
        return scheduleRepository.findAllSchedules();
    }

    public void saveSchedule(Schedule schedule) {
        scheduleMapper.saveSchedule(schedule);
    }
}
