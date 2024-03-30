<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/navbar.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>추가한 일정 대시보드</title>
    <link rel="stylesheet" href="/css/common.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@600&display=swap" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .card-clickable:hover {
            cursor: pointer;
            opacity: 0.9;
        }
        .d-day {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: rgba(255, 0, 0, 0.7);
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
        }
        
        body {
			font-family: 'Noto Sans KR', sans-serif;
			font-weight: 600;
		}

		.image-container img {
			max-width: 100%;
			height: auto;
		}

		.table-container {
			margin-top: 20px; /* 이미지와 테이블 사이의 간격 */
		}

		table {
			table-layout: fixed; /* 테이블의 레이아웃을 고정 */
			width: 100%; /* 테이블 너비를 부모 요소에 맞춤 */
		}

		th, td {
			word-wrap: break-word; /* 내용이 셀 너비를 초과할 경우 줄바꿈 */
			overflow-wrap: break-word;
		}
    </style>
</head>
<body>
<div class="container mt-4">
    <input type="text" id="searchInput" class="form-control" placeholder="일정 검색...">
</div>
<div class="container mt-5">
    <h2 class="mb-4">내 일정</h2>
    <div class="row">
        <c:forEach var="schedule" items="${schedules}" varStatus="status">
        <div class="col-md-4 mb-4">
            <!-- Update: Add event ID or other parameters as needed -->
            <div class="card h-100 card-clickable" onclick="location.href='/schedule-detail?id=${schedule.eventId}'">
                <div class="card-body bg-light">
                    <h5 class="card-title">${schedule.eventTitle}</h5>
                    <p class="card-text">
                        <small>
                            행사 기간:
                            <fmt:formatDate value="${schedule.eventStartDate}" pattern="yyyy-MM-dd" />
                            ~
                            <fmt:formatDate value="${schedule.eventEndDate}" pattern="yyyy-MM-dd" />
                        </small>
                    </p>
                    <p class="card-text"><small>약속 날짜: <span class="promise-date" data-date="${schedule.promiseDate}"></span></small></p>
                    <div class="d-day"></div>
                </div>
            </div>
        </div>
        </c:forEach>
    </div>
</div>
<div class="container mt-6">
    <h2 class="mb-4">지난 일정</h2>
    <div class="row" id="pastSchedulesContainer">
        <!-- JavaScript를 통해 여기에 지난 일정이 동적으로 추가됩니다. -->
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.10/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const cards = document.querySelectorAll('.col-md-4.mb-4');
    const futureContainer = document.querySelector('.container.mt-5 .row');
    const pastContainer = document.querySelector('#pastSchedulesContainer');

    // 카드의 D-Day를 계산하고 업데이트하는 함수
    function updateCardDday(card, targetDate) {
        const promiseDateElem = card.querySelector('.promise-date');
        const promiseDateStr = promiseDateElem.getAttribute('data-date');
        const promiseDate = new Date(promiseDateStr);
        promiseDate.setHours(0, 0, 0, 0);

        const diffTime = promiseDate - targetDate;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        promiseDateElem.textContent = promiseDateStr + ' (' + (diffDays >= 0 ? 'D-' + diffDays : 'D+' + Math.abs(diffDays)) + ')';
        card.querySelector('.d-day').textContent = diffDays >= 0 ? 'D-' + diffDays : 'D+' + Math.abs(diffDays);
    }

    // 카드를 남은 일수(diffDays)에 따라 정렬하기 위한 함수
    function sortCards(cardsArray, today) {
        return cardsArray.sort((a, b) => {
            const dateA = new Date(a.querySelector('.promise-date').getAttribute('data-date'));
            dateA.setHours(0, 0, 0, 0);
            const timeDiffA = dateA - today;

            const dateB = new Date(b.querySelector('.promise-date').getAttribute('data-date'));
            dateB.setHours(0, 0, 0, 0);
            const timeDiffB = dateB - today;

            return timeDiffA - timeDiffB;
        });
    }

    function clearAndAppendSortedCards(cards, today) {
        futureContainer.innerHTML = '';
        pastContainer.innerHTML = '';

        const sortedCards = sortCards(Array.from(cards), today);

        sortedCards.forEach(card => {
            const clonedCard = card.cloneNode(true);
            updateCardDday(clonedCard, today);

            const promiseDate = new Date(clonedCard.querySelector('.promise-date').getAttribute('data-date'));
            promiseDate.setHours(0, 0, 0, 0);

            if (promiseDate >= today) {
                futureContainer.appendChild(clonedCard);
            } else {
                pastContainer.appendChild(clonedCard);
            }
        });

        if (futureContainer.children.length === 0) {
            futureContainer.innerHTML = '<div class="col-12"><p>일정이 없습니다.</p></div>';
        }
        if (pastContainer.children.length === 0) {
            pastContainer.innerHTML = '<div class="col-12"><p>일정이 없습니다.</p></div>';
        }
    }

    clearAndAppendSortedCards(cards, today);

    document.getElementById('searchInput').addEventListener('input', function() {
        const searchText = this.value.toLowerCase();

        const filteredCards = Array.from(cards).filter(card => {
            const eventTitle = card.querySelector('.card-title').textContent.toLowerCase();
            return eventTitle.includes(searchText);
        });

        clearAndAppendSortedCards(filteredCards, today);
    });
});

</script>
</body>
</html>
