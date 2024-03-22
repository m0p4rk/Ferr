<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Event Details</title>
<link rel="stylesheet"
    href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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
                <!-- 일정생성 버튼 추가 -->
                <c:if test="${empty sessionScope.userId}">
                    <button onclick="alert('로그인이 필요합니다.');" class="btn btn-primary">일정 생성</button>
                </c:if>
                <c:if test="${not empty sessionScope.userId}">
                    <button onclick="openCreateScheduleModal();" class="btn btn-primary">일정 생성</button>
                </c:if>

            </div>
        </div>
    </div>
	    <div class="modal" id="scheduleModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">일정 생성</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <form id="scheduleForm">
                        <div class="form-group">
                            <label for="promiseDate">약속일:</label>
                            <input type="date" class="form-control" id="promiseDate" required>
                        </div>
                        <button type="submit" class="btn btn-primary">저장</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script
        src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script
        src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="/js/event_detail.js"></script>

<script>
    function openCreateScheduleModal() {
        $('#scheduleModal').modal('show');
    }

    $(document).ready(function() {
        $('#scheduleForm').submit(function(event) {
            event.preventDefault(); // 폼 기본 동작 방지

            // 폼에 입력된 정보 가져오기
            var promiseDate = $('#promiseDate').val();

            // 폼 데이터 생성
            var formData = {
                promise_date: promiseDate
                // 다른 필요한 입력 항목을 여기에 추가하세요
            };

            // 서버로 데이터 전송
            $.ajax({
                type: 'POST',
                url: '/createSchedule',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                success: function(response) {
                    console.log('일정이 성공적으로 저장되었습니다.');
                    // 성공 시 필요한 처리 작업 추가
                },
                error: function(xhr, status, error) {
                    console.error('일정 저장 중 오류 발생:', error);
                    // 오류 발생 시 필요한 처리 작업 추가
                }
            });
        });
    });
</script>
</body>
</html>