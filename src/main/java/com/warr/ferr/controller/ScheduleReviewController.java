package com.warr.ferr.controller;

import com.warr.ferr.model.ScheduleReview;
import com.warr.ferr.service.ScheduleReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/reviews")
public class ScheduleReviewController {

    private final ScheduleReviewService scheduleReviewService;

    @Autowired
    public ScheduleReviewController(ScheduleReviewService scheduleReviewService) {
        this.scheduleReviewService = scheduleReviewService;
    }

    @GetMapping
    public String getAllReviews(Model model) {
        List<ScheduleReview> reviews = scheduleReviewService.getAllReviews();
        model.addAttribute("reviews", reviews);
        return "reviews";
    }

    @GetMapping("/{id}")
    public String getReviewById(@PathVariable long id, Model model) {
        ScheduleReview review = scheduleReviewService.getReviewById(id);
        model.addAttribute("review", review);
        return "review_detail"; // 리뷰 상세 정보를 보여주는 JSP 파일의 경로
    }

    @GetMapping("/add")
    public String showAddReviewForm(Model model) {
        model.addAttribute("review", new ScheduleReview());
        return "create_review"; // 리뷰 추가 폼을 보여주는 JSP 파일의 경로
    }

    @PostMapping("/add")
    public String addReview(@ModelAttribute ScheduleReview review) {
        scheduleReviewService.addReview(review);
        return "redirect:/reviews"; // 리뷰 목록으로 리다이렉트
    }

    @GetMapping("/{id}/edit")
    public String showEditReviewForm(@PathVariable long id, Model model) {
        ScheduleReview review = scheduleReviewService.getReviewById(id);
        model.addAttribute("review", review);
        return "edit_review_form"; // 리뷰 수정 폼을 보여주는 JSP 파일의 경로
    }

    @PostMapping("/{id}/edit")
    public String updateReview(@PathVariable long id, @ModelAttribute ScheduleReview review) {
        scheduleReviewService.updateReview(id, review);
        return "redirect:/reviews"; // 리뷰 목록으로 리다이렉트
    }

    @PostMapping("/{id}/delete")
    public String deleteReview(@PathVariable long id) {
        scheduleReviewService.deleteReview(id);
        return "redirect:/reviews"; // 리뷰 목록으로 리다이렉트
    }
}

