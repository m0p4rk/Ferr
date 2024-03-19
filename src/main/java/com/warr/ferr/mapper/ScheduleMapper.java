package com.warr.ferr.mapper;

import com.warr.ferr.model.Schedule;
import com.warr.ferr.dto.ScheduleListDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Optional;

@Mapper
public interface ScheduleMapper {

    void saveInDB(Schedule schedule);

    Optional<Schedule> findByEventId(String id);

    // 스케줄 리스트에서 사용
    List<ScheduleListDto> findAllSchedules();

//    void update(@Param("eventId") String eventId);
}
