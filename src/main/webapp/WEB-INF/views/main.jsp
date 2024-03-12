<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ferr - Your Content</title>
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
<style>
.box-container {
	overflow: hidden;
	white-space: nowrap;
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

.container-fluid {
	padding-top: 20px;
}

.row {
	margin-top: 20px;
}

.slider-btn {
	display: inline-block;
	cursor: pointer;
	position: absolute;
	top: 50%;
	transform: translate(-50%, -50%);
	z-index: 2;
	font-size: 24px;
	color: #fff;
	background-color: rgba(0, 0, 0, 0.5);
	border: none;
}

.left {
	left: 0;
}

.right {
	right: 0;
}
/* 추가된 스타일 */
.title-container {
	text-align: center;
	margin-bottom: 10px;
	padding: 10px;
	border: 2px dashed #007bff; /* 눈에 띄는 테두리 */
}

/* 네비게이션 바 스타일 조정 */
.navbar {
	font-size: 0.9rem; /* 폰트 크기 조정 */
	padding-top: 0.00rem;
	padding-bottom: 1rem;
}

/* 네비게이션 바 브랜드(로고) 크기 조정 */
.navbar-brand {
	font-size: 1.25rem; /* 브랜드 로고 폰트 크기 조정 */
}

/* 네비게이션 바 항목 패딩 조정 */
.nav-link {
	padding: 0.5rem 1rem; /* 상단 및 하단 패딩 줄임 */
}

/* 버튼 크기 조정 (로그인 및 회원가입 버튼 등) */
.btn {
	padding: 0.25rem 0.5rem; /* 버튼 내부 패딩 조정 */
	font-size: 0.875rem; /* 버튼 폰트 크기 조정 */
}
</style>
</head>
<body>

	<div class="container-fluid">
		<div class="filter">
			<select id="regionFilter" class="course_regionFilterSelect">
				<option value="">전체</option>
				<option value="1">서울</option>
				<option value="6">부산</option>
				<option value="4">대구</option>
				<option value="2">인천</option>
				<option value="5">광주</option>
				<option value="3">대전</option>
				<option value="7">울산</option>
				<option value="8">세종</option>
				<option value="31">경기</option>
				<option value="32">강원</option>
				<option value="33">충북</option>
				<option value="34">충남</option>
				<option value="35">경북</option>
				<option value="36">경남</option>
				<option value="37">전북</option>
				<option value="38">전남</option>
				<option value="39">제주</option>
			</select>
		</div>
		<div class="filter">
			<select id="hashtagFilter" class="course_hashtagFilterSelect">
				<option value="">전체</option>
				<option value="C0112">#가족코스</option>
				<option value="C0113">#나홀로코스</option>
				<option value="C0114">#힐링코스</option>
				<option value="C0115">#도보코스</option>
				<option value="C0116">#캠핑코스</option>
				<option value="C0117">#맛코스</option>
			</select>
		</div>
		<%-- Example Container 1 with title --%>
		<div class="row">
			<!-- 타이틀 컨테이너 시작 -->
			<div class="col-12">
				<div class="title-container">
					<h2>타이틀 컨테이너 1</h2>
					<!-- 제목 -->
				</div>
			</div>
			<!-- 타이틀 컨테이너 끝 -->
			<div class="col-12 position-relative">
				<div class="box-container" id="container1">
					<!-- 이미지 아이템들 -->
					<div class="image-item">Item 1</div>
					<div class="image-item">Item 2</div>
					<div class="image-item">Item 3</div>
					<div class="image-item">Item 1</div>
					<div class="image-item">Item 2</div>
					<div class="image-item">Item 3</div>
					<div class="image-item">Item 1</div>
					<div class="image-item">Item 2</div>
					<div class="image-item">Item 3</div>
					<div class="image-item">Item 1</div>
					<div class="image-item">Item 2</div>
					<div class="image-item">Item 3</div>
					<div class="image-item">Item 1</div>
					<div class="image-item">Item 2</div>
					<div class="image-item">Item 3</div>
				</div>
				<button class="slider-btn left"
					onclick="scrollContainer('container1', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('container1', 'right')">&#10095;</button>
			</div>
		</div>
		<%-- 다른 컨테이너에 대해서도 같은 방식으로 타이틀 컨테이너를 추가할 수 있습니다. --%>
	</div>

	<div class="container-fluid">
		<%-- Example Container 2 with title --%>
		<div class="row">
			<!-- 타이틀 컨테이너 시작 -->
			<div class="col-12">
				<div class="title-container">
					<h2>타이틀 컨테이너 2</h2>
					<!-- 제목 -->
				</div>
			</div>
			<!-- 타이틀 컨테이너 끝 -->
			<div class="col-12 position-relative">
				<div class="box-container" id="container2">
					<!-- 이미지 아이템들 -->
					<div class="image-item">Item 1</div>
					<div class="image-item">Item 2</div>
					<div class="image-item">Item 3</div>
					<div class="image-item">Item 1</div>
					<div class="image-item">Item 2</div>
					<div class="image-item">Item 3</div>
					<div class="image-item">Item 1</div>
					<div class="image-item">Item 2</div>
					<div class="image-item">Item 3</div>
					<div class="image-item">Item 1</div>
					<div class="image-item">Item 2</div>
					<div class="image-item">Item 3</div>
					<div class="image-item">Item 1</div>
					<div class="image-item">Item 2</div>
					<div class="image-item">Item 3</div>
				</div>
				<button class="slider-btn left"
					onclick="scrollContainer('container2', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('container2', 'right')">&#10095;</button>
			</div>
		</div>
		<%-- 다른 컨테이너에 대해서도 같은 방식으로 타이틀 컨테이너를 추가할 수 있습니다. --%>
	</div>

	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script>
		function scrollContainer(containerId, direction) {
			const container = document.getElementById(containerId);
			const scrollAmount = 300; // 스크롤할 양을 지정

			let newScrollPosition;

			if (direction === 'left') {
				newScrollPosition = container.scrollLeft - scrollAmount;
			} else if (direction === 'right') {
				newScrollPosition = container.scrollLeft + scrollAmount;
			}

			// 스무스 스크롤 애니메이션을 적용
			container.scrollTo({
				top : 0, // 세로 스크롤 위치는 변경하지 않음
				left : newScrollPosition, // 계산된 새로운 스크롤 위치
				behavior : 'smooth' // 부드러운 스크롤 동작 활성화
			});
		}
	</script>
</body>
</html>
