<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>행사 일정 관리 페이지</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<!-- 카카오맵 SDK를 동적으로 로드 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9496f9be338adc74c68fd22757fd2e12&libraries=services"></script>
<!-- OpenWeatherMap API 호출을 위한 JavaScript 파일 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
</head>
<body>
	<div class="container">
		<h2>행사 위치와 날씨 정보</h2>
		<div id="map" style="width: 100%; height: 350px;"></div>
		<div id="weatherInfo" class="weather-widget"></div>
=

		<h2>스크래치 노트 추가 후 알림</h2>
		<form id="noteForm">
			<div class="form-group">
				<label for="noteContent">노트 내용:</label>
				<textarea class="form-control" id="noteContent" rows="3"></textarea>
			</div>
			<button type="submit" class="btn btn-primary">노트 추가</button>
		</form>

		<!-- 일정 수정 및 삭제 버튼 -->
		<div>
			<button id="editScheduleBtn" class="btn btn-info mt-3 mr-2">일정
				수정</button>
			<button id="deleteScheduleBtn" class="btn btn-danger mt-3">일정
				삭제</button>
		</div>

		<div class="modal" id="alertModal">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">알림 설정</h4>
						<button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>
					<div class="modal-body">모달 바디에 알림 설정 폼을 추가하세요.</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-success" data-dismiss="modal">저장</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- JavaScript 코드 -->
	<script>
    var mapContainer = document.getElementById('map'); // 지도를 표시할 div 
    var mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

    // 지도를 생성합니다    
    var map = new kakao.maps.Map(mapContainer, mapOption);

    // 주소-좌표 변환 객체를 생성합니다
    var geocoder = new kakao.maps.services.Geocoder();

    // 주소로 좌표를 검색합니다
    geocoder.addressSearch('서울특별시 종로구 종로 54 보신각', function (result, status) {

        // 정상적으로 검색이 완료됐으면 
        if (status === kakao.maps.services.Status.OK) {

            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

            // 결과값으로 받은 위치를 마커로 표시합니다
            var marker = new kakao.maps.Marker({
                map: map,
                position: coords
            });

            // 인포윈도우로 장소에 대한 설명을 표시합니다
            var infowindow = new kakao.maps.InfoWindow({
                content: '<div style="width:150px;text-align:center;padding:6px 0;">보신각</div>'
            });
            infowindow.open(map, marker);

            // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
            map.setCenter(coords);

            // OpenWeatherMap API 호출하여 날씨 정보 가져오기
            $.ajax({
                url: 'https://api.openweathermap.org/data/2.5/weather?lat=' + result[0].y + '&lon=' + result[0].x + '&appid=a62c831d0ac8f869133bcde70421b3b5',
                method: 'GET',
                success: function (response) {
                    var weatherInfo = '날씨: ' + response.weather[0].main + ', 온도: ' + (response.main.temp - 273.15).toFixed(1) + '°C';
                    $('#weatherInfo').html(weatherInfo);
                },
                error: function (xhr, status, error) {
                    console.error('날씨 정보를 불러오는 중 오류 발생:', error);
                }
            });
        }
    });

		// 일정 수정 버튼 클릭 시 동작
		$('#editScheduleBtn').click(function() {
			// 수정 버튼 클릭 시 동작할 내용 추가
		});

		// 일정 삭제 버튼 클릭 시 동작
		$('#deleteScheduleBtn').click(function() {
			// 삭제 버튼 클릭 시 동작할 내용 추가
		});
	</script>
</body>
</html>

