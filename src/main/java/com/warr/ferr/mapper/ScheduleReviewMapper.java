package com.warr.ferr.mapper;

import com.warr.ferr.model.ScheduleReview;
import org.apache.ibatis.annotations.*;
import java.util.List;
import java.util.Map;

@Mapper
public interface ScheduleReviewMapper {
    
    List<ScheduleReview> getAllReviews();
    
    ScheduleReview getReviewById(long id);
    
    int addReview(ScheduleReview review);

	ScheduleReview findReviewById(int reviewId);


	void deleteReview(int reviewId);

	void updateReview(ScheduleReview review);

	List<ScheduleReview> searchPosts(String query);

	int searchPostsCount(String query);

	int countPosts();

	List<ScheduleReview> findSearchedPostsByPage(Map<String, Object> params);

	List<ScheduleReview> findPostsByPage(Map<String, Object> params);




}
