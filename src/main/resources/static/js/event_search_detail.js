document.addEventListener("DOMContentLoaded", function() {
    setupKeywordSearchButton();
    setupPagination(5);
});

function setupPagination(totalPages) {
    const paginationContainer = document.getElementById('pagination');
    paginationContainer.innerHTML = ''; // 기존의 페이지네이션 버튼을 초기화

    for (let i = 1; i <= totalPages; i++) {
        const pageItem = document.createElement('li');
        pageItem.className = 'page-item';
        const pageLink = document.createElement('a');
        pageLink.className = 'page-link';
        pageLink.href = '#';
        pageLink.textContent = i;
        pageLink.addEventListener('click', function(event) {
            event.preventDefault();
            const currentPageNo = i;
            const keyword = document.getElementById('searchQuery').value;
            fetchKeywordData(currentPageNo, keyword);
        });

        pageItem.appendChild(pageLink);
        paginationContainer.appendChild(pageItem);
    }

    // 마지막 페이지에 도달했을 때 다음 페이지 버튼 추가
    if (totalPages >= 5) {
        const nextPageItem = document.createElement('li');
        nextPageItem.className = 'page-item';
        const nextPageLink = document.createElement('a');
        nextPageLink.className = 'page-link';
        nextPageLink.href = '#';
        nextPageLink.textContent = '다음';
        nextPageLink.addEventListener('click', function(event) {
            event.preventDefault();
            setupPagination(totalPages + 1); // 현재 페이지보다 하나 더 많은 페이지 버튼을 생성
        });

        nextPageItem.appendChild(nextPageLink);
        paginationContainer.appendChild(nextPageItem);
    }
}

function fetchKeywordData(pageno, keyword, append = false) {
    const serviceKey = 'UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D';
    const url = `http://apis.data.go.kr/B551011/KorService1/searchKeyword1?numOfRows=15&pageNo=${pageno}&MobileOS=ETC&MobileApp=AppTest&ServiceKey=${serviceKey}&listYN=Y&arrange=A&areaCode=&sigunguCode=&cat1=&cat2=&cat3=&keyword=${keyword}`;
    commonFetchEvent(url, 'searchResults', append);
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
                const colDiv = document.createElement('div');
                colDiv.className = 'col-lg-4 col-md-6 col-sm-12 mb-4'; // 대, 중, 소 화면에서의 반응형 그리드 설정

                const imageItem = document.createElement("div");
                imageItem.className = "image-item";
                imageItem.style.backgroundImage = `url('${item.getElementsByTagName("firstimage")[0] ? item.getElementsByTagName("firstimage")[0].textContent : '/css/img/noimage_ferr.png'}')`;

                const imageElement = document.createElement("img");
                imageElement.src = item.getElementsByTagName("firstimage")[0] ? item.getElementsByTagName("firstimage")[0].textContent : '/css/img/noimage_ferr.png';
                imageElement.onload = function() {
                    imageItem.style.backgroundImage = 'none';
                };
                imageElement.onerror = function() {
                    this.onerror = null; // 오류 발생 시 대체 이미지로 변경
                    this.src = '/css/img/noimage_ferr.png';
                };
                imageItem.appendChild(imageElement);

                const imageText = document.createElement("div");
                imageText.className = "image-text";
                imageText.textContent = item.getElementsByTagName("title")[0].textContent;
                imageItem.appendChild(imageText);

                colDiv.appendChild(imageItem);
                container.appendChild(colDiv);
            }
        })
        .catch(error => console.error('Error:', error));
}


function setupKeywordSearchButton() {
    const searchButton = document.getElementById('searchButton');
    searchButton.addEventListener('click', function(event) {
        event.preventDefault();
        const currentPageNo = 1; // 검색 시작 시 페이지 번호 초기화
        const keyword = document.getElementById('searchQuery').value; // 검색어 입력 필드의 값을 가져옵니다.
        fetchKeywordData(currentPageNo, keyword); // 검색어와 함께 데이터를 불러옵니다.
    });
}

function redirectToEventDetail(contentId) {
    window.location.href = `/event-detail?contentId=${contentId}`;
}