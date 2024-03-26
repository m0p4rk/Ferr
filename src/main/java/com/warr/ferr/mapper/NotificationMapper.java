package com.warr.ferr.mapper;

import com.warr.ferr.model.Notification;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Optional;

@Mapper
public interface NotificationMapper {

    void createNotification(Notification notification);

    void deleteNotificationById(Integer id);

    Optional<Notification> findNotificationByEventId(Integer id);

    List<Notification> findAllNotificationsByEventId(Integer id);

}
