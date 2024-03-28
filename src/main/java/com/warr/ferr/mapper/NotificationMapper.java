package com.warr.ferr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.warr.ferr.model.Notification;

@Mapper
public interface NotificationMapper {

    void createNotification(Notification notification);

    void deleteNotificationById(Integer id);

    List<Notification> findNotificationByEventId(Integer id);

    List<Notification> findAllNotificationsByEventId(Integer id);
    
    void updateNotificationById(Notification notification);

}
