<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>행사 일정 관리 페이지</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=여기에_카카오맵_API_키를_입력"></script>
</head>
<body>
    <div class="container">
        <h2>행사 위치와 날씨 정보</h2>
        <div id="map" style="width:100%;height:350px;"></div>

        <h2>스크래치 노트 추가 후 알림</h2>
        <form id="noteForm">
            <div class="form-group">
                <label for="noteContent">노트 내용:</label>
                <textarea class="form-control" id="noteContent" rows="3"></textarea>
            </div>
            <button type="submit" class="btn btn-primary">노트 추가</button>
        </form>

        <!-- 일정 생성 버튼 추가 -->
        <button type="button" class="btn btn-warning mt-3" id="createSchedule">일정 생성/추가</button>

        <div class="modal" id="alertModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">알림 설정</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        모달 바디에 알림 설정 폼을 추가하세요.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-success" data-dismiss="modal">저장</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            $('#createSchedule').click(function() {
                window.location.href = '/schedulelist';
            });
        });
    </script>
</body>
</html>
