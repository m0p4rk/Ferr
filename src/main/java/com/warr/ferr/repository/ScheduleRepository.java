package com.warr.ferr.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.dto.ScheduleUpdateDto;
import com.warr.ferr.mapper.ScheduleMapper;
import com.warr.ferr.model.Schedule;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ScheduleRepository {

    private final ScheduleMapper scheduleMapper;

    public void saveInDB(Schedule schedule) {
        scheduleMapper.saveInDB(schedule);
    }

    public Optional<Schedule> findByEventId(Integer id) {
        return scheduleMapper.findByEventId(id);
    }

    public void deleteByEventId(Integer id) {
        scheduleMapper.deleteByEventId(id);
    }

    public void updateByEventId(Integer id, ScheduleUpdateDto scheduleUpdateDto) {
        scheduleMapper.updateByEventId(id, scheduleUpdateDto);
    }

    public List<ScheduleListDto> findAllSchedules() {
        return scheduleMapper.findAllSchedules();
    }


}
