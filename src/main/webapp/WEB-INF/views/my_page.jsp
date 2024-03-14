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
			<p>대분류 : 인문(문화/예술/역사)는 고정 - 이것만 사용</p>
			<div class="form-group">
				<label for="midCategory">중분류 선택</label> <select class="form-control"
					id="midCategory" name="midCategory">
					<option value="">선택하세요</option>
					<option value="A0207">축제</option>
					<option value="A0208">공연/행사</option>
				</select>
			</div>

			<div id="festivalCategories" class="hidden">
				<div class="form-group">
					<label>축제 관련 소분류</label>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02070100">문화관광축제</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02070200">일반축제</label>
					</div>
				</div>
			</div>

			<div id="performanceCategories" class="hidden">
				<div class="form-group">
					<label>공연/행사 관련 소분류</label>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02080100">전통공연</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02080200">연극</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02080300">뮤지컬</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02080400">오페라</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02080500">전시회</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02080600">박람회</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02080800">무용</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02080900">클래식음악회</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02081000">대중콘서트</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02081100">영화</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02081200">스포츠경기</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" name="subCategory"
							value="A02081300">기타행사</label>
					</div>
				</div>
			</div>
			<button type="submit" class="btn btn-primary">저장</button>
		</form>
	</div>

	<script>
		$(document).ready(function() {
			$('#midCategory').change(function() {
				var selectedCategory = $(this).val();
				if (selectedCategory == 'A0207') {
					$('#festivalCategories').show();
					$('#performanceCategories').hide();
				} else if (selectedCategory == 'A0208') {
					$('#performanceCategories').show();
					$('#festivalCategories').hide();
				} else {
					$('#festivalCategories').hide();
					$('#performanceCategories').hide();
				}
			});
		});
	</script>

	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

