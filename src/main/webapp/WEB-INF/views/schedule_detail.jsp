<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>일정 관리 대시보드</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/common.css">
    <style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #f8f9fa;
    }
    .container {
        background: #ffffff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h1, h2 {
        color: #343a40;
    }
    .form-group, .form-row {
        margin-top: 15px;
    }
    .btn {
        margin-right: 10px;
    }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 id="eventTitle">${schedule.eventTitle}</h1><br>
        <input type="hidden" id="eventId" value="${schedule.eventId}" />
        
        <!-- 카카오맵 섹션 -->
    
<section id="mapSection" style="position: relative;">
    <div id="map" style="width: 100%; height: 400px;"></div>
    <button id="viewRouteBtn" class="btn btn-primary mt-2" style="position: absolute; bottom: 10px; right: 10px; opacity: 0.8; z-index: 1000;">경로 및 지도 상세 확인</button>
</section>




    <!-- 날씨 섹션 -->
    <section id="weatherSection">
        <h2>날씨 정보</h2>
        <div id="weatherInfo" class="weather-widget"></div>
    </section>


        <!-- 날짜 변경 섹션 -->
        <section id="promiseDateSection">
            <div class="form-group">
                <label for="promiseDate">약속 날짜:</label>
                <input type="date" class="form-control" id="promiseDate" name="promiseDate"
                       min="${schedule.eventStartDate}" max="${schedule.eventEndDate}" 
                       value="${schedule.promiseDate}" data-event-id="${schedule.eventId}">
            </div>
        </section>

        <!-- 노트 추가 섹션 -->
        <section id="noteAndAlertForm">
            <div class="form-group">
                <label for="noteContent">알림</label>
                <textarea class="form-control" id="noteContent" name="content" rows="3"></textarea>
            </div>
            <div class="form-row align-items-center">
                <div class="col-auto">
                    <label for="noteDateTime" class="sr-only">알림 예약:</label>
                    <input type="datetime-local" class="form-control mb-2" id="noteDateTime" name="date">
                </div>
                <div class="col-auto">
                    <button type="button" id="addNoteBtn" class="btn btn-primary mb-2">알림 추가</button>
                     <button id="loadNotesBtn" class="btn btn-info mb-2">알림 불러오기</button>
                </div>
               
            </div>
        </section>
        
        <div id="notesList" class="mt-3">
            <!-- 여기에 AJAX로 추가된 노트와 알림이 표시됩니다. -->
        </div>
        
        <!-- 노트 수정 모달 -->
        <div class="modal fade" id="editNoteModal" tabindex="-1" role="dialog" aria-labelledby="editNoteModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editNoteModalLabel">노트 수정</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form id="editNoteForm">
                            <div class="form-group">
                                <label for="editNoteContent">내용</label>
                                <textarea class="form-control" id="editNoteContent" rows="3"></textarea>
                            </div>
                            <div class="form-group">
                                <label for="editNoteDateTime">날짜 및 시간</label>
                                <input type="datetime-local" class="form-control" id="editNoteDateTime">
                            </div>
                            <input type="hidden" id="editNoteId">
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                        <button type="button" class="btn btn-primary" id="saveNoteChanges">저장</button>
                    </div>
                </div>
            </div>
        </div>
    

        <!-- 일정 삭제 버튼 -->
        <div class="mt-4">
            <button type="button" id="deleteButton" class="btn btn-danger" onclick="confirmDelete()">일정 삭제</button>
        </div>
    </div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9496f9be338adc74c68fd22757fd2e12&libraries=services"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script src="/js/schedule_detail.js"></script>
    <script></script>
</body>
</html>
