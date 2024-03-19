package com.warr.ferr.service;

import com.warr.ferr.model.Schedule;
import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.repository.ScheduleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;

    public List<Schedule> testDataInit() {
        return scheduleRepository.createTestSchedule();
    }

    public void save(Schedule schedule) {
        scheduleRepository.saveInDB(schedule);
    }

    public Optional<Schedule> findByEventId(String id) {
        return scheduleRepository.findByEventId(id);
    }

    public List<ScheduleListDto> findSchedules() {
        return scheduleRepository.findAllSchedules();
    }
}
