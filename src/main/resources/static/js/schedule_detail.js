var eventId = $(this).data('eventId');

// 삭제 버튼 클릭 시 호출되는 함수
    function deleteNote(notificationId) {
    $.ajax({
        url: '/notification/delete/' + notificationId,
        type: 'POST', // HTTP 메서드는 서버 구현에 따라 다를 수 있습니다.
        contentType: 'application/json',
        success: function(response) {
            alert('알림이 삭제되었습니다.');
            // 성공 시 알림 목록을 다시 로드합니다.
            loadNotifications(); // 목록을 직접 새로고침
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

    $.ajax({
        url: '/destination/' + eventId,
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            var latitude = response.latitude;
            var longitude = response.longitude;

            var mapContainer = document.getElementById('map');
            var centerPosition = new kakao.maps.LatLng(currentlatitude, currentlongitude);
            var mapOption = {
                center: centerPosition,
                level: 8
            };

            var map = new kakao.maps.Map(mapContainer, mapOption);

            // 목적지의 위도와 경도를 LatLng 객체로 생성
            var destinationPosition = new kakao.maps.LatLng(latitude, longitude);
            // 목적지 마커 생성
            var destinationMarker = new kakao.maps.Marker({ position: destinationPosition });
            // 목적지 마커를 지도에 추가
            destinationMarker.setMap(map);

            var marker = new kakao.maps.Marker({ position: centerPosition });
            marker.setMap(map);
        },
        error: function(xhr, status, error) {
            console.error('목적지 좌표를 가져오는 중 오류 발생:', error);
        }
    });
});

       
      //서버에서 축제장소 위도 경도 받아오는 로직 
    $.ajax({
        url: '/destination/' + eventId,
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            var latitude = response.latitude;
			var longitude = response.longitude;
		
		// 목적지 위도와 경도를 사용하여 날씨 정보 가져오기
        $.ajax({
            url: 'https://api.openweathermap.org/data/2.5/weather?lat=' + latitude + '&lon=' + longitude + '&appid=a62c831d0ac8f869133bcde70421b3b5',
            method: 'GET',
            success: function(weatherResponse) {
                var weatherInfo = '날씨: ' + weatherResponse.weather[0].main + ', 온도: ' + (weatherResponse.main.temp - 273.15).toFixed(1) + '°C';
                // 날씨 정보를 UI에 표시
                $('#weatherInfo').html(weatherInfo);
            },
            error: function(xhr, status, error) {
                console.error('목적지 날씨 정보를 불러오는 중 오류 발생:', error);
            }
        });
        

            // UI 업데이트를 AJAX 요청 성공 콜백 함수 내부에 위치시킵니다.
            updateUI(latitude, longitude);
        },
        error: function(xhr, status, error) {
            console.error('목적지 좌표를 가져오는 중 오류 발생:', error);
        }
    });
        // UI를 업데이트하는 함수를 정의합니다.
    function updateUI(latitude, longitude) {
        // UI를 업데이트합니다.
        console.log("위도: " + latitude + ", 경도: " + longitude);
        $('#viewRouteBtn').on('click', function() {
            // 카카오 지도 길찾기 URL 생성 : 목적지만 지정 가능
            var destinationName = "축제장소"; // 목적지 이름 예시
            var kakaoMapUrl = 'https://map.kakao.com/link/to/' + destinationName + ',' + latitude + ',' + longitude;
            // 팝업으로 카카오 지도창 띄우기
            window.open(kakaoMapUrl, '_blank');
        });
    }
});


    $('#promiseDate').change(function() {
    var newDate = $(this).val();
    
    // 현재 페이지 URL에서 쿼리 매개변수 'id'의 값을 추출합니다.
    var queryParams = new URLSearchParams(window.location.search);
    var eventId = queryParams.get('id'); // 'id' 매개변수의 값을 얻습니다.

    // eventId가 존재할 경우에만 AJAX 요청을 실행합니다.
    if (eventId) {
        $.ajax({
            url: '/schedule-detail/update/date/' + eventId,
            type: 'POST',
            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
            data: { promiseDate: newDate },
            success: function(response) {
                alert('약속 날짜가 성공적으로 업데이트되었습니다.');
            },
            error: function(xhr, status, error) {
                alert('약속 날짜 업데이트 중 오류가 발생했습니다: ' + error);
            }
        });
    } else {
        alert('이벤트 ID가 URL에서 찾을 수 없습니다.');
    }
});


    var isNotesVisible = false; // 알림 목록의 표시 상태를 추적하는 변수

// 알림 목록을 불러오고 화면에 표시하는 함수
function loadNotifications() {
    var eventId = $('#eventId').val();
    $.ajax({
        url: '/getNotifications',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({eventId: parseInt(eventId)}),
        success: function (notifications) {
            $('#notesList').empty();
            notifications.forEach(function (notification) {
                var notificationId = notification.notificationId;
                var notificationDate = new Date(notification.notificationTime);
                var notificationContent = notification.content;
                var formattedDate = notificationDate.toLocaleString('ko-KR', {
                    year: 'numeric', month: '2-digit', day: '2-digit',
                    hour: '2-digit', minute: '2-digit',
                    hour12: false
                });
                $('#notesList').append(`
                    <div class="note-item" data-note-id="${notificationId}">
                        <p>${notificationContent} - ${formattedDate}</p>
                        <button class="btn btn-secondary btn-sm edit-note-btn" data-toggle="modal" data-target="#editNoteModal">수정</button>
                        <button class="btn btn-danger btn-sm delete-note-btn" onclick="deleteNote(${notificationId})">삭제</button>
                    </div>
                `);
            });
            isNotesVisible = true;
            $('#loadNotesBtn').text("알림 목록 가리기").removeClass("btn-info").addClass("btn-secondary");
            $('#notesList').show();
        },
        error: function (xhr, status, error) {
            alert('알림 불러오기 중 오류가 발생했습니다: ' + error);
        }
    });
}

// 알림 추가
$('#addNoteBtn').click(function() {
    var noteContent = $('#noteContent').val();
    var noteDateTime = $('#noteDateTime').val();
    var eventId = $('#eventId').val();

    var data = {
        eventId: parseInt(eventId),
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
            loadNotifications(); // 알림 목록을 새로고침
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
        eventId: parseInt($('#eventId').val()),
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
            loadNotifications(); // 알림 목록을 새로고침
        },
        error: function(xhr, status, error) {
            alert('알림 업데이트 중 오류가 발생했습니다: ' + error);
        }
    });
});

// 알림 목록 표시/숨김 토글
$('#loadNotesBtn').click(function() {
    if (!isNotesVisible) {
        loadNotifications();
    } else {
        // 목록을 숨깁니다.
        $('#notesList').hide();
        isNotesVisible = false;
        $(this).text("알림 불러오기").removeClass("btn-secondary").addClass("btn-info");
    }
});




    $(document).ready(function() {
    // 현재 URL에서 eventId 추출
    var urlParams = new URLSearchParams(window.location.search);
    var eventId = urlParams.get('id');

    $('#deleteButton').click(function() {
        if (confirm("정말 이 일정을 삭제하시겠습니까?")) {
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

    // 나머지 코드는 여기에 계속 작성하세요
});


