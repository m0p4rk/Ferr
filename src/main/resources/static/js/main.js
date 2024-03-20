function fetchTouristInfo() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(position => {
            const latitude = position.coords.latitude;
            const longitude = position.coords.longitude;
            fetchEventData(latitude, longitude);
        }, error => {
            console.error('Error getting location:', error);
        });
    } else {
        console.error('Geolocation is not supported by this browser.');
    }
}

let currentPageNo = 1; // 현재 페이지 번호

function fetchEventData(latitude, longitude, append = false) {
    const serviceKey = 'UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/locationBasedList1?ServiceKey=${serviceKey}&contentTypeId=15&mapX=${longitude}&mapY=${latitude}&radius=10000&listYN=Y&MobileOS=ETC&MobileApp=AppTest&arrange=A&numOfRows=12&pageNo=${currentPageNo}`;

    fetch(url)
    .then(response => response.text())
    .then(str => (new window.DOMParser()).parseFromString(str, "text/xml"))
    .then(data => {
        const items = data.getElementsByTagName("item");
        const container = document.getElementById('mylocationcontainer');
        if (!append) { // append가 false일 때만 초기화
            container.innerHTML = '';
        }

        for (let i = 0; i < items.length; i++) {
            const item = items[i];
            const title = item.getElementsByTagName("title")[0].textContent;
            const firstImageURL = item.getElementsByTagName("firstimage")[0] ? item.getElementsByTagName("firstimage")[0].textContent : '기본 이미지 URL';
            const imageItem = document.createElement("div");
            imageItem.className = "image-item";
            imageItem.style.backgroundImage = `url('${firstImageURL}')`;
            const imageText = document.createElement("div");
            imageText.className = "image-text";
            imageText.textContent = title;
            imageItem.appendChild(imageText);
            container.appendChild(imageItem);
            
            imageItem.addEventListener('click', function() {
    const contentId = item.getElementsByTagName("contentid")[0] ? item.getElementsByTagName("contentid")[0].textContent : '';
    window.location.href = `/event-detail?contentId=${contentId}`; // contentId를 URL 쿼리 스트링으로 전달
});
        }
    })
    .catch(error => console.error('Error:', error));
}

document.addEventListener("DOMContentLoaded", fetchTouristInfo);

function redirectToEventDetail(eventId) {
    window.location.href = `/event-detail?eventId=${eventId}`;
}   

function scrollContainer(containerId, direction) {
    const container = document.getElementById(containerId);
    const scrollAmount = 600;
    let newScrollPosition;
    if (direction === 'left') {
        newScrollPosition = container.scrollLeft - scrollAmount;
    } else if (direction === 'right') {
        newScrollPosition = container.scrollLeft + scrollAmount;
    }
    container.scrollTo({
        top: 0,
        left: newScrollPosition,
        behavior: 'smooth'
    });
}

function loadMoreDataIfRequired() {
    const container = document.getElementById('mylocationcontainer');
    // 슬라이더의 너비와 스크롤 위치를 기준으로 더 불러올지 결정
    if (container.offsetWidth + container.scrollLeft >= container.scrollWidth - 100) {
        currentPageNo++; // 페이지 번호 증가
        navigator.geolocation.getCurrentPosition(position => {
            const latitude = position.coords.latitude;
            const longitude = position.coords.longitude;
            fetchEventData(latitude, longitude, true); // 추가 데이터 불러오기
        });
    }
}

document.addEventListener("DOMContentLoaded", function() {
    const sliders = document.querySelectorAll('.box-container');

    sliders.forEach(slider => {
        let isDown = false;
        let startX;
        let scrollLeft;

        slider.addEventListener('mousedown', e => {
            isDown = true;
            slider.classList.add('active');
            startX = e.pageX - slider.offsetLeft;
            scrollLeft = slider.scrollLeft;
        });

        slider.addEventListener('mouseleave', () => {
            isDown = false;
            slider.classList.remove('active');
        });

        slider.addEventListener('mouseup', () => {
            isDown = false;
            slider.classList.remove('active');
        });

        slider.addEventListener('mousemove', e => {
            if (!isDown) return;
            e.preventDefault();
            const x = e.pageX - slider.offsetLeft;
            const walk = (x - startX) * 3; // 스크롤 속도 조정
            slider.scrollLeft = scrollLeft - walk;
        });

        slider.addEventListener('scroll', loadMoreDataIfRequired);
    });
});
