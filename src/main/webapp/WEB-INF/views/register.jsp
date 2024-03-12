<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>회원가입</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
</head>
<body>

	<div class="container mt-5">
		<h2>회원가입</h2>
		<form id="registrationForm">
			<div class="form-group">
				<label for="nickname">닉네임:</label> <input type="text"
					class="form-control" id="nickname" name="nickname"
					placeholder="닉네임" required>
					<small
					class="form-text text-muted">중복확인 기능 추가해줘야 함</small>
			</div>
			<div class="form-group">
				<label for="email">이메일:</label> <input type="email"
					class="form-control" id="email" name="email" placeholder="이메일 주소"
					required>
					<small
					class="form-text text-muted">중복확인 기능 추가해줘야 함</small>
			</div>
			<div class="form-group">
				<label for="password">비밀번호:</label> <input type="password"
					class="form-control" id="password" name="password"
					placeholder="비밀번호" required> <small
					class="form-text text-muted">비밀번호는 8~20자 사이이며, 숫자와 특수문자를
					포함해야 합니다.</small>
			</div>
			<div class="form-group">
				<label for="confirmPassword">비밀번호 재확인:</label> <input
					type="password" class="form-control" id="confirmPassword"
					placeholder="비밀번호 재확인" required>
				<div id="passwordConfirmFeedback" class="invalid-feedback">비밀번호가
					일치하지 않습니다.</div>
			</div>

			<button type="submit" class="btn btn-primary">가입하기</button>
			<button type="submit" class="btn btn-primary">카카오로 가입하기</button>
		</form>
	</div>

	<script>
$(document).ready(function() {
    $('#registrationForm').on('submit', function(e) {
        e.preventDefault();

        var password = $('#password').val();
        var confirmPassword = $('#confirmPassword').val();
        if(password !== confirmPassword) {
            $('#confirmPassword').addClass('is-invalid');
            return false;
        } else {
            $('#confirmPassword').removeClass('is-invalid');
        }

        // 비밀번호 패턴 검증
        var passwordPattern = /^(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z]).{8,20}$/;
        if(!passwordPattern.test(password)) {
            alert('비밀번호는 8~20자 사이이며, 최소 하나의 숫자와 특수문자를 포함해야 합니다.');
            return false;
        }

        // 추가적인 폼 검증 로직 후 제출 처리
        this.submit();
    });

    // 실시간 비밀번호 일치 검사
    $('#password, #confirmPassword').on('keyup', function () {
        if ($('#password').val() == $('#confirmPassword').val()) {
            $('#confirmPassword').removeClass('is-invalid').addClass('is-valid');
        } else {
            $('#confirmPassword').removeClass('is-valid').addClass('is-invalid');
        }
    });
});
</script>

</body>
</html>
