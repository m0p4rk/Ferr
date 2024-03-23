<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/navbar.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>추가한 일정 대시보드</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css">
    <style>
        .card-clickable:hover {
            cursor: pointer;
            opacity: 0.9;
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4">추가한 일정 대시보드</h2>
    <div class="row">
        <% for (int i = 0; i < 6; i++) { %>
        <div class="col-md-4 mb-4">
            <!-- 각 카드의 onclick 이벤트에서 /schedule-detail-sample로 이동하도록 변경 -->
            <div class="card h-100 card-clickable" onclick="location.href='/schedule-detail-sample';">
                <div class="card-body bg-light">
                    <h5 class="card-title">행사명 #<%= i + 1 %></h5>
                    <p class="card-text"><small>일정: 2024-03-11</small></p>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="badge bg-secondary">그룹 수: <%= (int)(Math.random() * 10) %></span>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.10/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.min.js"></script>
</body>
</html>
