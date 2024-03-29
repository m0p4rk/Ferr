// 삭제 버튼 클릭 시 호출되는 함수
    function deleteNote(notificationId) {
    $.ajax({
        url: '/notification/delete/' + notificationId,
        type: 'POST',
        contentType: 'application/json',
        success: function(response) {
            alert('알림이 삭제되었습니다.');
            // 성공 시 노트 목록 다시 로드
            $('#loadNotesBtn').click();
        },
        error: function(xhr, status, error) {
            alert('노트 삭제 중 오류가 발생했습니다: ' + error);
        }
    });
}

// 위 전역 함수를 제외한 모든 기능은 여기부터 구현됨 참고하세요
$(document).ready(function() {
    var eventId = $('#eventId').val(); // 이벤트 ID를 저장
    
    navigator.geolocation.getCurrentPosition(function(position) {
            var currentlatitude = position.coords.latitude;
            var currentlongitude = position.coords.longitude;
            // 현재 위치 날씨 정보 가져오기
            $.ajax({
                url: 'https://api.openweathermap.org/data/2.5/weather?lat=' + currentlatitude + '&lon=' + currentlongitude + '&appid=a62c831d0ac8f869133bcde70421b3b5',
                method: 'GET',
                success: function(response) {
                    var weatherInfo = '날씨: ' + response.weather[0].main + ', 온도: ' + (response.main.temp - 273.15).toFixed(1) + '°C';
                    $('#weatherInfo').html(weatherInfo);
                },
                error: function(xhr, status, error) {
                    console.error('날씨 정보를 불러오는 중 오류 발생:', error);
                }
            });
        });
        
    navigator.geolocation.getCurrentPosition(function(position) {
            var currentlatitude = position.coords.latitude;
            var currentlongitude = position.coords.longitude;
            var mapContainer = document.getElementById('map');
            var centerPosition = new kakao.maps.LatLng(currentlatitude, currentlongitude);
            var mapOption = {
                center: centerPosition,
                level: 8
            };
            var map = new kakao.maps.Map(mapContainer, mapOption);
            var marker = new kakao.maps.Marker({ position: centerPosition });
            marker.setMap(map);
        });
        
    $('#viewRouteBtn').on('click', function() {
            // 카카오 지도 길찾기 URL 생성 : 목적지만 지정 가능
            var destinationName = "Gyeongbokgung Palace"; // 목적지 이름 예시
            var destinationLatitude = 37.577445; // 목적지 위도 예시
            var destinationLongitude = 126.976953; // 목적지 경도 예시
            var kakaoMapUrl = 'https://map.kakao.com/link/to/' + destinationName + ',' + destinationLatitude + ',' + destinationLongitude;
            // 팝업으로 카카오 지도창 띄우기
            window.open(kakaoMapUrl, '_blank');
        });

    // 약속 날짜 변경
    $('#promiseDate').change(function() {
        var newDate = $(this).val();
        $.ajax({
            url: '/schedule-detail/update/date/' + eventId,
            type: 'POST',
            data: { promiseDate: newDate },
            success: function(response) {
                alert('약속 날짜가 성공적으로 업데이트되었습니다.');
            },
            error: function(xhr, status, error) {
                alert('약속 날짜 업데이트 중 오류가 발생했습니다: ' + error);
            }
        });
    });

    // 새로운 알림 추가
    $('#addNoteBtn').click(function() {
        var noteContent = $('#noteContent').val();
        var noteDateTime = $('#noteDateTime').val();
        var data = {
            eventId: eventId,
            content: noteContent,
            notificationTime: noteDateTime
        };

        $.ajax({
            url: '/newNotification',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function(response) {
                alert('알림이 추가되었습니다.');
                // 성공 시 노트 목록 갱신 등의 추가 작업 수행
            },
            error: function(xhr, status, error) {
                alert('알림 추가 중 오류가 발생했습니다: ' + error);
            }
        });
    });

    // 알림 수정
    $('#saveNoteChanges').click(function() {
        var noteId = $('#editNoteId').val();
        var updatedContent = $('#editNoteContent').val();
        var updatedDateTime = $('#editNoteDateTime').val();
        var data = {
            notificationId: noteId,
            eventId: parseInt($('#eventId').val()), // eventId 값을 정수로 변환
            content: updatedContent,
            notificationTime: updatedDateTime
        };

        $.ajax({
            url: '/notification/update',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function(response) {
                alert('알림이 업데이트되었습니다.');
                $('#loadNotesBtn').click();
            },
            error: function(xhr, status, error) {
                alert('알림 업데이트 중 오류가 발생했습니다: ' + error);
            }
        });
    });

    var isNotesVisible = false; // 알림 목록 온오프 변수
    var isNotesLoaded = false;

    $('#loadNotesBtn').click(function() {
        // 버튼의 현재 상태에 따라 텍스트와 색상을 토글
        if (!isNotesVisible) {
            // 목록이 숨겨진 상태면 불러오기
            $(this).text("알림 목록 가리기");
            $(this).removeClass("btn-info").addClass("btn-secondary");

            if (!isNotesLoaded) {
                // 알림 목록을 처음 불러오는 경우에만 요청 수행
                var eventId = $('#eventId').val(); // 이벤트 ID를 HTML 요소로부터 가져옵니다.
                $.ajax({
                    url: '/getNotifications',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({eventId: parseInt(eventId)}), // 이벤트 ID를 정수로 변환하여 JSON 객체로 포장합니다.
                    success: function (notifications) {
                        $('#notesList').empty(); // 기존에 표시된 노트 목록을 비웁니다.
                        notifications.forEach(function (notification) {
                            // 서버로부터 반환된 날짜를 Date 객체로 변환합니다.
                            var notificationId = notification.notificationId;
                            var notificationDate = new Date(notification.notificationTime);
                            var notificationContent = notification.content;
                            console.log(notificationId);
                            // 사용자가 읽기 쉬운 형태로 날짜를 포맷팅합니다.
                            var formattedDate = notificationDate.toLocaleString('ko-KR', {
                                year: 'numeric', month: '2-digit', day: '2-digit',
                                hour: '2-digit', minute: '2-digit', second: '2-digit',
                                hour12: false
                            });
                            // 포맷팅된 날짜와 노트 내용을 포함하는 HTML 요소를 생성하여 노트 목록에 추가합니다.
                            $('#notesList').append(`
                                <div class="note-item" data-note-id="${notificationId}">
                                    <p>${notificationContent} - ${formattedDate}</p>
                                    <button class="btn btn-secondary btn-sm edit-note-btn" data-toggle="modal" data-target="#editNoteModal">수정</button>
                                    <button class="btn btn-danger btn-sm delete-note-btn" onclick="deleteNote(${notificationId})">삭제</button>
                                    <input type="hidden" id="editNoteId" value="${notificationId}">
                                </div>
                            `);
                        });
                        isNotesLoaded = true;
                        $('#notesList').show();
                        isNotesVisible = true;
                    },
                    error: function (xhr, status, error) {
                        alert('알림 불러오기 중 오류가 발생했습니다: ' + error);
                    }
                });
            } else {
                // 이미 불러온 목록이 있을때
                $('#notesList').show();
                isNotesVisible = true;
            }
        } else {
            $(this).text("알림 불러오기");
            $(this).removeClass("btn-secondary").addClass("btn-info");
            $('#notesList').hide(); // 노트 목록을 숨깁니다.
            isNotesVisible = false;
        }
    });

    // 페이지가 로드될 때 실행되는 부분
    $('#deleteButton').click(function() {
        // 일정 삭제 버튼이 클릭되었을 때 실행되는 부분
        if (confirm("정말 이 일정을 삭제하시겠습니까?")) {
            // 사용자가 확인을 누르면 실행되는 부분
            $.ajax({
                url: '/schedule-detail/delete/' + eventId,
                type: 'GET',
                success: function(response) {
                    alert('일정이 성공적으로 삭제되었습니다.');
                    window.location.href = '/dashboard-schedule';
                },
                error: function(xhr, status, error) {
                    alert('일정 삭제 중 오류가 발생했습니다: ' + error);
                }
            });
        }
    });
});
