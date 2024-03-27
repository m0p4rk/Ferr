<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정 관리 대시보드</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="/css/common.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9496f9be338adc74c68fd22757fd2e12"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<style>
.container {
	background-color: #fff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	margin-top: 20px;
}

h1, h2 {
	color: #333;
}

#map {
	margin-top: 20px;
	border: 1px solid #ddd;
	border-radius: 8px;
	margin-bottom: 20px;
}

.weather-widget {
	padding: 15px;
	margin-bottom: 20px;
	background-color: #e9ecef;
	border-radius: 8px;
	color: #333;
}

.form-group, .form-row {
	margin-top: 15px;
}

.editAndDeleteSchedule button {
	margin-top: 20px;
	margin-bottom: 20px;
}

.modal-content {
	border-radius: 8px;
}

.modal-header {
	border-bottom: 1px solid #e9ecef;
}

.modal-footer {
	border-top: 1px solid #e9ecef;
}

.btn-primary {
	background-color: #007bff;
	border: none;
}

.btn-danger {
	background-color: #dc3545;
	border: none;
}

.btn-info {
	background-color: #17a2b8;
	border: none;
}

.dropdown-menu {
	border-radius: 8px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

hr {
	margin-top: 10px;
	margin-bottom: 10px;
}
</style>
</head>
<body>
	<div class="container mt-5">
		<!-- 페이지 주요 내용 -->
		<h1>일정 관리</h1>

		<!-- 행사 위치와 날씨 정보 -->
		<section id="eventLocationAndWeather">
			<h2>행사 위치와 날씨 정보</h2>
			<div id="map" style="width: 100%; height: 350px;"></div>
			<div id="weatherInfo" class="weather-widget"></div>
		</section>

		<!-- 노트 및 알림 입력 폼 -->
		<section id="noteAndAlertForm">
			<h2>스크래치 노트 추가 후 알림</h2>
			<form id="noteForm" action="/newNotification?id=${schedule.eventId}"
				method="post">
				<div class="form-group">
					<label for="noteContent">노트 내용</label>
					<textarea class="form-control" id="noteContent" name="content"
						rows="3"></textarea>
				</div>
				<div class="form-row align-items-center">
					<div class="col-auto">
						<label for="noteDateTime" class="sr-only">알림 예약 :</label> <input
							type="datetime-local" class="form-control mb-2" id="noteDateTime"
							name="date">
					</div>
					<div class="col-auto">
						<button type="submit" class="btn btn-primary mb-2">노트 추가
						</button>
					</div>
					<!-- Dropdown Form -->
					<div class="col-auto">
						<button class="btn btn-primary mb-2 dropdown-toggle" type="button"
							id="dropdownMenuButton" data-toggle="dropdown"
							aria-haspopup="true" aria-expanded="false">알림 보기</button>
						<div class="dropdown-menu" aria-labelledby="dropdownMenuButton"
							style="max-height: 500px; overflow-y: auto;">
							<c:forEach var="notification" items="${notifications}"
								varStatus="status">
								<div class="dropdown-item">
									<span>${notification.userId}님의 알림 : </span> <span>${notification.content}</span>
								</div>
								<div class="dropdown-item">
									알림 예정 시간 :
									<fmt:formatDate value="${notification.notificationTime}"
										pattern="M월 d일 a h시 m분" />
								</div>
								<div style="display: flex; justify-content: end;">
									<a
										href="/notification/delete
									?id=${schedule.eventId}
									&nid=${notification.notificationId}"
										class="btn btn-danger btn-sm" style="margin-right: 5px;">
										삭제 </a> <a
										href="/notification/update
									?id=${schedule.eventId}
									&nid=${notification.notificationId}"
										class="btn btn-primary btn-sm"> 수정 </a>
								</div>
								<c:if test="${not status.last}">
									<hr style="border-color: #2f2f2f;">
								</c:if>
							</c:forEach>
						</div>
					</div>
				</div>
			</form>
		</section>

		<!-- 그룹원 추가 UI -->
		<section id="groupManagement">
			<div class="mt-3">
				<h2>그룹원 관리</h2>
				<div class="input-group mb-3">
					<input type="text" class="form-control" placeholder="사용자 이름 또는 이메일">
					<div class="input-group-append">
						<button class="btn btn-outline-secondary" type="button">추가</button>
					</div>
				</div>
			</div>
		</section>

		<!-- 최단경로 기능 UI -->
		<section id="shortestRouteFeature">
			<div class="mt-3">
				<h2>최단경로</h2>
				<button id="navigateBtn" class="btn btn-primary">최단 경로 보기</button>
			</div>
		</section>

		<!-- 후기/일지 및 평가 기능 페이지 링크 -->
		<section id="reviewsAndLogs">
			<div class="mt-3">
				<h2>후기 및 일지</h2>
				<a href="/reviews/add?eventId=${schedule.eventId}"
					class="btn btn-primary">작성하기</a>
			</div>
		</section>
	</div>

	<!-- 일정 수정 및 삭제 버튼 -->
	<div class="editAndDeleteSchedule">
		<button type="button" class="btn btn-info mt-3 mr-2 editScheduleBtn"
			data-toggle="modal" data-target="#exampleModal"
			data-event-id="${schedule.eventId}">일정 수정</button>
		<button type="button" class="btn btn-danger mt-3"
			onclick="location.href='/schedule-detail/delete/${schedule.eventId}'">일정
			삭제</button>
	</div>

	<!-- 모달: 일정 수정 -->
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
							<label for="contentId">일정 제목</label> <input type="text"
								class="form-control" id="contentId" name="contentId" required>
						</div>
						<div class="form-group">
							<label for="promiseDate">약속 날짜</label> <input type="date"
								class="form-control" id="promiseDate" name="promiseDate"
								required>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-dismiss="modal">닫기</button>
						<button type="submit" class="btn btn-primary">변경 사항 저장</button>
					</div>
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
				</form>
			</div>
		</div>
	</div>
	<script>
$(document).ready(function () {
    // 지도 컨테이너 설정
    var mapContainer = document.getElementById('map');
    // 사용자의 현재 위치를 받아와 지도 중심으로 설정
    navigator.geolocation.getCurrentPosition(function (position) {
        var currentLatitude = position.coords.latitude;
        var currentLongitude = position.coords.longitude;
        var centerPosition = new kakao.maps.LatLng(currentLatitude, currentLongitude);
        var mapOption = { center: centerPosition, level: 8 };
        var map = new kakao.maps.Map(mapContainer, mapOption);
        var marker = new kakao.maps.Marker({ position: centerPosition });
        marker.setMap(map);

        // 현재 위치의 날씨 정보를 가져옴
        fetchWeatherInfo(currentLatitude, currentLongitude);
        // 서버로부터 목적지 위치 받아와 마커 표시
        fetchDestinationMarker(${schedule.eventId}, ${schedule.latitude}, ${schedule.longitude});
    });

    // 모달 열 때 이벤트 ID 기반으로 form action URL 설정
    setupModalEventId();

    // 최단 경로 보기 버튼 클릭 이벤트
    setupNavigateButton();
});

function fetchWeatherInfo(latitude, longitude) {
    var weatherApiUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=' + latitude + '&lon=' + longitude + '&appid=a62c831d0ac8f869133bcde70421b3b5';
    $.ajax({
        url: weatherApiUrl,
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

function fetchDestinationMarker(eventId, latitude, longitude) {
    var destinationPosition = new kakao.maps.LatLng(latitude, longitude);
    var destinationMarker = new kakao.maps.Marker({ position: destinationPosition });
    destinationMarker.setMap(map);
}

function setupModalEventId() {
    $('#exampleModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // 모달을 트리거하는 버튼
        var eventId = button.data('event-id'); // data-event-id 속성에서 이벤트 ID 추출
        var modal = $(this);
        modal.find('#updateScheduleForm').attr('action', '/schedule-detail/update/' + eventId);
    });
}

function setupNavigateButton() {
    $('#navigateBtn').on('click', function () {
        var kakaoMapUrl = 'https://map.kakao.com/link/to/목적지,' + ${schedule.latitude} + ',' + ${schedule.longitude};
        window.open(kakaoMapUrl, '_blank');
    });
}
</script>
</body>
</html>

