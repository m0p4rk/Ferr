package com.warr.ferr.controller;


	import java.nio.file.Files;
	import java.nio.file.Path;
	import java.nio.file.Paths;

	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.core.io.InputStreamResource;
	import org.springframework.core.io.Resource;
	import org.springframework.http.ContentDisposition;
	import org.springframework.http.HttpHeaders;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.MediaType;
	import org.springframework.http.ResponseEntity;
	import org.springframework.stereotype.Controller;
	import org.springframework.web.bind.annotation.DeleteMapping;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PathVariable;
	import org.springframework.web.bind.annotation.ResponseBody;

import com.warr.ferr.model.ReviewFile;
import com.warr.ferr.service.ReviewFileService;


	@Controller
	public class ReviewFileController {

		@Autowired
		private ReviewFileService fileService;

		@GetMapping(value = "/download/file/{imageId}")
		public ResponseEntity<Resource> downloadFile(@PathVariable int imageId) {
		    ReviewFile attachmentFile = null;
		    Resource resource = null;
		    try {
		        attachmentFile = fileService.getAttachmentFileByImageId(imageId);
		        if (attachmentFile != null) {
		            Path path = Paths.get(attachmentFile.getImageUrl() + "\\" + attachmentFile.getDescription());
		            resource = new InputStreamResource(Files.newInputStream(path));

		            HttpHeaders headers = new HttpHeaders();
		            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		            headers.setContentDisposition(
		                    ContentDisposition.builder("attachment").filename(attachmentFile.getDescription()).build());

		            return ResponseEntity.ok()
		                                 .headers(headers)
		                                 .body(resource);
		        } else {
		            // 파일이 존재하지 않는 경우 404 에러 반환
		            return ResponseEntity.notFound().build();
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        // 예외가 발생한 경우 500 에러 반환
		        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		    }
		}

		@ResponseBody
		@DeleteMapping(value = "/file/{fileId}")
		public String deleteFileByFileNo(@PathVariable int imageId) throws Exception {
			boolean result = false;
			String resultCode = "";

			result = fileService.deleteAttachmentFileByimageId(imageId);
			System.out.println(result);
			if (result) {
				System.out.println("성공");
				resultCode = "S000";
			} else {
				System.out.println("실패");
				resultCode = "F000";
			}

			return resultCode;
		}

	}
