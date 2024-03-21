<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/navbar.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <c:forEach var="schedule" items="${schedules}" varStatus="status">
        <div class="col-md-4 mb-4">
            <!-- Update: Add event ID or other parameters as needed -->
            <div class="card h-100 card-clickable" onclick="location.href='/schedule-detail?id=${schedule.eventId}'">
                <div class="card-body bg-light">
                    <h5 class="card-title">${schedule.contentId}</h5>
                    <p class="card-text"><small>${schedule.eventTitle}</small></p>
                    <p class="card-text">
                        <small>
                            행사 기간:
                            <fmt:formatDate value="${schedule.eventStartDate}" pattern="yyyy-MM-dd" />
                            ~
                            <fmt:formatDate value="${schedule.eventEndDate}" pattern="yyyy-MM-dd" />
                        </small>
                    </p>
                    <p class="card-text"><small>약속 날짜: ${schedule.promiseDate}</small></p>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="badge bg-secondary">그룹 수: <%= (int)(Math.random() * 10) %></span>
                    </div>
                </div>
            </div>
        </div>
        </c:forEach>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.10/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.min.js"></script>
</body>
</html>
