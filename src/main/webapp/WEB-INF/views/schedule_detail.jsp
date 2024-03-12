<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>행사 일정 관리 페이지</title>
    <!-- 부트스트랩 4 CSS 추가 -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- jQuery 추가 -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 부트스트랩 4 JS 추가 -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- 카카오맵 API JS 추가 - 실제 사용할 때는 API 키 필요 -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=여기에_카카오맵_API_키를_입력"></script>
</head>
<body>
    <div class="container">
        <!-- 여기에 페이지 내용을 추가 -->
        <h2>행사 위치와 날씨 정보</h2>
        <!-- 카카오맵을 표시할 div -->
        <div id="map" style="width:100%;height:350px;"></div>

        <h2>스크래치 노트 추가 후 알림</h2>
        <!-- 간편 노트 입력 폼 -->
        <form id="noteForm">
            <div class="form-group">
                <label for="noteContent">노트 내용:</label>
                <textarea class="form-control" id="noteContent" rows="3"></textarea>
            </div>
            <button type="submit" class="btn btn-primary">노트 추가</button>
        </form>

        <!-- 알림 모달 -->
        <div class="modal" id="alertModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <!-- 모달 헤더 -->
                    <div class="modal-header">
                        <h4 class="modal-title">알림 설정</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <!-- 모달 바디 -->
                    <div class="modal-body">
                        모달 바디에 알림 설정 폼을 추가하세요.
                    </div>
                    <!-- 모달 푸터 -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-success" data-dismiss="modal">저장</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 카카오맵 초기화 및 표시하는 스크립트
        // 날씨 API 사용하여 날씨 정보 표시하는 스크립트
        // 간편 노트 관련 스크립트
        // 알림 모달 관련 스크립트
    </script>
</body>
</html>
