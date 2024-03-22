

document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
  	const contentId = urlParams.get('contentId');
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
    const serviceKey = 'UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D';
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
        const firstImage = item.getElementsByTagName("firstimage")[0]?.textContent || 'path/to/default/image.jpg';
        const addr1 = item.getElementsByTagName("addr1")[0].textContent;
        const tel = item.getElementsByTagName("tel")[0]?.textContent || 'No Telephone Information';
        const overview = item.getElementsByTagName("overview")[0].textContent;

        document.getElementById('eventTitle').textContent = title;
        document.getElementById('eventImage').src = firstImage;
        document.getElementById('eventAddress').textContent = addr1;
        document.getElementById('eventTel').textContent = tel;
        document.getElementById('eventOverview').innerHTML = overview;
    })
    .catch(error => {
        console.error('Error fetching event details:', error);
        document.getElementById('eventTitle').textContent = 'Error loading event details';
    });
}

function fetchTouristIntro(contentId) {
    const serviceKey = 'UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D';
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

        // 수정된 부분: 동적으로 테이블 헤더와 내용 업데이트
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

    // 동적으로 테이블 헤더 변경
    document.querySelectorAll('.table th').forEach((th, index) => {
        switch (index) {
            case 0: th.textContent = '행사 기간'; break;
            case 1: th.textContent = '운영 시간'; break;
            case 2: th.textContent = '이용 가격'; break;
        }
    });

    // 테이블 내용 업데이트
    document.getElementById('eventAddress').innerHTML = `시작일: ${eventStartDate}<br>종료일: ${eventEndDate}`;
    document.getElementById('eventTel').textContent = playTime;
    document.getElementById('eventOverview').innerHTML = useTimeFestival;
}

document.getElementById('goBackBtn').addEventListener('click', function() {
    // 초기 행사 상세 정보를 다시 불러옵니다.
    fetchTouristDetail(contentId);

    // "되돌아가기" 버튼을 숨기고 "상세 정보 보기" 버튼을 다시 보이게 합니다.
    document.getElementById('goBackBtn').style.display = 'none';
    document.getElementById('detailInfoBtn').style.display = 'inline-block';
});

document.getElementById('detailInfoBtn').addEventListener('click', function() {
    if (contentId) {
        fetchTouristIntro(contentId);

        // "되돌아가기" 버튼을 보이게 하고 "상세 정보 보기" 버튼을 숨깁니다.
        document.getElementById('goBackBtn').style.display = 'inline-block';
        document.getElementById('detailInfoBtn').style.display = 'none';
    }
    


});



