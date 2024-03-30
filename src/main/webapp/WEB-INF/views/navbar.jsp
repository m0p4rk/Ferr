<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ferr!</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@600&display=swap"
	rel="stylesheet">
<style>
.navbar {
    height: 56px;
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1020;
    background-color: #f8f9fa; /* 옅은 회색 배경 */
}

.navbar-brand img {
    height: 40px;
    width: 40px;
    border-radius: 50%;
    margin-top: -2px;
}

.navbar-nav {
    display: flex;
    align-items: center; /* 수직 방향으로 중앙 정렬 */
    height: 100%; /* 네비게이션 바의 높이와 동일하게 설정 */
}

.nav-item {
    margin: 0 5px; /* 좌우 여백 설정 */
}

@media (max-width: 768px) {
    .navbar {
        height: auto; /* 모바일 화면에서 높이 조정 */
        padding: 10px 0; /* 상하 패딩 추가 */
    }
    .navbar-brand img {
        margin-top: 0; /* 모바일에서의 마진 조정 */
    }
    .nav-item {
        margin: 10px 5px; /* 모바일 환경에서의 네비 항목 여백 조정 */
    }
}


body {
    font-family: 'Noto Sans KR', sans-serif;
    font-weight: 600;
}

.notification-btn {
    display: inline-block;
    background-color: #f8d568; /* 노란색 배경 */
    padding: 10px;
    border-radius: 5px; /* 모서리 처리 */
    position: relative; /* 상대 위치 설정 */
}

.notification-btn img {
    width: 30px; /* 이미지 크기 조정 */
    height: auto;
}

#notification-count {
    position: absolute;
    top: -10px;
    right: -10px;
    background-color: red;
    color: white;
    border-radius: 50%; /* 원 모양 유지 */
    width: 20px; /* 고정 너비 */
    height: 20px; /* 고정 높이 */
    padding: 0; /* padding 조절 */
    font-size: 12px;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
}

@keyframes shake {
  0% { transform: rotate(-5deg); }
  25% { transform: rotate(5deg); }
  50% { transform: rotate(-5deg); }
  75% { transform: rotate(5deg); }
  100% { transform: rotate(0deg); }
}

.notification-btn img.shake-animation {
  animation: shake 0.5s infinite;
}


</style>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-custom">
		<div class="container-fluid">
			<a class="navbar-brand" href="/"> <img src="/css/img/ferr.png"
				alt="FERR" style="height: 45px; width: auto;"> <!-- 로고 이미지 크기 조절 -->
			</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav ml-auto">
					<c:if test="${sessionScope.userId != null}">
						<li class="nav-item"><a href="/my-page" class="navbar-brand">
								<c:choose>
									<c:when test="${not empty sessionScope.profileImageUrl}">
										<img src="${sessionScope.profileImageUrl}" alt="Profile Image">
										<small>${sessionScope.nickname}</small>
									</c:when>
									<c:otherwise>
										<img src="/css/img/noprofile.png" alt="no profile">
									</c:otherwise>
								</c:choose>

						</a></li>
						<li class="nav-item"><a href="/dashboard-schedule"
							class="btn btn-secondary">내 일정</a></li>
						<li class="nav-item"><a href="/reviews"
							class="btn btn-secondary">리뷰</a></li>
						<li class="nav-item"><a href="/chat/rooms"
							class="btn btn-warning">채팅</a></li>
						<li class="nav-item"><a href="/logout" class="btn btn-danger">로그아웃</a></li>
					</c:if>
					<c:if test="${sessionScope.userId == null}">
						<li class="nav-item"><button type="button"
								class="btn btn-secondary" data-toggle="modal"
								data-target="#loginModal">시작</button></li>
					</c:if>
				</ul>
			</div>
		</div>
	</nav>
	<!-- Modal -->
	<div class="modal fade" id="loginModal" tabindex="-1" role="dialog"
		aria-labelledby="loginModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="loginModalLabel">로그인</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form id="loginForm" action="/login" method="post">
						<div class="form-group">
							<label for="email">이메일:</label> <input type="email"
								class="form-control" id="email" name="email" required>
						</div>
						<div class="form-group">
							<label for="password">비밀번호:</label> <input type="password"
								class="form-control" id="password" name="password" required>
						</div>
						<button type="submit" class="btn btn-primary btn-block">로그인</button>

					</form>
					<hr>
					<button class="btn btn-warning btn-block" id="kakao-login-btn">
						<i class="fab fa-kakao"></i> 카카오 로그인
					</button>
					<div class="text-center">
						<a href="/signup" class="btn btn-link">회원가입</a>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 알림 확인 버튼 -->
	<c:if test="${not empty sessionScope.userId}">
		<div id="notification-toggle"
     style="position: fixed; bottom: 20px; right: 20px; z-index: 1050;">
    <div class="notification-btn">
        <img src="/css/img/bell.png" alt="알림"/>
        <span id="notification-count" class="badge badge-light">0</span>
    </div>
</div>
	</c:if>



	<!-- 알림 모달 -->
	<div class="modal fade" id="notificationModal" tabindex="-1"
		role="dialog" aria-labelledby="notificationModalLabel"
		aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="notificationModalLabel">알림</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<ul class="list-group" id="notificationList">
						<!-- 알림 내용이 동적으로 여기에 추가됩니다 -->
					</ul>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>



	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
	<script src="/js/alarm.js"></script>
	<script>
		document
			.getElementById('kakao-login-btn')
			.addEventListener(
					'click',
				function() {
				window.location.href = 'http://kauth.kakao.com/oauth/authorize?response_type=code&client_id=a1c0a96f3d1b22d355a2beb880950df0&redirect_uri=http://localhost:8080/login';
		});

		$(document).ready(function() {
		    var $navbarCollapse = $('.navbar-collapse');

		    function adjustMainContentPadding() {
		        var navbarHeight = $('.navbar').outerHeight();
		        $('.main-content').css('padding-top', navbarHeight + 'px');
		    }

		    $navbarCollapse.on('show.bs.collapse', adjustMainContentPadding).on('hide.bs.collapse', function() {
		        $('.main-content').css('padding-top', '0');
		    });

		    $(window).resize(function() {
		        if ($navbarCollapse.hasClass('show')) {
		            adjustMainContentPadding();
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
	</script>
</body>
</html>

