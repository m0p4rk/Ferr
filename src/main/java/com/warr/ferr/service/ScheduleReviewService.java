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

    public ScheduleReview getReviewById(long id) {
        return scheduleReviewMapper.getReviewById(id);
    }

    public void addReview(ScheduleReview review) {
        scheduleReviewMapper.addReview(review);
    }

    public void updateReview(long id, ScheduleReview review) {
        scheduleReviewMapper.updateReview(id, review);
    }

    public void deleteReview(long id) {
        scheduleReviewMapper.deleteReview(id);
    }
}
