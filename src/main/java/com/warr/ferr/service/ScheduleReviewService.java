package com.warr.ferr.service;

import com.warr.ferr.mapper.ScheduleReviewMapper;
import com.warr.ferr.model.ScheduleReview;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

	public void deletereview(int id) {
		scheduleReviewMapper.deleteReview(id);
		
	}

	public void updateReview(int id) {
		scheduleReviewMapper.updateReview(id);
	}


}
