		document
			.getElementById('kakao-login-btn')
			.addEventListener('click', function() {
			window.location.href = 'http://kauth.kakao.com/oauth/authorize?response_type=code&client_id=a1c0a96f3d1b22d355a2beb880950df0&redirect_uri=http://localhost:8080/login';
		});

		$(document).ready(function() {
    var $navbarCollapse = $('.navbar-collapse');

    function adjustMainContentPadding() {
        var navbarHeight = $('.navbar').outerHeight();
        $('.main-content').css('padding-top', navbarHeight + 'px');
    }

    // 네비게이션 바의 토글 상태에 따라 메인 콘텐츠의 패딩 조정
    $navbarCollapse.on('show.bs.collapse', adjustMainContentPadding).on('hide.bs.collapse', function() {
        $('.main-content').css('padding-top', '');
    });

    $(window).resize(function() {
        if (!$navbarCollapse.hasClass('show')) {
            adjustMainContentPadding();
        } else {
            $('.main-content').css('padding-top', '');
        }
    });
});
		
		// 주석해제하면 안읽은메시지 몇개인지 갯수받아옴
        /* function sendAlarmRequest() {
        	setInterval(function() {
            // AJAX 요청 보내기
	            $.ajax({
	                type: "GET",
	                url: "/chat/alarm",
	                success: function(response) {
	                    // 요청이 성공한 경우 처리
	                    console.log("안 읽은 메시지 : " + response);
	                    // 받은 응답 처리
	                    // 예: 받은 데이터를 이용하여 특정 동작 수행
	                },
	                error: function(xhr, status, error) {
	                    // 요청이 실패한 경우 처리
	                    console.error("알람 요청이 실패했습니다:", error);
	                }
	            });
	        }, 2000); // 2초마다 요청 보내도록 설정
    	}
		var sessionId = "${sessionScope.userId}";
		$(document).ready(function() {
		// 세션 ID가 있는지 확인
		if (sessionId != null && sessionId != '') {
		    sendAlarmRequest();
		}else {
			console.log(sessionId);
		}
		}); */