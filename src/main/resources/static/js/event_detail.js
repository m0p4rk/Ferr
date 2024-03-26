let contentId;

document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    contentId = urlParams.get('contentId'); // contentId는 전역 변수
    if (contentId) {
        fetchTouristDetail(contentId);
        fetchTouristIntro(contentId);
    } else {
        document.getElementById('eventTitle').textContent = 'No Event Data';
    }
});

function fetchTouristDetail(contentId) {
    const serviceKey = 'RfKadspJxs7UlgWwFxrI3lk0a6EHQS%2FAbQl5soEhqGRVItvRMVFlDBZLJHF7FEMpTq0yLcT2E9%2BFntTR%2FM8PBg%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/detailCommon1?ServiceKey=${serviceKey}&contentTypeId=15&contentId=${contentId}&MobileOS=ETC&MobileApp=AppTest&defaultYN=Y&firstImageYN=Y&areacodeYN=Y&catcodeYN=Y&addrinfoYN=Y&mapinfoYN=Y&overviewYN=Y`;

    fetch(url)
        .then(response => response.text())
        .then(str => (new window.DOMParser()).parseFromString(str, "text/xml"))
        .then(data => {
            const item = data.getElementsByTagName("item")[0];
            if (!item) {
                document.getElementById('eventTitle').textContent = 'No Event Data Available';
                return;
            }

            // 기본 정보 추출
            const title = item.getElementsByTagName("title")[0].textContent;
            const firstImage = item.getElementsByTagName("firstimage")[0]?.textContent || '/css/img/noimage_ferr.png';
            /*const firstImage2 = item.getElementsByTagName("firstimage2")[0]?.textContent || '/css/img/noimage_ferr.png';*/
            const addr1 = item.getElementsByTagName("addr1")[0].textContent;
            const addr2 = item.getElementsByTagName("addr2")[0]?.textContent || '';
            const tel = item.getElementsByTagName("tel")[0]?.textContent || 'No Telephone Information';
            const overview = item.getElementsByTagName("overview")[0].textContent;
            const mapx = item.getElementsByTagName("mapx")[0]?.textContent || 'No mapx data';
            const mapy = item.getElementsByTagName("mapy")[0]?.textContent || 'No mapy data';

            // 페이지 요소에 데이터 할당
            document.getElementById('eventTitle').textContent = title;
            document.getElementById('eventImage').src = firstImage;
            /*document.getElementById('eventImage2').src = firstImage2;*/
            document.getElementById('eventAddress').textContent = `${addr1} ${addr2}`;
            document.getElementById('eventTel').textContent = tel;
            document.getElementById('eventOverview').innerHTML = overview;

            // 세션 스토리지에 저장할 객체 업데이트
            let eventInfo = sessionStorage.getItem('eventInfo') ? JSON.parse(sessionStorage.getItem('eventInfo')) : {};
            eventInfo.contentId = contentId;
            eventInfo.title = title;
            eventInfo.firstImage = firstImage;
            eventInfo.address = `${addr1} ${addr2}`;
            eventInfo.tel = tel;
            eventInfo.overview = overview;
            eventInfo.mapx = mapx;
            eventInfo.mapy = mapy;
            sessionStorage.setItem('eventInfo', JSON.stringify(eventInfo));
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

            // 소개 정보 추출
            const eventStartDate = item.getElementsByTagName("eventstartdate")[0]?.textContent || 'No Start Date';
            const eventEndDate = item.getElementsByTagName("eventenddate")[0]?.textContent || 'No End Date';
            const playTime = item.getElementsByTagName("playtime")[0]?.textContent || 'No Play Time';
            const useTimeFestival = item.getElementsByTagName("usetimefestival")[0]?.textContent.replace(/&lt;br&gt;/g, '<br>') || 'No Festival Use Time Information';

            // 페이지 요소에 직접 할당
            document.getElementById('eventStartDate').textContent = eventStartDate;
            document.getElementById('eventEndDate').textContent = eventEndDate;
            document.getElementById('playTime').textContent = playTime;
            document.getElementById('useTimeFestival').innerHTML = useTimeFestival;

            // 세션 스토리지에서 이벤트 정보 객체 가져오기
            let eventInfo = sessionStorage.getItem('eventInfo') ? JSON.parse(sessionStorage.getItem('eventInfo')) : {};

            // 이벤트 정보 객체에 소개 정보 추가
            eventInfo.eventStartDate = eventStartDate;
            eventInfo.eventEndDate = eventEndDate;
            eventInfo.playTime = playTime;
            eventInfo.useTimeFestival = useTimeFestival;

            // 세션 스토리지에 업데이트된 객체 저장
            sessionStorage.setItem('eventInfo', JSON.stringify(eventInfo));
        })
        .catch(error => {
            console.error('Error fetching event intro:', error);
        });
}

