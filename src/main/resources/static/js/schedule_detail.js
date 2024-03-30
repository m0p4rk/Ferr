var eventId = $(this).data('eventId');

// 알림 삭제 버튼 클릭 시 호출되는 함수
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
        var currentLatitude = position.coords.latitude;
        var currentLongitude = position.coords.longitude;

        // 현재 위치의 날씨 정보 가져오기
        getWeatherInfo(currentLatitude, currentLongitude, "현재 위치");

        // 서버에서 축제장소 위도 경도 받아오는 로직 
        $.ajax({
            url: '/destination/' + eventId,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                var latitude = response.latitude;
                var longitude = response.longitude;

                // 목적지의 날씨 정보 가져오기
                getWeatherInfo(latitude, longitude, "축제 위치");

                var mapContainer = document.getElementById('map'); // 지도를 표시할 div
                var mapOption = {
                    center: new kakao.maps.LatLng(currentLatitude, currentLongitude), // 중심좌표: 현재 위치
                    level: 8
                };

                var map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성

                // 목적지 마커 생성 및 표시
                var destinationPosition = new kakao.maps.LatLng(latitude, longitude);
                new kakao.maps.Marker({
                    map: map,
                    position: destinationPosition
                });

                // 현재 위치 마커 생성 및 표시
                new kakao.maps.Marker({
                    map: map,
                    position: new kakao.maps.LatLng(currentLatitude, currentLongitude)
                });

                // UI 업데이트 함수 호출, 현재 위치 정보도 전달
                updateUI(latitude, longitude, currentLatitude, currentLongitude);
            },
            error: function(xhr, status, error) {
                console.error('목적지 좌표를 가져오는 중 오류 발생:', error);
            }
        });
    });

    function getWeatherInfo(latitude, longitude, locationName) {
        $.ajax({
            url: 'https://api.openweathermap.org/data/2.5/weather?lat=' + latitude + '&lon=' + longitude + '&appid=a62c831d0ac8f869133bcde70421b3b5',
            method: 'GET',
            success: function(weatherResponse) {
                var weatherInfo = `${locationName} 날씨: ${weatherResponse.weather[0].main}, 온도: ${(weatherResponse.main.temp - 273.15).toFixed(1)}°C`;
                $('#weatherInfo').append(`<p>${weatherInfo}</p>`);
            },
            error: function(xhr, status, error) {
                console.error(`${locationName} 날씨 정보를 불러오는 중 오류 발생:`, error);
            }
        });
    }
    
    function checkIsAwesomeTemp(humidity, temperature) {
    let lowerBound, upperBound;

    if (humidity >= 10 && humidity < 20) {
        lowerBound = 20;
        upperBound = 22;
    } else if (humidity >= 20 && humidity < 40) {
        lowerBound = 19;
        upperBound = 21;
    } else if (humidity >= 40 && humidity < 60) {
        lowerBound = 18;
        upperBound = 20;
    } else if (humidity >= 60 && humidity < 80) {
        lowerBound = 17;
        upperBound = 19;
    } else if (humidity >= 80 && humidity <= 100) {
        lowerBound = 16;
        upperBound = 18;
    } else {
        console.log("습도가 적절한 범위를 벗어났습니다.");
        return;
    }

    if (temperature < lowerBound) {
        return '현재 기온에 비해 습도가 높은 편입니다. 다소 불쾌한 날씨일 수 있습니다.<br>'
    } else if (temperature >= lowerBound && temperature <= upperBound) {
        return '현재 기온에 맞는 적절한 습도입니다. 상쾌한 하루 보내세요.<br>'
    } else {
        return '현재 기온에 비해 습도가 낮은 편입니다. 보습제를 바르는 것도 좋은 방법입니다. <br>';
    }
}

    function updateUI(latitude, longitude, currentLatitude, currentLongitude) {
        $('#viewRouteBtn').on('click', function() {
            // 카카오 지도 길찾기 URL 생성 및 팝업으로 띄우기
            var kakaoMapRouteUrl = `https://map.kakao.com/?sX=${currentLongitude}&sY=${currentLatitude}&sName=현재 위치&eX=${longitude}&eY=${latitude}&eName=축제장소`;
            window.open(kakaoMapRouteUrl, '_blank');
        });
    }
});


	// 약속 날짜 
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


