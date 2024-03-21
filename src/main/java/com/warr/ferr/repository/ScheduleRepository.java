package com.warr.ferr.repository;

import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.mapper.ScheduleMapper;
import com.warr.ferr.model.Schedule;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class ScheduleRepository {

    private final ScheduleMapper scheduleMapper;

    public List<Schedule> createTestSchedule() {
        List<Schedule> testData = new ArrayList<>();
        Schedule schedule1 = new Schedule(1,
                "강릉 여행",
                "강릉 XX축제",
                createTimestamp(2024, 4, 25),
                createTimestamp(2024, 5, 20),
                new BigDecimal("37.5697673859634"),
                new BigDecimal("126.983677617361"),
                createTimestamp(2024, 3, 17),
                Date.valueOf(LocalDate.now().plusWeeks(1)));

        Schedule schedule2 = new Schedule(1,
                "TestContentId2",
                "TestTitle2",
                createTimestamp(2024, 3, 29),
                createTimestamp(2024, 4, 21),
                new BigDecimal("37.4412157413878"),
                new BigDecimal("127.0162939669"),
                createTimestamp(2024, 3, 19),
                Date.valueOf(LocalDate.now().plusWeeks(1)));
        testData.add(schedule1);
        testData.add(schedule2);
        return testData;
    }

    private static Timestamp createTimestamp(int year, int month, int day) {
        LocalDateTime localDateTime = LocalDateTime.of(year, month, day, 0, 0);
        return Timestamp.valueOf(localDateTime);
    }

    public void saveInDB(Schedule schedule) {
        scheduleMapper.saveInDB(schedule);
    }

    public Optional<Schedule> findByEventId(Integer id) {
        return scheduleMapper.findByEventId(id);
    }

    public void deleteByEventId(Integer id) {
        scheduleMapper.deleteByEventId(id);
    }

    public List<ScheduleListDto> findAllSchedules() {
        return scheduleMapper.findAllSchedules();
    }

}
