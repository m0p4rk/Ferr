<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>추가 회원 정보 입력</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
</head>
<body>

<div class="container mt-5">
    <h2>카카오 로그인 시 - API 에서 제공해주는 정보를 제외하고 닉네임만 확인</h2>
    <form id="additionalInfoForm" action="completeRegistration" method="post">
        <div class="form-group">
            <label for="nickname">닉네임:</label>
            <input type="text" class="form-control" id="nickname" name="nickname" required>
            <div class="invalid-feedback">닉네임은 2글자 이상 입력해주세요.</div>
        </div>
        <small class="form-text text-muted">중복확인 기능 추가해줘야 함</small>
       <!-- <div class="form-group">
            <label for="realName">실명:</label>
            <input type="text" class="form-control" id="realName" name="realName">
        </div> -->
        <button type="submit" class="btn btn-primary">회원가입 완료</button>
    </form>
</div>

<script>
$(document).ready(function() {
    $('#additionalInfoForm').on('submit', function(e) {
        e.preventDefault();
        
        var isValid = true;
        
        // 닉네임 유효성 검사
        var nickname = $('#nickname').val();
        if(nickname.length < 2) {
            $('#nickname').addClass('is-invalid');
            isValid = false;
        } else {
            $('#nickname').removeClass('is-invalid');
        }
        
        // 여기에 실명 등 다른 필드에 대한 유효성 검사 추가 가능

        if(isValid) {
            // 폼 데이터가 유효하면 제출
            this.submit();
        }
    });

    // 실시간 유효성 검사 로직 추가
    $('#nickname').on('input', function() {
        if ($(this).val().length >= 2) {
            $(this).removeClass('is-invalid');
        }
    });
});
</script>

</body>
</html>
