<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Details</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .image-container img {
            max-width: 100%;
            height: auto;
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <h1 id="eventTitle" class="mb-4">상세정보</h1>

    <div class="row">
        <div class="col-md-6 image-container">
            <img id="eventImage" alt="Event Image" class="img-fluid">
        </div>
        <div class="col-md-6">
            <table class="table">
                <tbody>
                    <tr>
                        <th scope="row">주소</th>
                        <td id="eventAddress"></td>
                    </tr>
                    <tr>
                        <th scope="row">전화번호</th>
                        <td id="eventTel"></td>
                    </tr>
                    <tr>
                        <th scope="row">상세 설명</th>
                        <td id="eventOverview"></td>
                    </tr>
                </tbody>
            </table>
            
            <button id="detailInfoBtn" class="btn btn-primary">상세 정보 보기</button>
            <button id="goBackBtn" class="btn btn-secondary" style="display:none;">되돌아가기</button>
        </div>
    </div>
            <button id="createScheduleBtn" class="btn btn-primary">일정 생성</button>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="/js/event_detail.js"></script>

<script>
$('#createScheduleBtn').on('click', function() {
    window.location.href = '/create_schedule';
});
</script>
</body>
</html>