$(document).ready(function() {
    // "일정 생성" 버튼 클릭 이벤트 처리: 모달을 표시합니다.
    $('#createScheduleBtn').click(function() {
        $('#createScheduleModal').modal('show');
    });

    // 모달이 로드될 때 실행
    $('#createScheduleModal').on('show.bs.modal', function(e) {
        // 세션 스토리지에서 이벤트 정보 가져오기
        const eventInfo = JSON.parse(sessionStorage.getItem('eventInfo') || '{}');

        // 도착 위치 설정 및 readonly 속성 추가
        $('#arrivalLocation').val(eventInfo.address).prop('readonly', true);

        // 콘솔에 eventInfo 객체 및 address 출력
        console.log('Loaded eventInfo:', eventInfo);
        console.log('loaded address:', eventInfo.address);

        // 현재 위치 가져오기
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                $('#departureLocation').val(`위도: ${position.coords.latitude}, 경도: ${position.coords.longitude}`);
            }, function() {
                alert('현재 위치를 가져올 수 없습니다.');
            });
        } else {
            alert('이 브라우저에서는 Geolocation이 지원되지 않습니다.');
        }

        // 출발 날짜의 선택 가능한 최소 및 최대 값을 설정 및 오늘 날짜를 디폴트로 설정
        const today = new Date().toISOString().split('T')[0];
        let startDateFormatted = formatDate(eventInfo.eventStartDate);
        let endDateFormatted = formatDate(eventInfo.eventEndDate);

        $('#startDate').attr('min', startDateFormatted)
                       .attr('max', endDateFormatted)
                       .val(today); // 오늘 날짜를 디폴트 값으로 설정
    });

    // "입력" 버튼에 대한 클릭 이벤트 처리: 일정 제출 함수 호출합니다.
    $('#enterSchedule').click(function() {
        submitSchedule(); // 일정 제출 함수 호출
    });
});

// YYYYMMDD 형식의 날짜 문자열을 YYYY-MM-DD 형식으로 변환하는 함수
function formatDate(dateStr) {
    if (!dateStr || dateStr.length !== 8) return '2020-01-01'; // 기본값 반환
    return `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6)}`;
}

// userId를 서버로부터 가져오는 함수
function fetchUserId() {
    return fetch('/api/userId')
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to fetch userId');
            }
            return response.text();
        })
        .catch(error => {
            console.error('Error fetching userId:', error);
            throw error;
        });
}

// 일정 제출 함수
function submitSchedule() {
    fetchUserId().then(userId => {
        const eventInfo = JSON.parse(sessionStorage.getItem('eventInfo') || '{}');

        const schedule = {
            // 일정 정보
            contentId: eventInfo.contentId || '',
            eventTitle: eventInfo.title || '',
            eventStartDate: formatDate(eventInfo.eventStartDate || ''),
            eventEndDate: formatDate(eventInfo.eventEndDate || ''),
            latitude: eventInfo.mapy || 0,
            longitude: eventInfo.mapx || 0,
            promiseDate: formatDate(document.getElementById('startDate').value.replace(/-/g, '')),
            startLocation: document.getElementById('departureLocation').value
        };

        // 추가된 그룹원의 userId만 추출
        const participantUserIds = addGroupMembers.map(member => member.userId);

        fetch('/saveSchedule', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                schedule,
                participantUserIds,
                userId
            }),
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.text();
        })
        .then(result => {
            alert('일정이 성공적으로 저장되었습니다.');
            $('#createScheduleModal').modal('hide');
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();
            addGroupMembers = [];
            updateAddGroupMembersUI();
        })
        .catch(error => {
            console.error("일정 저장에 실패하였습니다:", error);
            alert("일정 저장에 실패하였습니다: " + error);
        });
    }).catch(error => {
        alert('User ID fetch failed: ' + error.message);
    });
}



let addGroupMembers = []; // 추가할 그룹원들을 저장할 배열

document.addEventListener('DOMContentLoaded', function() {
    // 사용자 검색 기능
    document.getElementById('groupMemberSearch').addEventListener('input', function() {
        const nickname = this.value.trim();
        if (nickname.length >= 2) {
            fetch(`/api/users/search?nickname=${nickname}`)
                .then(response => response.json())
                .then(data => displaySearchResults(data))
                .catch(error => console.error('Error:', error));
        } else {
            document.getElementById('searchResults').innerHTML = '';
        }
    });

    // 검색 결과 클릭 이벤트 리스너
    document.getElementById('searchResults').addEventListener('click', function(e) {
    // dataset에서 userId를 가져오는 로직 확인
    const userId = e.target.dataset.userId;
    const nickname = e.target.textContent;
    console.log(`Clicked user: ${nickname} (ID: ${userId})`); // 클릭 이벤트 확인

    // 중복 추가 방지 로직 점검
    if (userId && !addGroupMembers.some(member => member.userId === userId)) {
        console.log(`Adding user: ${nickname} (ID: ${userId}) to the group`); // 사용자 추가 로그
        addGroupMembers.push({ userId, nickname }); // 새로운 사용자 추가
        updateAddGroupMembersUI(); // 추가할 그룹원 목록 UI 업데이트
    } else {
        console.log(`User: ${nickname} (ID: ${userId}) is already in the group`); // 중복 추가 방지 로그
    }
});


    // 추가된 그룹원 목록 클릭 이벤트 리스너
    document.getElementById('addGroupMembersList').addEventListener('click', function(event) {
        const userId = event.target.dataset.userId;
        if (userId) {
            addGroupMembers = addGroupMembers.filter(member => member.userId !== userId);
            updateAddGroupMembersUI(); // UI 업데이트
        }
    });
});

// 검색 결과를 화면에 표시하는 함수
function displaySearchResults(users) {
    const searchResults = document.getElementById('searchResults');
    searchResults.innerHTML = ''; // 이전 검색 결과를 초기화
    users.forEach(user => {
        const userElement = document.createElement('div');
        userElement.textContent = user.nickname; // 사용자 닉네임 표시
        userElement.dataset.userId = user.userId; // dataset에 userId 저장
        searchResults.appendChild(userElement);
    });
}

// 추가할 그룹원 목록 UI를 업데이트하는 함수
function updateAddGroupMembersUI() {
    const list = document.getElementById('addGroupMembersList');
    list.innerHTML = ''; // 목록 초기화
    addGroupMembers.forEach(member => {
        const li = document.createElement('li');
        li.textContent = member.nickname; // 닉네임 표시
        li.dataset.userId = member.userId; // 데이터 속성에 userId 저장
        li.classList.add('list-group-item');
        list.appendChild(li);
    });
}
