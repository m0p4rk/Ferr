package com.warr.ferr.config;

import com.warr.ferr.mapper.NotificationMapper;
import com.warr.ferr.mapper.ScheduleMapper;
import com.warr.ferr.repository.ScheduleRepository;
import com.warr.ferr.service.NotificationService;
import com.warr.ferr.service.ScheduleService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
public class MyBatisConfig {

    private final ScheduleMapper scheduleMapper;
    private final NotificationMapper notificationMapper;

    @Bean
    public ScheduleService scheduleService() {
        return new ScheduleService(scheduleRepository(), scheduleMapper);
    }
    
    @Bean
    public ScheduleRepository scheduleRepository() {
        return new ScheduleRepository(scheduleMapper);
    }

    @Bean
    public NotificationService notificationService() {
        return new NotificationService(notificationMapper);
    }
}
