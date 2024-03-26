<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새 게시글 작성</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<style>
.form-container {
	margin-top: 30px;
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
		<h2>새 게시글 작성</h2>
		<form action="${pageContext.request.contextPath}/reviews/add/${eventId}"
			method="post" enctype="multipart/form-data">
			<div class="form-group">
				<label for="title">제목</label> <input type="text"
					class="form-control" id="title" name="title"
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
				<label for="rating">평점</label>
				<select class="form-control" id="rating" name="rating">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
				</select>
			</div>
			<!-- userId를 hidden input으로 전송 -->
			<input type="hidden" name="userId" value="<%= userId %>">
			<input type="hidden" name="eventId" value="${eventId}">
			<button type="submit" class="btn btn-primary">게시글 작성</button>
		</form>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

</body>
</html>
