package com.warr.ferr.service;

import com.warr.ferr.mapper.ScheduleReviewMapper;
import com.warr.ferr.model.ScheduleReview;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

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

    public void addReview(ScheduleReview review) {
        scheduleReviewMapper.addReview(review);
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





}
