package com.warr.ferr.mapper;

import com.warr.ferr.model.ScheduleReview;
import org.apache.ibatis.annotations.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Mapper
public interface ScheduleReviewMapper {
    
    List<ScheduleReview> getAllReviews();
    
    ScheduleReview getReviewById(long id);
    
    void addReview(ScheduleReview review);

	ScheduleReview findReviewById(int reviewId);


	void deleteReview(int reviewId);

	void updateReview(ScheduleReview review);




}
