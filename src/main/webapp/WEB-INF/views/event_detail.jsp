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
				<img id="eventImage" alt="Event Image" class="img-fluid">
			</div>
			<div class="col-md-6">
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
					</tbody>
				</table>
				<button id="detailInfoBtn" class="btn btn-primary">상세 정보 보기</button>
				<button id="goBackBtn" class="btn btn-secondary"
					style="display: none;">되돌아가기</button>
				<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createScheduleModal" id="createScheduleBtn">일정 생성</button>
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
								class="form-control" id="arrivalLocation" placeholder="대구광역시 달성군 가창면 가창로 891" readonly>
						</div>
						<div class="form-group">
							<label for="startDate">출발 날짜</label> <input type="date"
								class="form-control" id="startDate" placeholder="출발 날짜">
						</div>
						<br>
						<p>* 출발 날짜는 행사 시작일, 종료일 사이만 출력 - 라이브러리 사용</p>
						<p>* 그룹원 추가 로직 연결</p>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">닫기</button>
					<!-- "일정 입력" 버튼, 이 버튼이 실제 일정을 서버로 전송 -->
					<!-- <button type="button" class="btn btn-primary" id="enterSchedule">입력</button> -->
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
</body>
</html>
