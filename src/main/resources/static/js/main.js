document.addEventListener("DOMContentLoaded", function() {
    fetchTouristInfo();
    fetchRecommendedEvents();
    setupSliders();
    setupSearchButton();
    fetchKeywordOnlyData('축제');
});

let currentPageNo = 1; // 현재 페이지 번호

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

function fetchRecommendedEvents() {
    // 서버로부터 regionPreference 세션 값을 가져옵니다.
    fetch('/api/region-preference')
        .then(response => response.text()) // 서버 응답을 텍스트로 변환
        .then(regionPreference => {
            // 성공적으로 regionPreference 값을 가져온 경우
            if(regionPreference) {
                fetchRecommendData(regionPreference);
            } else {
                console.error('Region preference not found in session.');
            }
        })
        .catch(error => console.error('Error fetching region preference:', error));
}

function fetchEventData(latitude, longitude, append = false) {
    const serviceKey = 'UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/locationBasedList1?ServiceKey=${serviceKey}&contentTypeId=15&mapX=${longitude}&mapY=${latitude}&radius=10000&listYN=Y&MobileOS=ETC&MobileApp=AppTest&arrange=A&numOfRows=12&pageNo=${currentPageNo}`;
    commonFetchEvent(url, 'mylocationcontainer', append);
}

function fetchKeywordOnlyData(keyword, append = false) {
    const serviceKey = 'UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/searchKeyword1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey=${serviceKey}&listYN=Y&arrange=A&areaCode=&sigunguCode=&cat1=&cat2=&cat3=&keyword=${keyword}`;
    commonFetchEvent(url, 'rankcontainer', append);
}

function fetchRecommendData(regionPreference, append = false) {
    const serviceKey = 'UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/searchFestival1?eventStartDate=20240322&eventEndDate=20240422&areaCode=${regionPreference}&sigunguCode=&ServiceKey=${serviceKey}&listYN=Y&MobileOS=ETC&MobileApp=AppTest&arrange=A&numOfRows=12&pageNo=${currentPageNo}`;
    commonFetchEvent(url, 'recommendcontainer', append);
}

function fetchSubData(append = false) {
    const serviceKey = 'UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/searchFestival1?eventStartDate=20240322&eventEndDate=20240422&areaCode=31&sigunguCode=&ServiceKey=${serviceKey}&listYN=Y&MobileOS=ETC&MobileApp=AppTest&arrange=A&numOfRows=12&pageNo=${currentPageNo}`;
    commonFetchEvent(url, 'searchcontainer', append);
}

function fetchSearchData(region, startDate, endDate, pageNo) {
    const url = `/api/searchFestival1?region=${region}&startDate=${startDate}&endDate=${endDate}&pageNo=${pageNo}`;
    fetch(url)
        .then(response => response.json())
        .then(data => {
            if(data && data.response && data.response.body && data.response.body.items && data.response.body.items.item) {
                displaySearchResults(data, 'searchcontainer', pageNo !== 1);
            } else {
                throw new Error("No data found");
            }
        })
        .catch(error => {
            console.error('Error fetching search results, fetching substitute data:', error);
            // 에러 발생 시 대체 데이터 로드 함수 호출
            fetchSubData();
        });
}



function commonFetchEvent(url, containerParam, append = false) {
    fetch(url)
        .then(response => response.text())
        .then(str => (new window.DOMParser()).parseFromString(str, "text/xml"))
        .then(data => {
            const items = data.getElementsByTagName("item");
            const container = document.getElementById(containerParam);

            if (!append) {
                container.innerHTML = ''; // 추가 로드가 아닐 경우 기존 내용을 지웁니다.
            }

            for (let i = 0; i < items.length; i++) {
                const item = items[i];
                const title = item.getElementsByTagName("title")[0].textContent;
                const firstImageURL = item.getElementsByTagName("firstimage")[0] ? item.getElementsByTagName("firstimage")[0].textContent : '/css/img/loading_ferr.png';
                const contentId = item.getElementsByTagName("contentid")[0].textContent;

                const imageItem = document.createElement("div");
                imageItem.className = "image-item";
                imageItem.setAttribute('data-event-id', contentId); // 이벤트 ID 설정
                imageItem.style.backgroundImage = `url('${firstImageURL}')`; // 초기 배경 이미지 설정

                // 이미지 엘리먼트 생성
                const imageElement = document.createElement("img");
                imageElement.src = firstImageURL;
                imageElement.onload = function() {
                    imageItem.style.backgroundImage = 'none';
                };
                imageElement.onerror = function() {
                    this.onerror = null;
                    this.src = '/css/img/noimage_ferr.png';
                    imageItem.style.backgroundImage = 'none';
                };
                imageItem.appendChild(imageElement);

                // 랭크 숫자 표시
                if (containerParam === 'rankcontainer') {
                    const rankNumber = document.createElement("div");
                    rankNumber.className = "rank-number";
                    rankNumber.textContent = i + 1; // 순서대로 번호 부여
                    imageItem.appendChild(rankNumber);
                }

                const imageText = document.createElement("div");
                imageText.className = "image-text";
                imageText.textContent = title;
                imageItem.appendChild(imageText);

                container.appendChild(imageItem);

                // 클릭 이벤트 핸들러 추가
                imageItem.addEventListener('click', function() {
                    redirectToEventDetail(this.getAttribute('data-event-id'));
                });
            }
        })
        .catch(error => console.error('Error:', error));
}

