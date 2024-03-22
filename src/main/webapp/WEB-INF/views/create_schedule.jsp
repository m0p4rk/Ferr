<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Create Schedule</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.9/flatpickr.min.css">
    <style>
        #map {
            width: 100%;
            height: 400px;
        }
    </style>
</head>
<body>

<h1>일정 생성</h1>
<form id="createScheduleForm" action="/schedule/create" method="post">
    <div>
        <label for="contentId">일정 제목: </label>
        <input type="text" id="contentId" name="contentId" required>
    </div>
    <div>
        <label for="promiseDate">약속일: </label>
        <input type="date" id="promiseDate" name="promiseDate" required>
    </div>
    <div>
        <label for="startLocation">출발지: </label>
        <input type="text" id="startLocation" name="startLocation" required>
    </div>
    <button type="submit" id="createScheduleBtn" class="btn btn-primary">일정 생성/수정</button>
</form>

<!-- 날씨 정보 표시 영역 -->
<div id="weatherInfo"></div>

<!-- 카카오 맵 표시 영역 -->
<div id="map"></div>

<!-- JavaScript 파일 및 기타 스크립트 링크 추가 -->
<button id="showRouteBtn" class="btn btn-primary">최단 경로 보기</button>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<!-- 부트스트랩 JS -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<!-- flatpickr 날짜 선택 라이브러리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.9/flatpickr.min.js"></script>
<!-- 카카오맵 SDK를 동적으로 로드 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9496f9be338adc74c68fd22757fd2e12&libraries=LIBRARY"></script>
<script>
var exampleEventLatitude; // 예시 행사 위치 위도
var exampleEventLongitude; // 예시 행사 위치 경도

$(document).ready(function () {
    // 현재 위치를 가져오는 함수 호출
    getLocation();
});

// 위치 정보를 가져오는 함수
function getLocation() {
    if (navigator.geolocation) {
        // Geolocation을 지원하는 경우
        navigator.geolocation.getCurrentPosition(showPosition, showError);
    } else {
        // Geolocation을 지원하지 않는 경우
        console.error('Geolocation을 지원하지 않습니다.');
        // 위치를 가져올 수 없는 경우 처리할 내용을 여기에 작성합니다.
    }
}

// 위치 정보 가져오기 성공 시 실행되는 함수
function showPosition(position) {
    var currentlatitude = position.coords.latitude; // 위도
    var currentlongitude = position.coords.longitude; // 경도

    // 날씨 정보 가져오기
    $.ajax({
        url: 'https://api.openweathermap.org/data/2.5/weather?lat=' + currentlatitude + '&lon=' + currentlongitude + '&appid=a62c831d0ac8f869133bcde70421b3b5&units=metric',
        method: 'GET',
        success: function (response) {
            // 날씨 정보를 가져온 후 화면에 표시합니다.
            var weatherInfo = '<h3>날씨 정보</h3>' +
                '<p>날씨: ' + response.weather[0].description + '</p>' +
                '<p>온도: ' + response.main.temp + ' ℃</p>' +
                '<p>습도: ' + response.main.humidity + ' %</p>';
            $("#weatherInfo").html(weatherInfo);
        },
        error: function (xhr, status, error) {
            console.error('날씨 정보를 불러오는 중 오류 발생:', error);
            // 날씨 정보를 가져오는 데 실패한 경우 처리할 내용을 여기에 작성합니다.
        }
    });

    // 지도에 현재 위치 표시하기
    var container = document.getElementById('map');
    var center = new kakao.maps.LatLng(currentlatitude, currentlongitude);
    var options = {center: center, level: 7};
    var map = new kakao.maps.Map(container, options);
    var marker = new kakao.maps.Marker({position: center});
    marker.setMap(map);

    // 행사 위치 마킹 (예시로만 표시)
    exampleEventLatitude = 37.5665; // 예시 행사 위치 위도
    exampleEventLongitude = 126.9780; // 예시 행사 위치 경도
    var exampleEventCenter = new kakao.maps.LatLng(exampleEventLatitude, exampleEventLongitude);
    var exampleEventMarker = new kakao.maps.Marker({position: exampleEventCenter});
    exampleEventMarker.setMap(map);  

    // 현재 위치와 행사 위치를 연결하는 선 그리기
    var linePath = [center, exampleEventCenter];
    var polyline = new kakao.maps.Polyline({
        path: linePath, // 선을 구성하는 좌표배열 입니다
        strokeWeight: 5, // 선의 두께 입니다
        strokeColor: '#FF0000', // 선의 색깔입니다
        strokeOpacity: 0.7, // 선의 불투명도 입니다
        strokeStyle: 'solid' // 선의 스타일입니다
    });
    polyline.setMap(map);
}

// 최단 경로 보기 버튼 클릭 시
$("#showRouteBtn").click(function () {
    // 목적지의 위도와 경도
    var destinationLat = exampleEventLatitude; // 예시 이벤트의 위도
    var destinationLng = exampleEventLongitude; // 예시 이벤트의 경도

    // Kakao Map 링크 URL 구성
    var kakaoMapUrl = 'https://map.kakao.com/link/to/목적지,' + destinationLat + ',' + destinationLng;

    // 팝업으로 Kakao Map 링크 열기
    window.open(kakaoMapUrl);
});

// 위치 정보 가져오기 실패 시 실행되는 함수
function showError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            console.error("사용자가 위치 정보를 허용하지 않았습니다.");
            break;
        case error.POSITION_UNAVAILABLE:
            console.error("위치 정보를 사용할 수 없습니다.");
			break;
		case error.TIMEOUT:
			console.error("위치 정보를 가져오는 데 시간이 너무 오래 걸립니다.");
			break;
		case error.UNKNOWN_ERROR:
			console.error("알 수 없는 오류가 발생했습니다.");
		break;
	}
    // 위치 정보를 가져오는 데 문제가 발생한 경우 처리할 내용을 여기에 작성합니다.
}
</script>


</body>
</html>
