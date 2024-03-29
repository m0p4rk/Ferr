$(document).ready(function() {
    // 첫 페이지 로딩 시 알림 개수 로드
    loadNotificationCount();

    // 알림 버튼 클릭 이벤트 핸들러
    $("#notification-toggle").click(function() {
        loadNotifications();
        $("#notificationModal").modal('show'); // 알림 모달 표시
    });

    // 알림 개수만 로드하는 함수
    function loadNotificationCount() {
        $.ajax({
            url: "/api/notifications/visible",
            type: "GET",
            success: function(data) {
                const validNotifications = data.filter(notification => notification.notificationId !== null);
                const notificationCount = validNotifications.length;

                $("#notification-count").text(notificationCount); // 알림 개수 업데이트

                if (notificationCount > 0) {
                    $("#notification-toggle").show().addClass("pulse"); // 알림 있으면 버튼 표시 및 애니메이션 추가
                } else {
                    $("#notification-toggle").hide().removeClass("pulse"); // 알림 없으면 버튼 숨김 및 애니메이션 제거
                }
            },
            error: function(xhr, status, error) {
                console.log("알림 개수 로드 실패", error);
            }
        });
    }

    // 알림 목록 로드 함수
    function loadNotifications() {
        $.ajax({
            url: "/api/notifications/visible",
            type: "GET",
            success: function(data) {
                const filteredData = data.filter(notification => notification.notificationId !== null);
                filteredData.sort((a, b) => new Date(b.notificationTime) - new Date(a.notificationTime));

                var contentHtml = "";
                filteredData.forEach(notification => {
                    const dDay = calculateDDay(notification.promiseDate);
                    const formattedDateTime = formatDateTime(notification.notificationTime);

                    contentHtml += `<li class="list-group-item notification-item" data-event-id="${notification.eventId}" style="position: relative;">
                        <div style="position: absolute; top: 5px; right: 10px; color: red; font-weight: bold;">D-${dDay}</div>
                        <div style="position: absolute; bottom: 5px; right: 10px;">${formattedDateTime}</div>
                        <strong>${notification.eventTitle}</strong>
                        <p>${notification.content}</p>
                        <button class="delete-notification btn btn-danger btn-sm" data-notification-id="${notification.notificationId}">확인!</button>
                    </li>`;
                });

                $("#notificationList").html(contentHtml);

                // '삭제' 버튼 이벤트 핸들러
                $(".delete-notification").click(function(e) {
                    e.stopPropagation(); // 이벤트 전파 중지
                    const notificationId = $(this).data("notification-id");
                    hideNotification(notificationId);
                });

                // 알림 항목 클릭 이벤트 핸들러
                $(".notification-item").not('.delete-notification').click(function() {
                    const eventId = $(this).data("event-id");
                    window.location.href = `/schedule-detail?id=${eventId}`; // 이벤트 상세 페이지로 이동
                });
            },
            error: function(xhr, status, error) {
                console.error("알림 로드 실패", error);
            }
        });
    }

    // 날짜 및 시간 포맷 함수
    function formatDateTime(dateTime) {
        const date = new Date(dateTime);
        return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
    }

    // D-Day 계산 함수
    function calculateDDay(promiseDate) {
        const today = new Date();
        const pDate = new Date(promiseDate);
        const diffTime = pDate - today;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays >= 0 ? diffDays : '지남';
    }

    // 알림 숨기기 함수
    function hideNotification(notificationId) {
        $.ajax({
            url: `/api/notifications/hide/${notificationId}`,
            type: "POST",
            success: function() {
                loadNotifications(); // 알림 숨기기 성공 후 목록 다시 로딩
                loadNotificationCount(); // 알림 개수 업데이트
            },
            error: function(xhr, status, error) {
                console.error("알림 숨기기 실패", error);
            }
        });
    }
});
