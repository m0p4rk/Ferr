<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새 게시글 작성</title>
<link rel="stylesheet" href="/css/common.css">
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@600&display=swap"
	rel="stylesheet">
<style>
/* 기존 스타일 유지 */
.form-container {
	margin-top: 30px;
}

body {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 600;
}

/* 별점 스타일 */
.rating {
	text-align: left;
}

.rating>span {
	display: inline-block;
	position: relative;
	width: 1.2em; /* 별의 기본 너비 유지 */
	font-size: 30px; /* 별의 크기를 24px로 조정 */
	cursor: pointer;
}



.rating>span.active {
	color: gold;
}
</style>
</head>
<body>
	<%
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setDateHeader("Expires", 0L);

	// 세션에서 userId 가져오기
	int userId = (int) session.getAttribute("userId");
	%>
	<div class="container form-container">
		<h2>리뷰 작성</h2>
		<form
			action="${pageContext.request.contextPath}/reviews/add/${eventId}"
			method="post" enctype="multipart/form-data">
			<div class="form-group">
				<label for="title"></label>
				<label for="eventTitle" id="eventTitle"></label>
				<br>
				<input type="text" class="form-control" id="title" name="title"
					placeholder="제목을 입력하세요" required>
			</div>
			<div class="form-group">
				<label for="content">내용</label>
				<textarea class="form-control" id="content" name="content" rows="10"
					placeholder="내용을 입력하세요" required></textarea>
			</div>
			<div class="form-group">
				<label for="file">파일 첨부</label> <input type="file"
					class="form-control-file" id="file" name="file">
			</div>
			<div class="form-group">
				<label for="rating">별점</label>
				<div class="rating">
					<span data-value="1">&#9733;</span>
					<!-- 점수가 1인 별 -->
					<span data-value="2">&#9733;</span>
					<!-- 점수가 2인 별 -->
					<span data-value="3">&#9733;</span>
					<!-- 점수가 3인 별 -->
					<span data-value="4">&#9733;</span>
					<!-- 점수가 4인 별 -->
					<span data-value="5">&#9733;</span>
					<!-- 점수가 5인 별 -->
				</div>
				<!-- 실제 평점 값을 저장하는 hidden input -->
				<input type="hidden" id="rating" name="rating" value="">
			</div>

			<!-- userId를 hidden input으로 전송 -->
			<input type="hidden" name="userId" value="<%=userId%>"> <input
				type="hidden" name="eventId" value="${eventId}">
			<button type="submit" class="btn btn-primary">게시글 작성</button>
		</form>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
	<script src="/js/create_review.js"></script>
</body>
</html>
