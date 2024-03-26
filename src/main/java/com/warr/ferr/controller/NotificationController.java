package com.warr.ferr.controller;

import com.warr.ferr.model.Notification;
import com.warr.ferr.service.NotificationService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.Timestamp;
import java.time.LocalDateTime;

@Controller
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @PostMapping("/newNotification")
    public String newNotification(@RequestParam("id") Integer eventId,
                                  @RequestParam("date") @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") LocalDateTime date,
                                  @ModelAttribute Notification notification,
                                  @SessionAttribute("userId") Integer userId,
                                  RedirectAttributes redirectAttributes) {

        notification.setNotificationTime(Timestamp.valueOf(date));
        notification.setEventId(eventId);
        notificationService.createNotification(notification, userId);

        redirectAttributes.addAttribute("id", eventId);
        return "redirect:/schedule-detail";
    }

    @GetMapping("/notification/delete")
    public String deleteNotification(@RequestParam("id") Integer eventId,
                                     @RequestParam("nid") Integer notificationId,
                                     RedirectAttributes redirectAttributes) {

        notificationService.deleteNotificationById(notificationId);

        redirectAttributes.addAttribute("id", eventId);
        return "redirect:/schedule-detail";
    }
}
