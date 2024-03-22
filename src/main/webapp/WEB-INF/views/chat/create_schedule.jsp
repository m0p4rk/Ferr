<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Schedule</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2>일정 생성</h2>
        <form id="scheduleForm">
            <div class="form-group">
                <label for="eventTitle">이벤트 제목</label>
                <input type="text" class="form-control" id="eventTitle" name="eventTitle">
            </div>
            <div class="form-group">
                <label for="eventStartDate">이벤트 시작일</label>
                <input type="date" class="form-control" id="eventStartDate" name="eventStartDate">
            </div>
            <div class="form-group">
                <label for="eventEndDate">이벤트 종료일</label>
                <input type="date" class="form-control" id="eventEndDate" name="eventEndDate">
            </div>
            <div class="form-group">
                <label for="latitude">위도</label>
                <input type="text" class="form-control" id="latitude" name="latitude">
            </div>
            <div class="form-group">
                <label for="longitude">경도</label>
                <input type="text" class="form-control" id="longitude" name="longitude">
            </div>
            <button type="submit" class="btn btn-primary">일정 생성</button>
        </form>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="/js/event_detail.js"></script>
    
    <script>
        $(document).ready(function() {
            $('#scheduleForm').submit(function(event) {
                event.preventDefault(); // 폼 기본 동작 방지

                // 폼에 입력된 정보 가져오기
                var eventTitle = $('#eventTitle').val();
                var eventStartDate = $('#eventStartDate').val();
                var eventEndDate = $('#eventEndDate').val();
                var latitude = $('#latitude').val();
                var longitude = $('#longitude').val();

                // 폼 데이터 생성
                var formData = {
                    eventTitle: eventTitle,
                    eventStartDate: eventStartDate,
                    eventEndDate: eventEndDate,
                    latitude: latitude,
                    longitude: longitude
                };

                // 서버로 데이터 전송
                $.ajax({
                    type: 'POST',
                    url: '/saveSchedule',
                    contentType: 'application/json',
                    data: JSON.stringify(formData),
                    success: function(response) {
                        alert('일정이 성공적으로 저장되었습니다.');
                        // 필요한 처리 작업 추가
                    },
                    error: function(xhr, status, error) {
                        console.error('일정 저장 중 오류 발생:', error);
                        // 필요한 처리 작업 추가
                    }
                });
            });
        });
    </script>
</body>
</html>

