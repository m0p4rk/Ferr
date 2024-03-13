<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x"%>
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
		<h1 class="mb-4">Sample</h1>

		<div class="row">
			<div class="col-md-6">
				<img
					src="http://tong.visitkorea.or.kr/cms/resource/29/2809529_image2_1.jpg"
					alt="Event Image" class="img-fluid">
			</div>
			<div class="col-md-6">
				<table class="table">
					<tbody>
						<tr>
							<th scope="row">우편번호</th>
							<td>03189</td>
						</tr>
						<tr>
							<th scope="row">전화명</th>
							<td>서울특별시</td>
						</tr>
						<tr>
							<th scope="row">전화번호</th>
							<td>02-120</td>
						</tr>
						<tr>
							<th scope="row">홈페이지</th>
							<td><a href="https://namsanbongsu.kr/" target="_blank">https://namsanbongsu.kr/</a></td>
						</tr>
						<tr>
							<th scope="row">주소</th>
							<td>서울특별시 종로구 종로 54 보신각</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<div class="row mt-4">
			<div class="col-12">
				<h2>개요</h2>
				<p>- 보신각 타종행사 시민과 함께하는 천년의 종소리 ! 보신각 타종행사...</p>
				<!-- 개요 내용 추가 -->
			</div>
		</div>

		<div class="row mt-4">
			<div class="col-12">
				<button id="viewMap" class="btn btn-primary">지도에서 위치 보기</button>
			</div>
			<div class="col-12">
				<button id="schedule_detail" class="btn btn-warning">일정
					생성/추가 - 파라미터</button>
			</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script>
		document.getElementById('viewMap').addEventListener('click',
				function() {
					// 카카오 지도 API 연결 코드를 여기에 추가
					alert('지도 API 연결 부분 구현 예정');
				});
		document.getElementById('schedule_detail').addEventListener('click',
				function() {
					window.location.href = '/schedule-detail?userId=123';
				});
	</script>
</body>
</html>