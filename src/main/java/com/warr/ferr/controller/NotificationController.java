package com.warr.ferr.controller;

import com.warr.ferr.model.Notification;
import com.warr.ferr.service.NotificationService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.Date;
import java.time.LocalDate;

@Slf4j
@Controller
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    // Schedule Detail -> Logic(Create) -> Schedule Detail(Redirect)
    @PostMapping("/newNotification")
    public String newNotification(@RequestParam("id") Integer eventId,
                                  @RequestParam("date") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
                                  @ModelAttribute Notification notification,
                                  HttpServletRequest request) {

        notification.setNotificationTime(Date.valueOf(date));
        notification.setEventId(eventId);
        notificationService.createNotification(notification, request);
        return "redirect:/schedule-detail?id=" + eventId;
    }
}
