<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>일정 관리 대시보드</title>
	<link rel="stylesheet"
		  href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script
			src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script
			src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<!-- 카카오맵 SDK를 동적으로 로드 -->
	<script type="text/javascript"
			src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9496f9be338adc74c68fd22757fd2e12&libraries=services"></script>
	<!-- OpenWeatherMap API 호출을 위한 JavaScript 파일 -->
	<script
			src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
</head>

<body>
<div class="container mt-5">
	<h1>일정 관리</h1>
	<h2>행사 위치와 날씨 정보</h2>
	<div id="map" style="width: 100%; height: 350px;"></div>
	<div id="weatherInfo" class="weather-widget"></div>
	<h2>스크래치 노트 추가 후 알림</h2>
	<form id="noteForm">
		<div class="form-group">
			<label for="noteContent">노트 내용:</label>
			<textarea class="form-control" id="noteContent" rows="3"></textarea>
		</div>
		<button type="submit" class="btn btn-primary">노트 추가</button>
	</form>
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
		<button id="navigateBtn" class="btn btn-primary">최단 경로 보기</button>
	</div>
	<!-- 후기/일지 및 평가 기능 페이지 링크 -->
	<div class="mt-3">
		<h2>후기 및 일지</h2>
		<a href="/reviews" class="btn btn-primary">작성하기</a>
	</div>
</div>
<!-- 일정 수정 및 삭제 버튼 -->
<div>
	<button type="button" class="btn btn-info mt-3 mr-2 editScheduleBtn"
			data-toggle="modal" data-target="#exampleModal"
			data-event-id="${schedule.eventId}">일정 수정
	</button>
	<button type="button" class="btn btn-danger mt-3"
			onclick="location.href='/schedule-detail/delete/${schedule.eventId}'">일정 삭제
	</button>
</div>

<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog"
	 aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">일정 수정</h5>
				<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<form id="updateScheduleForm" method="post"
				  action="/schedule-detail/update/${schedule.eventId}">
				<div class="modal-body">
					<div class="form-group">
						<label for="contentId">일정 제목</label>
						<input type="text" class="form-control"
							   id="contentId" name="contentId" required>
					</div>
					<div class="form-group">
						<label for="promiseDate">약속 날짜</label>
						<input type="date" class="form-control"
							   id="promiseDate" name="promiseDate" required>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">
						닫기
					</button>
					<button type="submit" class="btn btn-primary">
						변경 사항 저장
					</button>
				</div>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			</form>
		</div>
	</div>
</div>
<!-- JavaScript 코드 -->
<script>
	$(document).ready(function () {
		var mapContainer = document.getElementById('map');
		// 현재 위치를 받아와서 지도의 중심으로 설정하고 날씨 정보를 표시
		navigator.geolocation.getCurrentPosition(function(position) {
			var currentlatitude = position.coords.latitude;
			var currentlongitude = position.coords.longitude;
			var centerPosition = new kakao.maps.LatLng(currentlatitude, currentlongitude);
			var mapOption = {
				center: centerPosition,
				level: 8
			};
			var map = new kakao.maps.Map(mapContainer, mapOption);
			var marker = new kakao.maps.Marker({ position: centerPosition });
			marker.setMap(map);
			// 현재 위치 날씨 정보 가져오기
			$.ajax({
				url: 'https://api.openweathermap.org/data/2.5/weather?lat=' + currentlatitude + '&lon=' + currentlongitude + '&appid=a62c831d0ac8f869133bcde70421b3b5',
				method: 'GET',
				success: function (response) {
					var weatherInfo = '날씨: ' + response.weather[0].main + ', 온도: ' + (response.main.temp - 273.15).toFixed(1) + '°C';
					$('#weatherInfo').html(weatherInfo);
				},
				error: function (xhr, status, error) {
					console.error('날씨 정보를 불러오는 중 오류 발생:', error);
				}
			});
			// 서버로부터 목적지 위치 받아오기
			$.ajax({
				url: '/destination/' + ${schedule.eventId}, // eventId를 포함한 URL로 변경
				method: 'GET',
				success: function (destination) {
					// 목적지 위치 마커 표시
					var destinationPosition = new kakao.maps.LatLng(${schedule.latitude}, ${schedule.longitude});
					var destinationMarker = new kakao.maps.Marker({ position: destinationPosition });
					destinationMarker.setMap(map);
				},
				error: function (xhr, status, error) {
					console.error('목적지 위치를 불러오는 중 오류 발생:', error);
				}
			});
		});
		// 모달을 열 때 이벤트 ID에 기반하여 form의 action URL 설정
		$('#exampleModal').on('show.bs.modal', function (event) {
			var button = $(event.relatedTarget); // 모달을 트리거하는 버튼
			var eventId = button.data('event-id'); // data-event-id 속성에서 이벤트 ID 추출
			var modal = $(this);
			modal.find('#updateScheduleForm').attr('action', '/schedule-detail/update/' + eventId);
		});
	});
	$('#navigateBtn').on('click', function() {
		// 카카오 지도 길찾기 URL 생성 : 목적지만 지정 가능
		var kakaoMapUrl = 'https://map.kakao.com/link/to/목적지,' + ${schedule.latitude} + ',' + ${schedule.longitude};
		// 팝업으로 카카오 지도창 띄우기
		window.open(kakaoMapUrl, '_blank');
	});
</script>
</body>
</html>