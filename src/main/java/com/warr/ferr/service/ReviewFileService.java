package com.warr.ferr.service;

import java.io.File;
import java.sql.SQLException;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.warr.ferr.mapper.ReviewFileMapper;
import com.warr.ferr.model.ReviewFile;

@Service
public class ReviewFileService {

    @Autowired
    ReviewFileMapper reviewFileMapper;
    
    // ReviewFileMapper를 주입받는 생성자
    public ReviewFileService(ReviewFileMapper reviewFileMapper) {
        this.reviewFileMapper = reviewFileMapper;
    }

    
    public ReviewFile getAttachmentFileByImageId(int imageId) throws SQLException, Exception {
    	 return reviewFileMapper.getAttachmentFileByimageId(imageId);
    }
       

    public ReviewFile getAttachmentFileByreviewId(int reviewId) {
        return reviewFileMapper.getAttachmentFileByreviewId(reviewId);
    }

    public boolean insertAttachmentFile(MultipartFile file, int reviewId) {
        if (file.isEmpty()) {
            return false;
        }

        String filePath = "C:\\Users\\kimsoohan\\Pictures\\Screenshots";
        String attachmentOriginalFileName = file.getOriginalFilename();

        ReviewFile attachmentFile = ReviewFile.builder()
                .reviewId(reviewId)
                .description(attachmentOriginalFileName)
                .imageUrl(filePath)
                .build();

        // ReviewFileMapper를 사용하여 리뷰 첨부 파일을 추가하고 결과를 반환
        int res = reviewFileMapper.insertAttachmentFile(attachmentFile);
        return res != 0;
    }

    public boolean deleteFileByPostId(int reviewId) {
        try {
            int rowsAffected = reviewFileMapper.deleteByreviewId(reviewId);
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    @Transactional
	public boolean deleteAttachmentFileByimageId(int imageId)throws Exception {
	   	ReviewFile file = getAttachmentFileByImageId(imageId);
        File serverFile = new File(file.getImageUrl() + "\\" + file.getDescription());
        boolean serverDeleteResult = serverFile.delete();
        int res = reviewFileMapper.deleteAttachmentFileByimageId(imageId);
        return serverDeleteResult && res != 0;
    }
}

