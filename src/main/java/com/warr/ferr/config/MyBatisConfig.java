package com.warr.ferr.config;

import com.warr.ferr.mapper.ScheduleMapper;
import com.warr.ferr.repository.ScheduleRepository;
import com.warr.ferr.service.ScheduleService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
public class MyBatisConfig {

    private final ScheduleMapper scheduleMapper;

    @Bean
    public ScheduleService scheduleService() {
        return new ScheduleService(scheduleRepository());
    }

    @Bean
    public ScheduleRepository scheduleRepository() {
        return new ScheduleRepository(scheduleMapper);
    }
}
