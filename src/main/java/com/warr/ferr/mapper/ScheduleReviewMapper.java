package com.warr.ferr.mapper;

import com.warr.ferr.model.ScheduleReview;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ScheduleReviewMapper {
    
    List<ScheduleReview> getAllReviews();
    
    ScheduleReview getReviewById(long id);
    
    void addReview(ScheduleReview review);
    
    void updateReview(long id, ScheduleReview review);
    
    void deleteReview(long id);
}
