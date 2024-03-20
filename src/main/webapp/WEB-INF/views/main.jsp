<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ferr - Main Page</title>
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet" href="/css/main.css">
</head>
<body>
	<div class="container-fluid">
		<%@ include file="/WEB-INF/views/filter_form.jsp"%>

		<!-- Example Container 0 -->
		<div class="row">
			<div class="col-12">
				<div class="title-container">
					<h2>API Call test</h2>
				</div>
			</div>
			<div class="col-12 position-relative">
				<div class="box-container" id="testcontainer">
					<div class="image-item" data-event-id="1"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 1</div>
					</div>
					<div class="image-item" data-event-id="2"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 2</div>
					</div>
					<div class="image-item" data-event-id="3"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 3</div>
					</div>
					<div class="image-item" data-event-id="4"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 4</div>
					</div>
					<div class="image-item" data-event-id="5"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 5</div>
					</div>
					<div class="image-item" data-event-id="6"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 6</div>
					</div>
				</div>
				<button class="slider-btn left"
					onclick="scrollContainer('testcontainer', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('testcontainer', 'right')">&#10095;</button>
			</div>
		</div>

		<div class="row">
			<div class="col-12">
				<div class="title-container">
					<h2>사용자의 설정된 추천 리스트</h2>
				</div>
			</div>
			<div class="col-12 position-relative">
				<div class="box-container" id="container1">
<%--					<div class="image-item" data-event-id="1"--%>
<%--						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">--%>
				<div class="box-container" id="recommendcontainer">
					<div class="image-item" data-event-id="1"
						 onclick="window.location.href='event-detail?eventId=1';">
						<div class="image-text">Sample 1</div>
					</div>
<%--					<div class="image-item" data-event-id="2"--%>
<%--						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">--%>
					<div class="image-item" data-event-id="2"
						 onclick="window.location.href='event-detail?eventId=2';">
						<div class="image-text">Sample 2</div>
					</div>
					<div class="image-item" data-event-id="3"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 3</div>
					</div>
					<div class="image-item" data-event-id="4"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 4</div>
					</div>
					<div class="image-item" data-event-id="5"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 5</div>
					</div>
					<div class="image-item" data-event-id="6"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 6</div>
					</div>
				</div>
				<button class="slider-btn left"
					onclick="scrollContainer('recommendcontainer', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('recommendcontainer', 'right')">&#10095;</button>
			</div>
		</div>

		<div class="row">
			<div class="col-12">
				<div class="title-container">
					<h2>내 주변</h2>
				</div>
			</div>
			<div class="col-12 position-relative">
				<div class="box-container" id="mylocationcontainer">
					<div class="image-item" data-event-id="1"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 1</div>
					</div>
					<div class="image-item" data-event-id="2"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 2</div>
					</div>
					<div class="image-item" data-event-id="3"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 3</div>
					</div>
					<div class="image-item" data-event-id="4"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 4</div>
					</div>
					<div class="image-item" data-event-id="5"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 5</div>
					</div>
					<div class="image-item" data-event-id="6"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Sample 6</div>
					</div>
				</div>
				<button class="slider-btn left"
					onclick="scrollContainer('mylocationcontainer', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('mylocationcontainer', 'right')">&#10095;</button>
			</div>
		</div>

		<div class="row">
			<div class="col-12">
				<div class="title-container">
					<h2>순위</h2>
				</div>
			</div>
			<div class="col-12 position-relative">
				<div class="box-container" id="rankcontainer">
					<div class="image-item" data-event-id="1"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="rank-number">1</div>
						<div class="image-text">Sample 1</div>
					</div>
					<div class="image-item" data-event-id="2"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="rank-number">2</div>
						<div class="image-text">Sample 2</div>
					</div>
				</div>
				<button class="slider-btn left"
					onclick="scrollContainer('rankcontainer', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('rankcontainer', 'right')">&#10095;</button>
			</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script src="/js/main.js"></script>

</body>
</html>
