<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ferr!</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid">
        <a class="navbar-brand" href="/">
            <img src="/css/img/ferr.png" alt="FERR" style="height: 45px; width: auto;">
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ml-auto">
                <c:if test="${sessionScope.userId != null}">
                    <li class="nav-item">
                        <a href="/my-page" class="navbar-brand">
                            <c:choose>
                                <c:when test="${not empty sessionScope.profileImageUrl}">
                                    <img src="${sessionScope.profileImageUrl}" alt="Profile Image" style="height: 30px; width: 30px; border-radius: 50%;">
                                    <small>${sessionScope.nickname}</small>
                                </c:when>
                                <c:otherwise>
                                    <img src="/css/img/noprofile.png" alt="no profile" style="height: 30px; width: 30px; border-radius: 50%;">
                                </c:otherwise>
                            </c:choose>
                        </a>
                    </li>
                    <li class="nav-item"><a href="/dashboard-schedule" class="btn btn-secondary">내 일정</a></li>
                    <li class="nav-item"><a href="/reviews" class="btn btn-secondary">리뷰</a></li>
                    <li class="nav-item"><a href="/chat/rooms" class="btn btn-warning">채팅</a></li>
                    <li class="nav-item d-block d-lg-none"><a href="/logout" class="btn btn-danger">로그아웃</a></li>
                </c:if>
                <c:if test="${sessionScope.userId == null}">
                    <li class="nav-item"><button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#loginModal">시작</button></li>
                </c:if>
            </ul>
            <c:if test="${sessionScope.userId != null}">
                <div class="d-none d-lg-block mt-2 mt-lg-0">
                    <a href="/logout" class="btn btn-danger">로그아웃</a>
                </div>
            </c:if>
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
	<script src="/js/navbar.js"></script>
	<script src="/js/alarm.js" async></script>
</body>
</html>

