<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>후기게시판</title>
<link rel="stylesheet" href="/css/main.css">
<link rel="stylesheet" href="/css/common.css">
<link rel="stylesheet"
    href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@600&display=swap"
	rel="stylesheet">
<style>
body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #f8f9fa;
    }
.post-preview {
    border: 1px solid #ddd;
    padding: 15px;
    margin-bottom: 10px;
    cursor: pointer;
    background-color: #f8f8f8;
    height: 100px;
    overflow: hidden;
}

.post-preview h3, .post-preview p {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.empty-post {
    text-align: center;
    color: #999;
}

#pagination {
    display: flex;
    justify-content: center;
    padding-top: 20px;
}

#pagination a {
    color: #007bff;
    text-decoration: none;
    padding: 5px 10px;
    border: 1px solid #ddd;
    margin: 0 2px;
}

#pagination a:hover {
    background-color: #f8f8f8;
}

#pagination span {
    padding: 5px 10px;
    border: 1px solid #ddd;
    margin: 0 2px;
    background-color: #007bff;
    color: white;
}
</style>
</head>
<body>
    <%-- 캐시 방지 처리 --%>
    <%
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache, no-store");
        response.setDateHeader("Expires", 0L);
    %>
    <div class="container">
        <%-- 검색 폼 --%>
        <form action="/reviews/search" method="get">
            <div class="input-group mb-3">
                <input type="text" class="form-control" placeholder="검색어 입력"
                    name="query">
                <div class="input-group-append">
                    <button class="btn btn-outline-secondary" type="submit">검색</button>
                </div>
            </div>
        </form>
        <%-- 검색 결과 표시 --%>
        <c:choose>
            <c:when test="${not empty reviews}">
                <c:forEach items="${reviews}" var="post">
                    <div class="post-preview"
                        onclick="handlePostClick(${post.reviewId})">
                        <h3>${post.title}</h3>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-post">검색 결과가 없습니다.</div>
            </c:otherwise>
        </c:choose>
        <nav id="pagination">
            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                <c:choose>
                    <c:when test="${pageNum == currentPage}">
                        <span>${pageNum}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${pageNum}">${pageNum}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </nav>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script>
        function handlePostClick(reviewId) {
            window.location.href = '/reviews/' + reviewId;
        }
    </script>
</body>
</html>
