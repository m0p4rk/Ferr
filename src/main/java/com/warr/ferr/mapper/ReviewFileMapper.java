package com.warr.ferr.mapper;

import com.warr.ferr.model.ReviewFile;

public interface ReviewFileMapper {

	ReviewFile getAttachmentFileByimageId(int imageId);

	ReviewFile getAttachmentFileByreviewId(int reviewId);

	int insertAttachmentFile(ReviewFile attachmentFile);

	int deleteAttachmentFileByimageId(int imageId);

	int deleteByreviewId(int reviewId);


}
