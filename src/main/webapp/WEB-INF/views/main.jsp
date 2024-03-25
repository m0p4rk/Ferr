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
<link rel="stylesheet" href="/css/common.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@600&display=swap"
	rel="stylesheet">
</head>
<body>

	<div class="container-fluid">
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
					<div class="image-item" data-event-id="3"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="rank-number">3</div>
						<div class="image-text">Sample 3</div>
					</div>
					<div class="image-item" data-event-id="4"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="rank-number">4</div>
						<div class="image-text">Sample 4</div>
					</div>
					<div class="image-item" data-event-id="5"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="rank-number">5</div>
						<div class="image-text">Sample 5</div>
					</div>
					<div class="loading-indicator" style="display: none;"></div>
					<div class="scroll-indicator" id="rankScrollIndicator"></div>
				</div>
				<button class="slider-btn left"
					onclick="scrollContainer('rankcontainer', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('rankcontainer', 'right')">&#10095;</button>
			</div>
		</div>
		<!-- Example Container 0 -->
		<div class="row">
			<div class="col-12">
				<div class="title-container">
					<h2>검색</h2>
					<%@ include file="/WEB-INF/views/filter_form.jsp"%>
				</div>
			</div>
			<div class="col-12 position-relative">
				<div class="box-container" id="searchcontainer">
					<div class="image-item" data-event-id="1"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">위</div>
					</div>
					<div class="image-item" data-event-id="2"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">검색 기능을</div>
					</div>
					<div class="image-item" data-event-id="3"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">사용해 보세요!</div>
					</div>
					<div class="image-item" data-event-id="4"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Ferr!</div>
					</div>
					<div class="image-item" data-event-id="5"
						onclick="redirectToEventDetail(this.getAttribute('data-event-id'));">
						<div class="image-text">Ferr!</div>
					</div>
					<div class="loading-indicator" style="display: none;"></div>
					<div class="scroll-indicator" id="searchScrollIndicator"></div>
				</div>
				<button class="slider-btn left"
					onclick="scrollContainer('searchcontainer', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('searchcontainer', 'right')">&#10095;</button>
			</div>
		</div>

		<div class="row">
			<div class="col-12">
				<div class="title-container">
					<h2>추천</h2>
				</div>
			</div>
			<div class="col-12 position-relative">
				<div class="box-container" id="recommendcontainer">
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
					<div class="loading-indicator" style="display: none;"></div>
					<div class="scroll-indicator" id="recommendScrollIndicator"></div>
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
					<h2>주변</h2>
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
					<div class="loading-indicator" style="display: none;"></div>
					<div class="scroll-indicator" id="locationScrollIndicator"></div>
				</div>
				<button class="slider-btn left"
					onclick="scrollContainer('mylocationcontainer', 'left')">&#10094;</button>
				<button class="slider-btn right"
					onclick="scrollContainer('mylocationcontainer', 'right')">&#10095;</button>
			</div>
		</div>
	</div>

	<footer class="text-center text-lg-start bg-light text-muted"
		style="background-color: #f8f9fa !important;">
		<!-- Section: Social media -->
		<section
			class="d-flex justify-content-center justify-content-lg-between p-4 border-bottom">
			<!-- Left -->
			<div class="me-5 d-none d-lg-block">
				<span>저희를 소셜 미디어에서 만나보세요:</span>
			</div>
			<!-- Left -->
			<!-- Right -->
			<div>
				<a href="" class="me-4 text-reset"> <i class="fab fa-facebook-f"></i>
				</a> <a href="" class="me-4 text-reset"> <i class="fab fa-twitter"></i>
				</a> <a href="" class="me-4 text-reset"> <i class="fab fa-google"></i>
				</a> <a href="" class="me-4 text-reset"> <i class="fab fa-instagram"></i>
				</a> <a href="https://github.com/m0p4rk" class="me-4 text-reset"> <i
					class="fab fa-github"></i>
				</a>
			</div>
			<!-- Right -->
		</section>
		<!-- Section: Social media -->

		<!-- Section: Links  -->
		<section class="">
			<div class="container text-center text-md-start mt-5">
				<div class="row mt-3">
					<!-- Grid column -->
					<div class="col-md-3 col-lg-4 col-xl-3 mx-auto mb-4">
						<!-- Content -->
						<h6 class="text-uppercase fw-bold mb-4">
							<i class="fas fa-gem me-3"></i>Ferr
						</h6>
						<p>Subtitle</p>
					</div>
					<!-- Grid column -->


					<!-- Grid column -->

					<!-- Grid column -->
					<div class="col-md-3 col-lg-2 col-xl-2 mx-auto mb-4">
						<!-- Links -->
						<h6 class="text-uppercase fw-bold mb-4">사이트 맵</h6>
						<p>
							<a href="#!" class="text-reset">후기/일지</a>
						</p>
						<p>
							<a href="#!" class="text-reset">통합검색</a>
						</p>
						<p>
							<a href="#!" class="text-reset">마이페이지</a>
						</p>
						<p>
							<a href="#!" class="text-reset">회원가입</a>
						</p>
					</div>
					<!-- Grid column -->

					<!-- Grid column -->
					<div class="col-md-4 col-lg-3 col-xl-3 mx-auto mb-md-0 mb-4">
						<!-- Links -->
						<h6 class="text-uppercase fw-bold mb-4">연락처</h6>
						<p>
							<i class="fas fa-home me-3"></i> Ferr, KR
						</p>
						<p>
							<i class="fas fa-envelope me-3"></i> example@google.com
						</p>
						<p>
							<i class="fas fa-phone me-3"></i> + 02 123 4567
						</p>
						<p>
							<i class="fas fa-print me-3"></i> + 02 123 4568
						</p>
					</div>
					<!-- Grid column -->
				</div>
			</div>

		</section>

	</footer>
	<!-- Footer -->




	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script src="/js/main.js"></script>

</body>
</html>
