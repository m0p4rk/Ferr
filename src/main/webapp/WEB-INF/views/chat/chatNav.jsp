<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Navbar with Modal</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://kit.fontawesome.com/a076d05399.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="/">Ferr</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse"
            data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false"
            aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ml-auto">
                <c:if test="${sessionScope.userId != null}">
                    <!-- 닉네임이 세션에 있을 경우 환영 메시지 표시 -->
                    <li class="nav-item">
                        <span class="navbar-text">
                            환영합니다, ${sessionScope.nickname}님!
                        </span>
                    </li>
                    <!-- <li class="nav-item"><a href="/schedulelist" class="btn btn-primary">일정 관리</a></li>
                    <li class="nav-item"><a href="/my-page" class="btn btn-warning">마이페이지</a></li>
                    <li class="nav-item"><a href="/logout" class="btn btn-danger">로그아웃</a></li>
                    <li class="nav-item"><a href="/chat/rooms" class="btn btn-primary">채팅</a></li> -->
                </c:if>
                <c:if test="${sessionScope.userId == null}">
                    <li class="nav-item"><button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#loginModal">시작</button></li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>


<script>

</script>


<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
