$(document).ready(function() {
	var queryParams = new URLSearchParams(window.location.search);
    var eventId = queryParams.get('eventId');
	
    // 별점 위에 마우스를 올렸을 때
    $('.rating span').on('mouseenter', function() {
        $('.rating span').removeClass('active'); // 우선 모든 별의 active 클래스 제거
        $(this).addClass('active'); // 현재 호버된 별에 active 클래스 추가
        $(this).prevAll('span').addClass('active'); // 호버된 별의 왼쪽에 있는 모든 별에도 active 클래스 추가
    }).on('mouseleave', function() {
        if (!$('.rating').hasClass('selected')) {
            $('.rating span').removeClass('active');
        }
    });

    // 별 클릭 이벤트
    $('.rating span').on('click', function() {
        $('.rating').addClass('selected'); // 별점이 선택되었다는 표시를 위한 클래스 추가
        var ratingValue = $(this).data('value');
        $('#rating').val(ratingValue); // 선택된 평점 값 설정

        $('.rating span').removeClass('active'); // 모든 별의 active 클래스 초기화
        $(this).addClass('active'); // 클릭된 별에 active 클래스 추가
        $(this).prevAll('span').addClass('active'); // 클릭된 별의 왼쪽에 있는 별들에 active 클래스 추가
    });
    
    var queryParams = new URLSearchParams(window.location.search);
    var eventId = queryParams.get('eventId');

    // eventId가 있을 경우에만 AJAX 요청을 수행
    if (eventId) {
        $.ajax({
            url: '/schedule/' + eventId, // 이벤트 정보를 가져오는 서버 엔드포인트
            type: 'GET',
            success: function(response) {
                // 서버로부터 받은 이벤트 정보를 사용
                // 예: response에 event_title이 포함되어 있다고 가정
                var eventTitle = response.eventTitle; // 실제 응답 구조에 맞게 변경해야 함
                $('#eventTitle').text(eventTitle); // 제목 입력 필드에 이벤트 제목 채우기
            },
            error: function(xhr, status, error) {
                console.error("이벤트 정보를 불러오는 데 실패했습니다:", error);
            }
        });
    }
});