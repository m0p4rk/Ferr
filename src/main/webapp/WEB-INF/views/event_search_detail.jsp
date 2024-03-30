<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ferr - 통합검색</title>
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet" href="/css/main.css">
<link rel="stylesheet" href="/css/common.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@600&display=swap"
	rel="stylesheet">
<style>
	/* 기본 컨테이너 및 타이틀 스타일링 */
.image-item {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 300px;
	height: 200px;
    background-color: #fff;
    margin-bottom: 30px;
    box-shadow: 0 2px 4px rgba(0,0,0,.1);
    transition: transform 0.3s ease;
    border-radius: 5px; /* 경계선 둥글게 */
}

.image-item:hover {
    transform: translateY(-5px); /* 호버 시 약간 위로 이동 */
    box-shadow: 0 5px 15px rgba(0,0,0,.2);
}

.image-item img {
    max-width: 100%; /* 이미지 최대 너비 조정 */
    height: auto; /* 이미지 높이 자동 조정 */
    border-top-left-radius: 5px; /* 이미지 상단 경계선 둥글게 */
    border-top-right-radius: 5px;
}

.image-text {
    width: 100%;
    padding: 10px;
    text-align: center;
    background-color: rgba(0, 0, 0, 0.5);
    color: white;
    font-weight: bold;
}
</style>
</head>
<body>
	<div class="title-container">
	</div>
    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="input-group mb-3">
                    <input type="text" class="form-control" placeholder="검색어를 입력하세요" id="searchQuery" name="searchQuery">
                    <div class="input-group-append">
                        <button class="btn btn-primary" type="submit" id="searchButton">검색</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" id="searchResults">
            <!-- 동적으로 생성된 검색 결과가 여기에 표시됩니다 -->
        </div>
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center" id="pagination">
                <!-- 페이지네이션 버튼이 동적으로 생성됩니다 -->
            </ul>
        </nav>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="/js/event_search_detail.js"></script> <!-- 검색 및 페이지네이션 관련 스크립트 -->
</body>
</html>
