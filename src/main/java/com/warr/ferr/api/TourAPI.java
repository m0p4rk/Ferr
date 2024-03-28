package com.warr.ferr.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import jakarta.servlet.http.HttpSession;

@RestController
public class TourAPI {
	private static final Logger logger = LoggerFactory.getLogger(TourAPI.class);
	private final RestTemplate restTemplate = new RestTemplate();
	
	@GetMapping("/api/searchFestival1")
	public ResponseEntity<String> searchFestival(
	        @RequestParam(required = false) String region,
	        @RequestParam(required = false) String startDate,
	        @RequestParam(required = false) String endDate,
	        @RequestParam(defaultValue = "1") int pageNo) { // pageNo 파라미터 추가
	    
	    String serviceKey = "RfKadspJxs7UlgWwFxrI3lk0a6EHQS%2FAbQl5soEhqGRVItvRMVFlDBZLJHF7FEMpTq0yLcT2E9%2BFntTR%2FM8PBg%3D%3D";
	    String requestUrl = String.format(
	            "http://apis.data.go.kr/B551011/KorService1/searchFestival1?eventStartDate=%s&eventEndDate=%s&areaCode=%s&sigunguCode=&ServiceKey=%s&listYN=Y&MobileOS=ETC&MobileApp=AppTest&_type=json&arrange=A&numOfRows=12&pageNo=%d", // pageNo 사용
	            startDate, endDate, region, serviceKey, pageNo);

	    String response = restTemplate.getForObject(requestUrl, String.class);

	    logger.info("Request URL: {}", requestUrl);
	    logger.info("Response from API: {}", response);

	    return ResponseEntity.ok(response);
	}

    
	@GetMapping("/api/region-preference")
	public String getRegionPreference(HttpSession session) {
	    // 세션에서 "regionPreference" 값을 가져옵니다.
	    Object regionPreferenceObj = session.getAttribute("regionPreference");
	    // Object 타입의 값을 String으로 안전하게 변환합니다.
	    String regionPreference = (regionPreferenceObj != null) ? String.valueOf(regionPreferenceObj) : "1";
	    System.out.println("api region value" + regionPreference);
	    return regionPreference; // 변환된 문자열 값을 반환합니다.
	}
	
	@GetMapping("/api/userId")
    public ResponseEntity<String> getUserId(HttpSession session) {
        // 세션에서 "userId" 값을 가져옵니다.
        Object userIdObj = session.getAttribute("userId");
        // Object 타입의 값을 String으로 안전하게 변환하고, 없을 경우 null을 반환합니다.
        String userId = (userIdObj != null) ? userIdObj.toString() : null;

        if (userId == null) {
            // userId가 세션에 없는 경우, 적절한 응답을 반환합니다.
            return ResponseEntity.badRequest().body("User not logged in");
        } else {
            // userId가 있는 경우, 해당 값을 문자열로 반환합니다.
            return ResponseEntity.ok(userId);
        }
    }
}
