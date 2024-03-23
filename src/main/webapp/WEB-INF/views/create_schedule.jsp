<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>일정 관리 대시보드</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.9/flatpickr.min.css">
    <style>
        #map {
            width: 100%;
            height: 400px;
        }
        .card-clickable:hover {
            cursor: pointer;
            opacity: 0.9;
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <h1>일정 관리</h1>
    
    <div id="map"></div>
    <!-- 그룹원 추가 UI -->
    <div class="mt-3">
        <h2>그룹원 관리</h2>
        <div class="input-group mb-3">
            <input type="text" class="form-control" placeholder="사용자 이름 또는 이메일">
            <div class="input-group-append">
                <button class="btn btn-outline-secondary" type="button">추가</button>
            </div>
        </div>
    </div>

    <!-- 알림 기능 UI -->
    <div class="mt-3">
        <h2>알림</h2>
        <ul class="list-group">
            <!-- 알림 목록 동적 추가 -->
        </ul>
    </div>
    
    <!-- 최단경로 기능 UI -->
    <div class="mt-3">
        <h2>최단경로</h2>
        <button id="showRouteBtn" class="btn btn-primary">최단 경로 보기</button>
    </div>
    
    <!-- 후기/일지 및 평가 기능 페이지 링크 -->
    <div class="mt-3">
        <h2>후기 및 일지</h2>
        <a href="/reviews" class="btn btn-primary">작성하기</a>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.9/flatpickr.min.js"></script>
<!-- 카카오맵 SDK와 관련된 자바스크립트 코드는 실제 사용 시에 적절한 appkey로 변경 필요 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9496f9be338adc74c68fd22757fd2e12&libraries=LIBRARY"></script>
<!-- 페이지의 기능을 위한 자바스크립트 코드 추가 -->
<script>
$(document).ready(function() {
    // 지도를 표시할 div와 지도 옵션으로 지도를 생성합니다
    var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 초기 중심좌표
            level: 3 // 지도의 확대 레벨
        };

    // 지도를 생성합니다
    var map = new kakao.maps.Map(mapContainer, mapOption);

    // 현재 위치를 가져오는 함수
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            var lat = position.coords.latitude, // 위도
                lon = position.coords.longitude; // 경도

            var locPosition = new kakao.maps.LatLng(35.859191812305, 128.62910576135), // 현재 위치를 기반으로 한 좌표 생성
                message = '<div style="padding:5px;">현재 위치</div>'; // 인포윈도우에 표시될 내용

            // 지도 중심좌표를 현재 위치로 변경합니다
            map.setCenter(locPosition);

            // 마커와 인포윈도우를 표시합니다
            displayMarker(locPosition, message);
        }, function(error) {
            console.error(error);
            // 위치 정보를 가져오는데 실패한 경우, 기본 위치를 설정합니다.
            var defaultPosition = new kakao.maps.LatLng(37.566826, 126.9786567),
                message = '위치 정보를 가져올 수 없습니다.';
            displayMarker(defaultPosition, message);
            map.setCenter(defaultPosition);
        });
    } else {
        console.error('이 브라우저에서는 Geolocation이 지원되지 않습니다.');
    }

    // 마커와 인포윈도우를 표시하는 함수입니다
    function displayMarker(locPosition, message) {
        var marker = new kakao.maps.Marker({
            map: map,
            position: locPosition
        });

        var infowindow = new kakao.maps.InfoWindow({
            content: message,
            removable: true
        });

        infowindow.open(map, marker);
    }

    // 예시 행사 위치 마킹
    var eventPosition = new kakao.maps.LatLng(37.5665, 126.9780); // 예시 행사 위치
    new kakao.maps.Marker({
        map: map,
        position: eventPosition
    });

    // 지도에 현재 위치와 행사 위치를 연결하는 선을 그립니다
    var linePath = [new kakao.maps.LatLng(lat, lon), eventPosition];
    var polyline = new kakao.maps.Polyline({
        path: linePath,
        strokeWeight: 5,
        strokeColor: '#FFAE00',
        strokeOpacity: 0.7,
        strokeStyle: 'solid'
    });
    polyline.setMap(map);
});

$(document).ready(function() {
    // 최단 경로 보기 버튼 클릭 이벤트
    $("#showRouteBtn").click(function() {
        // 현재 위치와 목적지 위치 (예시로 서울 시청 사용)
        var currentLat = 37.5665; // 현재 위치의 위도 (임시 값)
        var currentLng = 126.9780; // 현재 위치의 경도 (임시 값)
        var destLat = 37.5665; // 목적지의 위도
        var destLng = 126.9780; // 목적지의 경도

        // 카카오맵에서 경로를 보여주는 URL 생성
        var routeUrl = `https://map.kakao.com/?sX=${currentLat}&sY=${currentLng}&eX=${destLat}&eY=${destLng}&go=1&vehicle=0`;

        // 새 창에서 카카오맵 경로 URL 열기
        window.open(routeUrl, '_blank');
    });
});


</script>

</body>
</html>
