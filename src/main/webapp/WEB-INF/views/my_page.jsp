<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>선호 설정</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

<style>
.hidden {
	display: none;
}
</style>
</head>
<body>

	<div class="container mt-5">
		<h2>선호 설정</h2>
		<form action="/savePreferences" method="POST">
			<div class="form-group">
				<label for="regionPreference">선호 지역</label> <select
					class="form-control" id="regionPreference" name="regionPreference">
					<option value="">지역(전체)</option>
					<option value="1">서울</option>
					<option value="6">부산</option>
					<option value="4">대구</option>
					<option value="2">인천</option>
					<option value="5">광주</option>
					<option value="3">대전</option>
					<option value="7">울산</option>
					<option value="8">세종</option>
					<option value="31">경기도</option>
					<option value="32">강원도</option>
					<option value="33">충청북도</option>
					<option value="34">충청남도</option>
					<option value="35">경상북도</option>
					<option value="36">경상남도</option>
					<option value="37">전라북도</option>
					<option value="38">전라남도</option>
					<option value="39">제주도</option>
				</select>
			</div>
			<button type="submit" class="btn btn-primary" id="savePreferenceBtn">저장</button>
		</form>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	
</body>
</html>

