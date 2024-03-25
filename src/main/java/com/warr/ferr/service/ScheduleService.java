package com.warr.ferr.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.warr.ferr.dto.ScheduleListDto;
import com.warr.ferr.dto.ScheduleUpdateDto;
import com.warr.ferr.mapper.ScheduleMapper;
import com.warr.ferr.model.Schedule;
import com.warr.ferr.repository.ScheduleRepository;

import jakarta.servlet.http.HttpSession;
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

    public void saveSchedule(Schedule schedule, HttpSession session) {
        // 세션에서 사용자 ID 가져오기
        Object userIdObject = session.getAttribute("userId");

        if (userIdObject != null) {
            // 세션에서 가져온 사용자 ID를 int 타입으로 캐스팅
            int userId = ((Integer) userIdObject).intValue();

            // 세션에서 가져온 사용자 ID를 Schedule 객체에 설정
            schedule.setUserId(userId);
            
            // Schedule 객체를 데이터베이스에 저장
            scheduleMapper.saveSchedule(schedule);
        } else {
            // 사용자 ID가 세션에 없는 경우, 예외 처리
            throw new IllegalStateException("User is not logged in.");
        }
    }


}