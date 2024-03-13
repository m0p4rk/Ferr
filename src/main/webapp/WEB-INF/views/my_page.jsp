<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Preferences</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>

<div class="container mt-5">
    <h2>마이 페이지</h2>
    <form action="savePreferences" method="POST"> <!-- action 수정 필요 -->
        <div class="form-group">
            <label for="preferredLocation">선호 지역</label>
            <input type="text" class="form-control" id="preferredLocation" name="preferredLocation" placeholder="Enter preferred location">
        </div>
        <div class="form-group">
            <label for="admissionFeePreference">과금 여부</label>
            <select class="form-control" id="admissionFeePreference" name="admissionFeePreference">
                <option value="ALL">모두</option>
                <option value="FREE">무료</option>
                <option value="PAID">유료</option>
            </select>
        </div>
        <div class="form-group">
            <label for="categoryCode">카테고리 분류</label>
            <input type="text" class="form-control" id="categoryCode" name="categoryCode" placeholder="통합 검색 카테고리 분류 코드 취득 후 세분화">
        </div>
        <div class="form-group">
            <label for="latitude">Latitude</label>
            <input type="text" class="form-control" id="latitude" name="latitude" placeholder="예시 - 삭제 예정">
        </div>
        <div class="form-group">
            <label for="longitude">Longitude</label>
            <input type="text" class="form-control" id="longitude" name="longitude" placeholder="예시 - 삭제 예정">
        </div>
        <button type="submit" class="btn btn-primary">저장</button>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>