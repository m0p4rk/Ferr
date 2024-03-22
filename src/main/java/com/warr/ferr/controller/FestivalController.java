package com.warr.ferr.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class FestivalController {
	private static final Logger logger = LoggerFactory.getLogger(FestivalController.class);
	
    @GetMapping("/api/searchFestival1")
    @ResponseBody
    public String searchFestival(@RequestParam(required = false) String region,
                                 @RequestParam(required = false) String startDate,
                                 @RequestParam(required = false) String endDate) {
    	logger.info("Request parameter region: {}", region);
    	String serviceKey = "UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D";
        String requestUrl = String.format(
                "http://apis.data.go.kr/B551011/KorService1/searchFestival1?serviceKey=%s&eventStartDate=%s&eventEndDate=%s&areaCode=%s&listYN=Y&MobileOS=ETC&MobileApp=AppName&_type=json&numOfRows=12&pageNo=1",
                serviceKey, startDate, endDate, region);

        RestTemplate restTemplate = new RestTemplate();
        String response = restTemplate.getForObject(requestUrl, String.class);
        
        logger.info("Request URL: {}", requestUrl);
  
        logger.info("Response from API: {}", response);
        
        return response;
    }
}
