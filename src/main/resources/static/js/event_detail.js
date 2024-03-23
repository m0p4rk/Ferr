let contentId;

document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    contentId = urlParams.get('contentId'); // contentId는 전역 변수
    if (contentId) {
        fetchTouristDetail(contentId);
    } else {
        document.getElementById('eventTitle').textContent = 'No Event Data';
    }

    document.getElementById('detailInfoBtn').addEventListener('click', function() {
        if (contentId) {
            fetchTouristIntro(contentId);
        }
    });
});

function fetchTouristDetail(contentId) {
    const serviceKey = 'RfKadspJxs7UlgWwFxrI3lk0a6EHQS%2FAbQl5soEhqGRVItvRMVFlDBZLJHF7FEMpTq0yLcT2E9%2BFntTR%2FM8PBg%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/detailCommon1?ServiceKey=${serviceKey}&contentTypeId=15&contentId=${contentId}&MobileOS=ETC&MobileApp=AppTest&defaultYN=Y&firstImageYN=Y&areacodeYN=Y&catcodeYN=Y&addrinfoYN=Y&mapinfoYN=Y&overviewYN=Y
`;

    fetch(url)
    .then(response => response.text())
    .then(str => (new window.DOMParser()).parseFromString(str, "text/xml"))
    .then(data => {
        const item = data.getElementsByTagName("item")[0];
        if (!item) {
            document.getElementById('eventTitle').textContent = 'No Event Data Available';
            return;
        }

        const title = item.getElementsByTagName("title")[0].textContent;
        const firstImage = item.getElementsByTagName("firstimage")[0]?.textContent || '/css/img/noimage_ferr.png';
        const addr1 = item.getElementsByTagName("addr1")[0].textContent;
        const addr2 = item.getElementsByTagName("addr2")[0].textContent;
        const tel = item.getElementsByTagName("tel")[0]?.textContent || 'No Telephone Information';
        const overview = item.getElementsByTagName("overview")[0].textContent;
        const mapx = item.getElementsByTagName("mapx")[0]?.textContent || 'No mapx data';
        const mapy = item.getElementsByTagName("mapy")[0]?.textContent || 'No mapy data';

        document.getElementById('eventTitle').textContent = title;
        document.getElementById('eventImage').src = firstImage;
        document.getElementById('eventAddress').textContent = addr1 + ' ' + addr2;
        document.getElementById('eventTel').textContent = tel;
        document.getElementById('eventOverview').innerHTML = overview;
        
        sessionStorage.setItem('title', title);
        sessionStorage.setItem('mapx', mapx);
    	sessionStorage.setItem('mapy', mapy);
        
        
    })
    .catch(error => {
        console.error('Error fetching event details:', error);
        document.getElementById('eventTitle').textContent = 'Error loading event details';
    });
}

function fetchTouristIntro(contentId) {
    const serviceKey = 'RfKadspJxs7UlgWwFxrI3lk0a6EHQS%2FAbQl5soEhqGRVItvRMVFlDBZLJHF7FEMpTq0yLcT2E9%2BFntTR%2FM8PBg%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/detailIntro1?ServiceKey=${serviceKey}&contentTypeId=15&contentId=${contentId}&MobileOS=ETC&MobileApp=AppTest`;

    fetch(url)
    .then(response => response.text())
    .then(str => (new window.DOMParser()).parseFromString(str, "text/xml"))
    .then(data => {
        const item = data.getElementsByTagName("item")[0];
        if (!item) {
            console.error('Item not found in the response');
            return;
        }
            const eventStartDate = item.getElementsByTagName("eventstartdate")[0]?.textContent || 'No Start Date';
            const eventEndDate = item.getElementsByTagName("eventenddate")[0]?.textContent || 'No End Date';

            sessionStorage.setItem('eventStartDate', eventStartDate);
            sessionStorage.setItem('eventEndDate', eventEndDate);
            
        updateTableForIntro(item);
    })
    .catch(error => {
        console.error('Error fetching event intro:', error);
    });
}

function updateTableForIntro(item) {
    const eventStartDate = item.getElementsByTagName("eventstartdate")[0].textContent;
    const eventEndDate = item.getElementsByTagName("eventenddate")[0].textContent;
    const playTime = item.getElementsByTagName("playtime")[0].textContent;
    const useTimeFestival = item.getElementsByTagName("usetimefestival")[0].textContent.replace(/&lt;br&gt;/g, '<br>');

    document.querySelectorAll('.table th').forEach((th, index) => {
        switch (index) {
            case 0: th.textContent = '행사 기간'; break;
            case 1: th.textContent = '운영 시간'; break;
            case 2: th.textContent = '이용 가격'; break;
        }
    });

    document.getElementById('eventAddress').innerHTML = `시작일: ${eventStartDate}<br>종료일: ${eventEndDate}`;
    document.getElementById('eventTel').textContent = playTime;
    document.getElementById('eventOverview').innerHTML = useTimeFestival;
}

document.getElementById('detailInfoBtn').addEventListener('click', function() {
        fetchTouristIntro(contentId);
        document.getElementById('goBackBtn').style.display = 'inline-block';
        document.getElementById('detailInfoBtn').style.display = 'none';
    });


document.getElementById('goBackBtn').addEventListener('click', function() {
        fetchTouristDetail(contentId);
        document.getElementById('goBackBtn').style.display = 'none';
        document.getElementById('detailInfoBtn').style.display = 'inline-block';
    });
    
document.addEventListener('DOMContentLoaded', function() {
    // "일정 생성" 버튼 클릭 이벤트 처리: 모달을 표시합니다.
    document.getElementById('createScheduleBtn').addEventListener('click', function() {
        $('#createScheduleModal').modal('show');
    });

    // "입력" 버튼에 대한 클릭 이벤트 처리: 일정 제출 함수 호출합니다.
    document.getElementById('enterSchedule').addEventListener('click', function() {
        submitSchedule(); // 일정 제출 함수 호출
    });
});

// 일정 제출 함수
function submitSchedule() {
    // 폼에서 입력 값을 가져옵니다.
    var userId = 1; // 예시로 1을 사용. 실제로는 로그인한 사용자의 ID를 사용해야 합니다.
    var contentId = document.getElementById('contentId').value;
    var eventTitle = document.getElementById('eventTitle').textContent;
    var eventStartDate = new Date(document.getElementById('eventStartDate').textContent).toISOString();
    var eventEndDate = new Date(document.getElementById('eventEndDate').textContent).toISOString();
    var latitude = parseFloat(document.getElementById('latitude').textContent);
    var longitude = parseFloat(document.getElementById('longitude').textContent);
    var promiseDate = new Date(document.getElementById('startDate').value).toISOString();

    // AJAX 요청을 사용하여 서버에 데이터 전송
    $.ajax({
        url: '/saveSchedule', // 요청을 보낼 서버의 URL 주소
        type: 'POST', // HTTP 요청 방식 (GET, POST 등)
        contentType: 'application/json', // 보내는 데이터 타입
        data: JSON.stringify({
            userId: userId,
            contentId: contentId,
            eventTitle: eventTitle,
            eventStartDate: eventStartDate,
            eventEndDate: eventEndDate,
            latitude: latitude,
            longitude: longitude,
            promiseDate: promiseDate
        }), // 서버로 보낼 데이터
        success: function(response) {
            // 요청 성공 시 처리
            alert(response); // 응답 메시지 알림
            $('#createScheduleModal').modal('hide'); // 모달 숨기기
        },
        error: function(xhr, status, error) {
            // 요청 실패 시 처리
            alert("일정 저장에 실패하였습니다: " + error);
        }
    });
}





