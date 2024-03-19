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
<style>
.box-container {
	overflow: hidden;
	white-space: nowrap;
	margin-left: 50px;
	margin-right: 50px;
}

.image-item {
    position: relative; 
    display: inline-block;
    width: 300px;
    height: 200px;
    background-color: #ddd;
    margin-right: 15px;
    text-align: center;
    vertical-align: top;
    overflow: hidden; 
    transition: transform 0.3s ease; 
}

.image-item:hover {
    transform: scale(1.05); 
}


.image-text {
	position: absolute;
	bottom: 0;
	width: 100%;
	text-align: center;
	background-color: rgba(0, 0, 0, 0.5);
	color: white;
	padding: 5px 0;
}

.rank-number {
	position: absolute;
	top: 0;
	left: 0;
	background-color: rgba(255, 165, 0, 0.85);
	color: white;
	padding: 5px 10px;
	font-weight: bold;
}

.position-relative:hover .slider-btn {
	opacity: 1;
}

.slider-btn {
	display: inline-block;
	cursor: pointer;
	position: absolute;
	top: 50%;
	transform: translateY(-50%);
	z-index: 2;
	font-size: 24px;
	color: #fff;
	background-color: rgba(0, 0, 0, 0.5);
	border: none;
	opacity: 0;
	transition: opacity 0.5s ease;
}

.left {
	left: 0;
}

.right {
	right: 0;
}

.title-container {
	text-align: left;
	margin-bottom: 10px;
	padding: 10px;
}
</style>
</head>
<body>

	<div class="container-fluid">
		<%@ include file="/WEB-INF/views/filter_form.jsp"%>

		<!-- Example Container 1 -->
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
					onclick="scrollContainer('container1', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('container1', 'right')">&#10095;</button>
			</div>
		</div>

		<!-- Example Container 2 -->
		<div class="row">
			<div class="col-12">
				<div class="title-container">
					<h2>현 지역의 행사 리스트 - 브라우저로 현 위치 정보 사용</h2>
				</div>
			</div>
			<div class="col-12 position-relative">
				<div class="box-container" id="container2">
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
					onclick="scrollContainer('container2', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('container2', 'right')">&#10095;</button>
			</div>
		</div>

		<!-- Example Container 3 -->
		<div class="row">
			<div class="col-12">
				<div class="title-container">
					<h2>순위</h2>
				</div>
			</div>
			<div class="col-12 position-relative">
				<div class="box-container" id="container3">
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
					onclick="scrollContainer('container3', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('container3', 'right')">&#10095;</button>
			</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script>
function redirectToEventDetail(eventId) {
	    window.location.href = `/event-detail?eventId=${eventId}`;
	}	
	
function scrollContainer(containerId, direction) {
    const container = document.getElementById(containerId);
    const scrollAmount = 600;
    let newScrollPosition;
    if (direction === 'left') {
        newScrollPosition = container.scrollLeft - scrollAmount;
    } else if (direction === 'right') {
        newScrollPosition = container.scrollLeft + scrollAmount;
    }
    container.scrollTo({
        top : 0,
        left : newScrollPosition,
        behavior : 'smooth'
    });
}

document.addEventListener("DOMContentLoaded", function() {
    const sliders = document.querySelectorAll('.box-container');

    sliders.forEach(function(slider) {
        let isDown = false;
        let startX;
        let scrollLeft;

        slider.addEventListener('mousedown', (e) => {
            isDown = true;
            slider.classList.add('active');
            startX = e.pageX - slider.offsetLeft;
            scrollLeft = slider.scrollLeft;
        });

        slider.addEventListener('mouseleave', () => {
            isDown = false;
            slider.classList.remove('active');
        });

        slider.addEventListener('mouseup', () => {
            isDown = false;
            slider.classList.remove('active');
        });
        
        slider.addEventListener('wheel', (e) => {
            e.preventDefault(); // 기본 스크롤 동작 방지
            slider.scrollLeft += e.deltaY + e.deltaX;
        });// 수평 스크롤 조정

        slider.addEventListener('mousemove', (e) => {
            if (!isDown) return;
            e.preventDefault();
            const x = e.pageX - slider.offsetLeft;
            const walk = (x - startX) * 1.1; // 스크롤 속도 조정
            slider.scrollLeft = scrollLeft - walk;
        });
    });
});
</script>
</body>
</html>
