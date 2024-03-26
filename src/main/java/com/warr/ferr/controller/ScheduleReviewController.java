package com.warr.ferr.controller;

import com.warr.ferr.model.ScheduleReview;
import com.warr.ferr.service.ScheduleReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
    public String getReviewById(@PathVariable int id, Model model) {
        ScheduleReview review = scheduleReviewService.getReviewById(id);
        model.addAttribute("review", review);
        return "review_detail"; // 리뷰 상세 정보를 보여주는 JSP 파일의 경로
    }
    
    @GetMapping("/add")
    public String showAddReviewForm(@RequestParam("eventId") int eventId, Model model) {
        // eventId를 이용하여 필요한 로직을 수행하고, 필요한 데이터를 모델에 추가합니다.
        model.addAttribute("eventId", eventId);
        model.addAttribute("review", new ScheduleReview());
        return "create_review"; // 리뷰 추가 폼을 보여주는 JSP 파일의 경로
    }
    @PostMapping("/add/{id}")
    public String addReview(@ModelAttribute ScheduleReview review) {
    	scheduleReviewService.addReview(review);
    	return "redirect:/reviews"; // 리뷰 목록으로 리다이렉트
    }

	@PostMapping("/update/{id}")
	public String updateReview(@PathVariable("id") int id, @ModelAttribute ScheduleReview review,
			 RedirectAttributes redirectAttributes) {

		scheduleReviewService.updateReview(review);
		redirectAttributes.addFlashAttribute("successMessage", "게시글이 수정되었습니다.");
		return "redirect:/reviews";
	}
    @GetMapping("/delete/{reviewId}")
    public String deleteReview(@PathVariable("reviewId") int reviewId) {
        scheduleReviewService.deleteReview(reviewId);
        return "redirect:/reviews"; // 삭제 후 리뷰 목록 페이지로 이동
    }
}

