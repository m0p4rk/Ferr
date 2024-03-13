<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ferr - Search Results</title>
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
<style>
.box-container {
	display: flex;
	flex-wrap: wrap;
	justify-content: start;
	gap: 20px; /* 박스 사이의 간격 */
	margin: 20px;
}

.image-item {
	display: inline-block;
	width: 300px;
	height: 200px;
	background-color: #ddd;
	line-height: 200px;
	text-align: center;
	margin-right: 15px;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/filter_form.jsp"%>

	<!-- 검색 결과 컨테이너 -->
	<div class="box-container">
		<%-- 검색 결과 항목 반복 구간 시작 --%>
		<%-- 예를 들어, 서버에서 받아온 데이터 리스트를 반복 처리 --%>
		<div class="image-item">결과 1</div>
		<div class="image-item">결과 2</div>
		<%-- 반복 처리 종료 --%>
	</div>

	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script>
		// 검색 버튼 클릭 이벤트
		document.getElementById('searchButton')
				.addEventListener(
						'click',
						function() {
							var region = document
									.getElementById('regionFilter').value;
							var startDate = document
									.getElementById('startDateFilter').value;
							var endDate = document
									.getElementById('endDateFilter').value;
							var searchKeyword = document
									.getElementById('searchFilter').value;

							// URL로 데이터 전송
							window.location.href = 'searchResults.jsp?region='
									+ region + '&startDate=' + startDate
									+ '&endDate=' + endDate + '&search='
									+ searchKeyword;
						});
	</script>
</body>
</html>