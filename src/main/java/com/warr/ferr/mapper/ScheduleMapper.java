package com.warr.ferr.mapper;

import com.warr.ferr.dto.ScheduleUpdateDto;
import com.warr.ferr.model.Schedule;
import com.warr.ferr.dto.ScheduleListDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Mapper
public interface ScheduleMapper {

    void saveInDB(Schedule schedule);

    Optional<Schedule> findByEventId(Integer id);

    void deleteByEventId(Integer id);

    // 스케줄 리스트에서 사용
    List<ScheduleListDto> findAllSchedules();

    void updateByEventId(@Param("eventId") Integer id,
                         @Param("scheduleUpdateDto") ScheduleUpdateDto scheduleUpdateDto);

	void saveSchedule(Schedule schedule);

	Map<String, Double> getLatitudeAndLongitude(String condition);

	Map<String, Double> getLatitudeLongitude(int eventId);
}
