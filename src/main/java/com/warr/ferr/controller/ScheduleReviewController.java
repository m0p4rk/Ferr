package com.warr.ferr.controller;

import com.warr.ferr.model.ReviewFile;
import com.warr.ferr.model.ScheduleReview;
import com.warr.ferr.service.ReviewFileService;
import com.warr.ferr.service.ScheduleReviewService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/reviews")
public class ScheduleReviewController {

    private final ScheduleReviewService scheduleReviewService;
    private final ReviewFileService fileService;
    
    private static final int POSTS_PER_PAGE = 6;

    public ScheduleReviewController(ScheduleReviewService scheduleReviewService, ReviewFileService fileService ) {
        this.scheduleReviewService = scheduleReviewService;
        this.fileService = fileService;
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
        
        ReviewFile fileInfo = fileService.getAttachmentFileByreviewId(id);
        
        model.addAttribute("fileInfo", fileInfo);
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
    public String addReview(MultipartFile file, @ModelAttribute("review") ScheduleReview review) throws Exception {
        // 리뷰를 추가하고 리뷰 ID를 받아옴
        int reviewId = scheduleReviewService.addReview(review);
        
        // 리뷰 이미지를 추가할 때 리뷰 ID를 함께 전달
        if (file.getOriginalFilename() != null) {
            fileService.insertAttachmentFile(file, reviewId);
        }

        return "redirect:/reviews"; // 리뷰 목록으로 리다이렉트
    }
	@PostMapping("/update/{id}")
	public String updateReview(@PathVariable("id") int id, @ModelAttribute ScheduleReview review,
			@RequestParam("file") MultipartFile file,RedirectAttributes redirectAttributes) {
		
		
		if (!file.isEmpty()) {
			fileService.insertAttachmentFile(file, id);
		}
		
		scheduleReviewService.updateReview(review);
		redirectAttributes.addFlashAttribute("successMessage", "게시글이 수정되었습니다.");
		return "redirect:/reviews/{id}";
	}
    @GetMapping("/delete/{reviewId}")
    public String deleteReview(@PathVariable("reviewId") int reviewId) {
        scheduleReviewService.deleteReview(reviewId);
        return "redirect:/reviews"; // 삭제 후 리뷰 목록 페이지로 이동
    }
    
	@GetMapping("/search")
	public String searchPosts(@RequestParam String query, @RequestParam(value = "page", defaultValue = "1") int page,
			Model model) {
		List<ScheduleReview> searchResults = scheduleReviewService.findSearchedPostsByPage(page, POSTS_PER_PAGE, query);
		int totalPosts = scheduleReviewService.searchPostsCount(query);
		int totalPages = (int) Math.ceil((double) totalPosts / POSTS_PER_PAGE);

		model.addAttribute("posts", searchResults);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);

		return "reviewList";
	}
}

