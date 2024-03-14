<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container">
    <h2 class="mt-5">로그인</h2>
    <form action="<c:url value='/login'/>" method="post">
        <div class="form-group">
            <label for="email">이메일:</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="password">비밀번호:</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <button type="submit" class="btn btn-primary">로그인</button>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger mt-3" role="alert">
                ${errorMessage}
            </div>
        </c:if>
    </form>
    <div>
        <a href="/register">회원가입</a>
    </div>
</div>
<script src="//code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="//cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
