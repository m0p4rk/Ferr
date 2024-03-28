package com.warr.ferr.model;

import javax.persistence.*;

import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
@Entity
@Data
@NoArgsConstructor
public class ScheduleReview {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int reviewId;
    
    private int eventId;
    
    private int userId;
    
    private String title;
    
    @Lob
    private String content;
    
    private int rating;
    
    
    private Timestamp createdAt;
    
 
    private Timestamp updatedAt;
    
    @Builder
	public ScheduleReview(int reviewId, int eventId, int userId, String title, String content, int rating,
			Timestamp createdAt, Timestamp updatedAt) {
		super();
		this.reviewId = reviewId;
		this.eventId = eventId;
		this.userId = userId;
		this.title = title;
		this.content = content;
		this.rating = rating;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
	}

    
    
}