package com.warr.ferr.mapper;

import java.util.Date;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.warr.ferr.model.EventNotification;

@Mapper
public interface EventNotificationMapper {

    // 특정 사용자 ID로 모든 이벤트 및 해당 알림 조회
    List<EventNotification> findAllEventsAndNotificationsByUserId(@Param("userId") Integer userId);

    // 현재 시간 이후의 알림 조회
    List<EventNotification> findDueNotifications(@Param("currentDateTime") Date currentDateTime);
}
