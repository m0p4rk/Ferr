package com.warr.ferr.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.warr.ferr.model.Schedule;
import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.dto.ScheduleUpdateDto;
import java.util.List;
import java.util.Map;

@Mapper
public interface ScheduleMapper {

    /**
     * 스케줄을 데이터베이스에 저장합니다.
     * @param schedule 저장할 스케줄 객체
     */
    void saveSchedule(Schedule schedule);

    /**
     * 주어진 이벤트 ID로 스케줄을 조회합니다.
     * @param id 이벤트 ID
     * @return 조회된 스케줄 객체
     */
    Schedule findByEventId(Integer id);

    /**
     * 주어진 이벤트 ID로 스케줄을 삭제합니다.
     * @param id 이벤트 ID
     */
    void deleteByEventId(Integer id);

    /**
     * 모든 스케줄을 조회하여 목록으로 반환합니다.
     * @return 스케줄 목록
     */
    List<ScheduleListDto> findAllSchedules();

    /**
     * 주어진 이벤트 ID에 해당하는 스케줄을 업데이트합니다.
     * @param id 이벤트 ID
     * @param scheduleUpdateDto 업데이트할 스케줄 정보가 담긴 DTO
     */
    void updateByEventId(@Param("eventId") Integer id,
                         @Param("scheduleUpdateDto") ScheduleUpdateDto scheduleUpdateDto);

    /**
     * 특정 조건에 따라 위도와 경도 정보를 조회합니다.
     * @param condition 조회 조건
     * @return 위도와 경도 정보가 담긴 맵
     */
    Map<String, Double> getLatitudeAndLongitude(@Param("condition") String condition);
}
