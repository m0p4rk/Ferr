<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Review Detail</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<style>
.post-detail-container, .comments-section {
	background-color: #f8f8f8;
	padding: 15px;
	border-radius: 5px;
	margin-bottom: 20px;
}

</style>
</head>
<body>
	<div class="container mt-3">
		<div class="post-detail-container">
			<h3>${review.title}</h3>
			<p>${review.content}</p>
			<p>
				<strong>평점: ${review.rating}</strong>
			</p>
			<p>
				<strong>첨부파일 : </strong><a href="/download/file/${fileInfo.id}">${fileInfo.filename}</a>
			</p>
			<small>작성자: ${review.userId}</small> <small>작성일:
				${review.createdAt}</small>
			<c:if
				test="${review.userId == sessionScope.loggedInUserId}">
				<button class="btn btn-primary btn-sm" data-toggle="modal"
					data-target="#editPostModal">수정</button>
				<a href="${pageContext.request.contextPath}/posts/delete/${review.reviewId}"
					class="btn btn-danger btn-sm">삭제</a>
			</c:if>
		</div>
	<!-- 게시글 수정 모달 -->
	<div class="modal fade" id="editPostModal" tabindex="-1" role="dialog"
		aria-labelledby="editPostModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="editPostModalLabel">게시글 수정</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form
						action="${pageContext.request.contextPath}/reviews/update/${review.reviewId}"
						id="editPostForm" method="post" enctype="multipart/form-data"
						 onsubmit="return validatePostForm()">
						<input type="text" class="form-control mb-2" name="title"
							value="${review.title}">
						<textarea class="form-control" name="content">${review.content}</textarea>
						<div class="form-group">
							<input type="file" class="form-control-file" id="file"
								name="file">
						</div>
						<button type="submit" class="btn btn-primary mt-2">저장</button>
					</form>
				</div>
			</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
	<script>
    function validatePostForm() {
        var titleField = document.querySelector('#editPostForm input[name="title"]');
        var contentField = document.querySelector('#editPostForm textarea[name="content"]');
        if (titleField.value.trim() === '' || contentField.value.trim() === '') {
            alert('제목과 내용을 입력하세요.');
            return false;
        }
        return true;
    }
	</script>	
</body>
</html>
