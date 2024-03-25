<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Event Details</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@600&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="/css/common.css">
<style>
.image-container img {
	max-width: 100%;
	height: auto;
}
</style>
</head>
<body>

	<div class="container mt-5">
		<h1 id="eventTitle" class="mb-4">상세정보</h1>

		<div class="row">
			<div class="col-md-6 image-container">
				<img id="eventImage" alt="Loading.." class="img-fluid">
				<!-- <img id="eventImage2" alt="Loading.." class="img-fluid"> -->
			</div>
			<div class="container mt-5">
				<h1 id="eventTitle" class="mb-4">상세정보</h1>
				<div class="row">
					<div class="col-md-12 table-container">
						<table class="table">
							<tbody>
								<tr>
									<th scope="row">주소</th>
									<td id="eventAddress"></td>
								</tr>
								<tr>
									<th scope="row">전화번호</th>
									<td id="eventTel"></td>
								</tr>
								<tr>
									<th scope="row">상세 설명</th>
									<td id="eventOverview"></td>
								</tr>
								<tr>
									<th scope="row">행사 시작일</th>
									<td id="eventStartDate"></td>
								</tr>
								<tr>
									<th scope="row">행사 종료일</th>
									<td id="eventEndDate"></td>
								</tr>
								<tr>
									<th scope="row">공연 시간</th>
									<td id="playTime"></td>
								</tr>
								<tr>
									<th scope="row">이용 요금</th>
									<td id="useTimeFestival"></td>
								</tr>
							</tbody>
						</table>
						<button type="button" class="btn btn-primary" data-toggle="modal"
							data-target="#createScheduleModal" id="createScheduleBtn">일정
							생성</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="createScheduleModal" tabindex="-1"
		aria-labelledby="createScheduleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="createScheduleModalLabel">일정 생성</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form id="createScheduleForm">
						<div class="form-group">
							<label for="departureLocation">출발 위치</label> <input type="text"
								class="form-control" id="departureLocation"
								placeholder="현 위치 자동 기입">
						</div>
						<div class="form-group">
							<label for="arrivalLocation">도착 위치</label> <input type="text"
								class="form-control" id="arrivalLocation" placeholder="도착 위치">
						</div>
						<div class="form-group">
							<label for="startDate">출발 날짜</label> <input type="date"
								class="form-control" id="startDate" placeholder="출발 날짜">
						</div>
						<br>
						<p>* 그룹원 추가 로직 연결</p>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">닫기</button>
					<button type="button" class="btn btn-primary" id="enterSchedule">입력</button>
				</div>
			</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script src="/js/event_detail.js"></script>
	<script>
		
	</script>
</body>
</html>
