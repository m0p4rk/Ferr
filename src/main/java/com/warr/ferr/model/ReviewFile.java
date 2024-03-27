package com.warr.ferr.model;

import java.sql.Timestamp;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
@NoArgsConstructor
public class ReviewFile {
	private int imageId;
	private int reviewId;
	private String description;
	private String imageUrl;
	private Timestamp uploaded_at;
	
	@Builder
	public ReviewFile(int imageId, int reviewId, String description, String imageUrl, Timestamp uploaded_at) {
		super();
		this.imageId = imageId;
		this.reviewId = reviewId;
		this.description = description;
		this.imageUrl = imageUrl;
		this.uploaded_at = uploaded_at;
	}
	
	
}
