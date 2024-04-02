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

// 습도에 따른 적정 온도
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
            var mapOption = {
                center: new kakao.maps.LatLng(latitude, longitude),
                level: 4
            };

            var map = new kakao.maps.Map(mapContainer, mapOption);

            var destinationPosition = new kakao.maps.LatLng(latitude, longitude);
            var destinationMarker = new kakao.maps.Marker({
                position: destinationPosition
            });
            destinationMarker.setMap(map);

            // 커스텀 오버레이에 표시할 내용
            var content = '<div class="customOverlay">' +
                '<span class="title">행사 위치</span>' + 
                '</div>';

            // 커스텀 오버레이 생성
            var customOverlay = new kakao.maps.CustomOverlay({
                map: map,
                position: destinationPosition,
                content: content,
                yAnchor: 1 
            });
        },
        error: function(xhr, status, error) {
            console.error('축제장소 좌표를 가져오는 중 오류 발생:', error);
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
                // 날씨 온도계 사진 선택 + 온도 멘트
                var weatherVar = weatherResponse.weather[0].main;
                var weatherInfo = weatherVar;
                var temperature = (weatherResponse.main.temp - 273.15).toFixed(1);
                var weatherTemp = temperature + '°C';
                var infoMessage = '현재 기온은 ' + temperature + '°C입니다. ';
                var tempIconUrl;
                if (temperature <= -10) {
                    tempIconUrl = '/temp-img/tempCold.png'; // ~ -10
                    infoMessage += '두꺼운 옷차림으로 한파에 대비하세요. <br>';
                } else if (temperature > -10 && temperature <= 0) {
                    tempIconUrl = '/temp-img/temp1.JPG'; // -10 ~ 0
                    infoMessage += '추운 날씨에 대비하여 따뜻한 옷차림을 추천합니다. <br>';
                } else if (temperature > 0 && temperature <= 8) {
                    tempIconUrl = '/temp-img/temp2.JPG'; // 0 ~ 8
                    infoMessage += '쌀쌀한 날씨로 인해 가벼운 겉옷을 준비하시면 좋습니다. <br>';
                } else if (temperature > 8 && temperature <= 16) {
                    tempIconUrl = '/temp-img/temp3.JPG'; // 8 ~ 16
                    infoMessage += '선선한 날씨로, 외출하기 좋은 날씨입니다. <br>';
                } else if (temperature > 16 && temperature <= 23) {
                    tempIconUrl = '/temp-img/temp4.JPG'; // 16 ~ 23
                    infoMessage += '따뜻한 봄날씨로, 가벼운 옷차림을 추천합니다. <br>';
                } else if (temperature > 23 && temperature <= 28) {
                    tempIconUrl = '/temp-img/temp5.JPG'; // 23 ~ 28
                    infoMessage += '조금은 더운 여름 날씨로, 반팔을 준비하세요. <br>';
                } else if (temperature > 28 && temperature <= 33) {
                    tempIconUrl = '/temp-img/temp6.JPG'; // 28 ~ 33
                    infoMessage += '무더운 여름 날씨로, 더위 조심하시길 바랍니다. <br>';
                } else if (temperature > 33) {
                    tempIconUrl = '/temp-img/tempHot.png'; // 33 ~
                    infoMessage += '폭염에 대비하시길 바라며, 수분 섭취는 수시로 하시는 것을 권장합니다. <br>';
                } else {
                    tempIconUrl = '/temp-img/tempError.png'; // Exception(Error)
                    infoMessage += 'None;<br>';
                }
                var weatherIcon = weatherResponse.weather[0]['icon']; // 날씨 아이콘 쿼리 파라미터
                var iconurl = "http://openweathermap.org/img/w/" + weatherIcon + ".png"; // Openweather API에서 이미지 가져오기

                // 날씨 멘트
                infoMessage += '현재 행사 위치 부근 기준으로 ';
                switch (weatherVar) {
                    case "Clouds":
                        infoMessage += '대체적으로 흐린 편입니다. 혹시 모를 우천에 대비하세요. <br>';
                        break;
                    case "Rain":
                        infoMessage += '비가 내리는 중입니다. 우산을 꼭 챙기시길 바랍니다. <br>';
                        break;
                    case "Snow":
                        infoMessage += '눈이 내리는 중입니다. 미끄러운 빙판길에 유의하세요. <br>';
                        break;
                    case "Clear":
                        infoMessage += '하늘이 아주 맑습니다. 기분 좋게 외출하기 좋을 것 같습니다. <br>';
                        break;
                    default:
                        infoMessage += 'None;<br>';
                }

                // 풍속 멘트
                var windSpeed = weatherResponse.wind['speed'].toFixed(0);
                infoMessage += '풍속은 현재 ' + windSpeed + 'm/s로 ';
                if (windSpeed >= 0 && windSpeed <= 2) {
                    infoMessage += '바람이 거의 느껴지지 않는 조용한 날입니다. <br>';
                } else if (windSpeed >= 3 && windSpeed <= 5) {
                    infoMessage += '가벼운 바람이 불어 산책하기 좋은 날씨입니다. <br>';
                } else if (windSpeed >= 6 && windSpeed <= 9) {
                    infoMessage += '바람이 조금씩 불고 있습니다. <br>';
                } else if (windSpeed >= 10 && windSpeed <= 14) {
                    infoMessage += '다소 강한 바람입니다. <br>';
                } else if (windSpeed >= 15 && windSpeed <= 19) {
                    infoMessage += '강한 바람이 불어 우산 사용 시 날아가지 않게 유의하세요. <br>';
                } else if (windSpeed >= 20 && windSpeed <= 24) {
                    infoMessage += '매우 강한 바람이 불고 있습니다. 실내에 머무르시는 것이 좋겠습니다. <br>';
                } else if (windSpeed >= 25) {
                    infoMessage += '안전한 곳에 대피하신 후 폭풍에 대비하세요. <br>';
                } else {
                    infoMessage += 'None;<br>';
                }

                // 온도에 따른 습도 멘트
                var humidity = weatherResponse.main['humidity'];
                infoMessage += '습도는 ' + humidity + '%로, ';
                infoMessage += checkIsAwesomeTemp(humidity, temperature);

                // 날씨 정보를 UI에 표시
                $('#weatherInfo').html(weatherInfo);
                $('#weatherTemp').html(weatherTemp);
                $('#wIcon').attr('src', iconurl);
                $('#tIcon').attr('src', tempIconUrl);
                $('#weatherInfoMessage').html(infoMessage);
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
        // 목적지 이름
        var destinationName = "축제장소";

        // 모바일 디바이스에서 카카오맵 앱을 바로 열기 위한 링크 생성
        var kakaoMapMobileUrl = 'kakaomap://route?sp=' + latitude + ',' + longitude + '&ep=' + latitude + ',' + longitude + '&by=FOOT';

        // 모바일 환경인지 확인
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        if (isMobile) {
            // 모바일 환경이라면, 카카오맵 앱 링크 사용
            window.open(kakaoMapMobileUrl, '_blank');
        } else {
            // PC 환경이라면, 웹 URL 사용
            var kakaoMapWebUrl = 'https://map.kakao.com/link/to/' + encodeURIComponent(destinationName) + ',' + latitude + ',' + longitude;
            window.open(kakaoMapWebUrl, '_blank');
        }
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
        error: function(xhr) {
            switch (xhr.status) {
                case 400:
                    alert('지난 날짜를 지정할 수 없습니다.');
                    break;
                case 500:
                    alert('서버 내부 오류입니다. 나중에 다시 시도해주세요.');
                    break;
                default:
                    alert('알림 추가 중 알 수 없는 오류가 발생했습니다.');
                    break;
            }
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


