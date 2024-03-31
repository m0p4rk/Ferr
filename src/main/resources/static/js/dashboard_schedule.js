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