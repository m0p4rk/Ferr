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
</head>
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
        position: relative;
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
    .note-item {
        border-top: 1px solid #9d9d9d;
        padding-top: 15px;
        margin-top: 15px;
    }
    .section-block {
        background-color: #f9f9f9;
        padding: 15px;
        border-radius: 5px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
    }
    .btn-sec {
        display: flex;
        justify-content: flex-end;
        margin-top: 20px;
        border-top: 1px solid #e0e0e0;
        padding-top: 15px;
    }
    #weatherTemp {
        width: 100%;
        margin-top: 1px;
    }
    
    .weather-display {
    display: flex;
    align-items: center;
    gap: 5px; /* 요소들 사이의 간격 */
}

.weather-widget {
    margin: 0; /* 기본 마진 제거 */
}

.alert-heading {
    margin-bottom: 20px; /* 제목과 날씨 정보 사이의 간격 조절 */
}

#weatherInfoMessage {
    margin-top: 20px; /* 메시지와 나머지 정보 사이의 간격 조절 */
}
    
    
    #tIcon {
        margin-left: 10px;
        width: 50px;
        height: auto;
    }
    
    .customOverlay {
    position: absolute;
    bottom: 25px; /* 마커 상단으로부터의 거리 */
    left: -50%; /* 중앙 정렬을 위해 */
    transform: translateX(-50%); /* 중앙 정렬을 위해 */
    border: 1px solid #ccc; /* 테두리 */
    border-radius: 4px; /* 테두리 둥글기 */
    background-color: white; /* 배경 색상 */
    padding: 5px; /* 내부 여백 */
    box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.1); /* 그림자 */
}

.title {
    display: block; /* 블록 레벨 요소로 만들기 */
    text-align: center; /* 텍스트 중앙 정렬 */
    font-weight: bold; /* 글꼴 두께 */
    color: #000; /* 글꼴 색상 */
    font-size: 14px; /* 글꼴 크기 */
}
    
</style>
<body>
    <div class="container mt-5">
        <h1 id="eventTitle" style="text-align: center">${schedule.eventTitle}</h1><br>
        <input type="hidden" id="eventId" value="${schedule.eventId}" />
        
        <!-- 카카오맵 섹션 -->
        <section id="mapSection" class="section-block" style="position: relative;">
            <div id="map" style="width: 100%; height: 400px;"></div>
            <button id="viewRouteBtn" class="btn btn-primary mt-2" style="position: absolute; bottom: 10px; right: 10px; opacity: 0.8; z-index: 1000;">경로 및 지도 상세 확인</button>
        </section>

        <!-- 날씨 섹션 -->
        <section id="weatherSection" class="section-block">
    <div class="alert">
        <h4 class="alert-heading">행사장 날씨</h4>
        <!-- 날씨 정보와 아이콘을 포함할 새로운 컨테이너 -->
        <div id="weatherDisplay" class="weather-display">
            <span id="weatherIcon"><img id="wIcon" src="" alt="Weather icon"></span>
            <span id="weatherInfo" class="weather-widget"></span>
            <span id="temperatureIcon"><img id="tIcon" src="" alt="Thermometer Icon"></span>
            <span id="weatherTemp" class="weather-widget"></span>
        </div>
        <hr>
        <div id="weatherInfoMessage" class="weather-widget alert alert-info mb-0"></div>
    </div>
</section>


        <!-- 날짜 변경 섹션 -->
        <section id="promiseDateSection" class="section-block">
            <div class="alert">
                <h4 class="alert-heading">약속 날짜</h4>
                <label for="promiseDate"></label>
                <input type="date" class="form-control" id="promiseDate" name="promiseDate"
                       min="${schedule.eventStartDate}" max="${schedule.eventEndDate}"
                       value="${schedule.promiseDate}" data-event-id="${schedule.eventId}">
            </div>
        </section>

        <!-- 노트 추가 섹션 -->
        <section id="noteAndAlertForm" class="section-block">
            <div class="alert">
                <h4 class="alert-heading">알림</h4>
                <label for="noteContent"></label>
                <textarea class="form-control" id="noteContent" name="content" rows="3"></textarea>
            </div>
            <div class="form-row align-items-center alert">
                <div class="col-auto">
                    <label for="noteDateTime" class="sr-only">알림 예약:</label>
                    <input type="datetime-local" class="form-control mb-2" id="noteDateTime" name="date">
                </div>
                <div class="col-auto">
                    <button type="button" id="addNoteBtn" class="btn btn-primary mb-2">알림 추가</button>
                    <button id="loadNotesBtn" class="btn btn-info mb-2">알림 불러오기</button>
                </div>
            </div>
            <div id="notesList" class="mt-3 alert">
                <!-- 여기에 AJAX로 추가된 노트와 알림이 표시됩니다. -->
            </div>
        </section>


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

        <section class="btn-sec">
            <!-- 후기 및 일지 작성하기 버튼 -->
            <a href="/reviews/add?eventId=${schedule.eventId}" class="btn btn-primary" style="margin-right: 12px;">후기 및 일지 작성하기</a>
            <!-- 일정 삭제 버튼 -->
            <button type="button" id="deleteButton" class="btn btn-danger">일정 삭제</button>
        </section>
    </div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9496f9be338adc74c68fd22757fd2e12&libraries=services"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script src="/js/schedule_detail.js"></script>
    <script></script>
</body>
</html>
