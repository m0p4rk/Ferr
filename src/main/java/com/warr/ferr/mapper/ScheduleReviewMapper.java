package com.warr.ferr.mapper;

import com.warr.ferr.model.ScheduleReview;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ScheduleReviewMapper {
    
    List<ScheduleReview> getAllReviews();
    
    ScheduleReview getReviewById(long id);
    
    void addReview(ScheduleReview review);

	void deleteReview(int id);

	void updateReview(int id);
    

}