function redirectToEventDetail(contentId) {
    window.location.href = `/event-detail?contentId=${contentId}`;
}


function loadMoreDataIfRequired() {
    const container = this;
    if (container.offsetWidth + container.scrollLeft >= container.scrollWidth - 100) {
        currentPageNo++;
        if (container.id === 'mylocationcontainer') {
            navigator.geolocation.getCurrentPosition(position => {
                const latitude = position.coords.latitude;
                const longitude = position.coords.longitude;
                fetchEventData(latitude, longitude, true);
            }, error => {
                console.error('Error getting location for more data:', error);
            });
        } else if (container.id === 'recommendcontainer') {
            fetch('/api/region-preference')
                .then(response => response.text())
                .then(regionPreference => {
                    if(regionPreference) {
                        fetchRecommendData(regionPreference, true);
                    } else {
                        console.error('Region preference not found in session.');
                    }
                })
                .catch(error => console.error('Error fetching region preference:', error));
        } else if (container.id === 'searchcontainer') {
            const { region, startDate, endDate } = searchQuery;
            fetchSearchData(region, startDate, endDate, currentPageNo);
        }
    }
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
            const walk = (x - startX) * 3;
            slider.scrollLeft = scrollLeft - walk;
        });

        slider.addEventListener('scroll', loadMoreDataIfRequired);
    });
});

function setupSliders() {
    document.querySelectorAll('.box-container').forEach(container => {
        container.addEventListener('scroll', function() {
            loadMoreDataIfRequired.call(this);
        });
    });
}

function setupSearchButton() {
    const searchButton = document.getElementById('searchButton');
    searchButton.addEventListener('click', function(event) {
        event.preventDefault();
        currentPageNo = 1; // 검색 시작 시 페이지 번호 초기화
        const region = document.getElementById('regionFilter').value;
        const startDate = document.getElementById('startDateFilter').value.replaceAll('-', '');
        const endDate = document.getElementById('endDateFilter').value.replaceAll('-', '');
        searchQuery = { region, startDate, endDate }; // 검색 쿼리 업데이트
        fetchSearchData(region, startDate, endDate, currentPageNo);
    });
}

function displaySearchResults(data, containerId, append) {
    const container = document.getElementById(containerId);
    if (!append) {
        container.innerHTML = ''; // 기존 내용을 지우고 새로운 검색 결과를 표시합니다.
    }
    data.response.body.items.item.forEach(item => {
        const imageItem = document.createElement('div');
        imageItem.className = 'image-item';
        imageItem.setAttribute('data-event-id', item.contentid); // 예시로 contentid를 사용

        // 검색 결과에 따라 배경 이미지 설정
        const imageUrl = item.firstimage || '/css/img/noimage_ferr.png'; // 검색 결과에 이미지가 없으면 기본 이미지 사용
        imageItem.style.backgroundImage = `url(${imageUrl})`;

        const imageText = document.createElement('div');
        imageText.className = 'image-text';
        imageText.textContent = item.title; // 검색 결과의 타이틀 사용
        imageText.style.visibility = 'visible'; // 검색 결과 로딩 후 텍스트 보이게 설정

        imageItem.appendChild(imageText);
        container.appendChild(imageItem);

        // 클릭 이벤트 리스너 추가
        imageItem.addEventListener('click', function() {
            // 클릭 시 이벤트 상세 페이지로 넘어가기
            window.location.href = `/event-detail?contentId=${item.contentid}`; // item에서 contentid 직접 참조
        });
    });
}


function updateScrollIndicator(containerId, indicatorId) {
    const container = document.getElementById(containerId);
    const indicator = document.getElementById(indicatorId);
    container.addEventListener('scroll', function() {
        const maxScroll = container.scrollHeight - container.clientHeight;
        const currentScroll = container.scrollTop;
        const scrollPercentage = (currentScroll / maxScroll) * 100;
        indicator.style.width = scrollPercentage + '%';
    });
}

document.addEventListener("DOMContentLoaded", function() {
    const sliders = document.querySelectorAll('.box-container');

    sliders.forEach(slider => {
        let isDown = false;
        let startX;
        let scrollLeft;

        // 마우스 이벤트 핸들러
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
            const walk = (x - startX) * 3; // 스크롤 양 조정
            slider.scrollLeft = scrollLeft - walk;
        });

        // 터치 이벤트 핸들러
        slider.addEventListener('touchstart', e => {
            isDown = true;
            slider.classList.add('active');
            startX = e.touches[0].pageX - slider.offsetLeft;
            scrollLeft = slider.scrollLeft;
        });
        slider.addEventListener('touchend', () => {
            isDown = false;
            slider.classList.remove('active');
        });
        slider.addEventListener('touchmove', e => {
            if (!isDown) return;
            e.preventDefault();
            const x = e.touches[0].pageX - slider.offsetLeft;
            const walk = (x - startX) * 3; // 스크롤 양 조정
            slider.scrollLeft = scrollLeft - walk;
        });
    });
});


// 각 컨테이너에 대해 이 함수를 호출합니다.
function setupScrollIndicator() {
    updateScrollIndicator('rankcontainer', 'rankScrollIndicator');
    updateScrollIndicator('searchcontainer', 'searchScrollIndicator');
    updateScrollIndicator('recommendcontainer', 'recommendScrollIndicator');
    updateScrollIndicator('mylocationcontainer', 'locationScrollIndicator');
}


