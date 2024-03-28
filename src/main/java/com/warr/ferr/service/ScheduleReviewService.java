package com.warr.ferr.service;

import com.warr.ferr.mapper.ScheduleReviewMapper;
import com.warr.ferr.model.ScheduleReview;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ScheduleReviewService{

    private final ScheduleReviewMapper scheduleReviewMapper;

    @Autowired
    public ScheduleReviewService(ScheduleReviewMapper scheduleReviewMapper) {
        this.scheduleReviewMapper = scheduleReviewMapper;
    }

    public List<ScheduleReview> getAllReviews() {
        return scheduleReviewMapper.getAllReviews();
    }

    public ScheduleReview getReviewById(int id) {
        return scheduleReviewMapper.getReviewById(id);
    }

    public int addReview(ScheduleReview review) {
        scheduleReviewMapper.addReview(review);
        // 추가된 리뷰의 ID를 반환
        return review.getReviewId();
    }
	public ScheduleReview findReviewById(int reviewId) {
		return scheduleReviewMapper.findReviewById(reviewId);
	}


	public void deleteReview(int reviewId) {
		scheduleReviewMapper.deleteReview(reviewId);
		
	}

	public void updateReview(ScheduleReview review) {
		scheduleReviewMapper.updateReview(review);		
	}

	public List<ScheduleReview> findSearchedPostsByPage(int page, int pageSize, String query) {
		return getPagedPosts(page, pageSize, query);
	}


    public List<ScheduleReview> searchPosts(String query) {
        return scheduleReviewMapper.searchPosts(query);
    }


    public int countPosts() {
        return scheduleReviewMapper.countPosts();
    }


    public int searchPostsCount(String query) {
        return scheduleReviewMapper.searchPostsCount(query);
    }

    // Extracted Method
    private List<ScheduleReview> getPagedPosts(int page, int pageSize, String query) {
        int offset = (page - 1) * pageSize;
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("pageSize", pageSize);
        if (query != null) {
            params.put("query", query);
            return scheduleReviewMapper.findSearchedPostsByPage(params);
        } else {
            return scheduleReviewMapper.findPostsByPage(params);
        }
    }



}
