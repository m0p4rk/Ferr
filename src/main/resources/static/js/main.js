document.addEventListener("DOMContentLoaded", function() {
    fetchTouristInfo();
    fetchRecommendedEvents();
    setupSliders();
    setupSearchButton();
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
    const serviceKey = 'RfKadspJxs7UlgWwFxrI3lk0a6EHQS%2FAbQl5soEhqGRVItvRMVFlDBZLJHF7FEMpTq0yLcT2E9%2BFntTR%2FM8PBg%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/locationBasedList1?ServiceKey=${serviceKey}&contentTypeId=15&mapX=${longitude}&mapY=${latitude}&radius=10000&listYN=Y&MobileOS=ETC&MobileApp=AppTest&arrange=A&numOfRows=12&pageNo=${currentPageNo}`;
    commonFetchEvent(url, 'mylocationcontainer', append);
}

function fetchRecommendData(regionPreference, append = false) {
    const serviceKey = 'RfKadspJxs7UlgWwFxrI3lk0a6EHQS%2FAbQl5soEhqGRVItvRMVFlDBZLJHF7FEMpTq0yLcT2E9%2BFntTR%2FM8PBg%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/searchFestival1?eventStartDate=20240322&eventEndDate=20240422&areaCode=${regionPreference}&sigunguCode=&ServiceKey=${serviceKey}&listYN=Y&MobileOS=ETC&MobileApp=AppTest&arrange=A&numOfRows=12&pageNo=${currentPageNo}`;
    commonFetchEvent(url, 'recommendcontainer', append);
}

function fetchSearchData(region, startDate, endDate, pageNo) {
    const url = `/api/searchFestival1?region=${region}&startDate=${startDate}&endDate=${endDate}&pageNo=${pageNo}`;
    fetch(url)
        .then(response => response.json())
        .then(data => displaySearchResults(data, 'searchcontainer', pageNo !== 1))
        .catch(error => console.error('Error fetching search results:', error));
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
                imageItem.style.backgroundImage = `url('${firstImageURL}')`; // 초기 배경 이미지 설정

                // 이미지 엘리먼트 생성
                const imageElement = document.createElement("img");
                imageElement.src = firstImageURL;
                // 이미지 로드 성공 시 배경 이미지 비활성화
                imageElement.onload = function() {
                    imageItem.style.backgroundImage = 'none';
                };
                // 로딩 실패 시 대체 이미지 사용
                imageElement.onerror = function() {
                    this.onerror = null; // 무한 루프 방지
                    this.src = '/css/img/noimage_ferr.png'; // 대체 이미지 경로로 변경
                    imageItem.style.backgroundImage = 'none'; // 배경 이미지 비활성화
                };

                imageItem.appendChild(imageElement);

                const imageText = document.createElement("div");
                imageText.className = "image-text";
                imageText.textContent = title;
                imageItem.appendChild(imageText);

                container.appendChild(imageItem);

                // 클릭 이벤트 핸들러 추가
                imageItem.addEventListener('click', function() {
                    window.location.href = `/event-detail?contentId=${contentId}`;
                });
            }
        })
        .catch(error => console.error('Error:', error));
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
            redirectToEventDetail(this.getAttribute('data-event-id'));
        });
    });
}
