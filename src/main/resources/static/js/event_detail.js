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



