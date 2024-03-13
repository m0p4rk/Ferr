<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ferr</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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
					<li class="nav-item"><a href="/my-page"
						class="btn btn-warning">마이 페이지</a></li>
					<li class="nav-item"><a href="/schedulelist"
						class="btn btn-primary">일정 관리</a></li>
					<li class="nav-item">
						<button type="button" class="btn btn-secondary"
							data-toggle="modal" data-target="#loginModal">시작</button>
					</li>
				</ul>
			</div>
		</div>
	</nav>

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
					<form id="loginForm">
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
					<div class="row">
						<div class="col-md-6">
							<a href="/signup" class="btn btn-link">회원가입</a>
						</div>
						<div class="col-md-6">
							<button class="btn btn-warning btn-block" id="kakao-login-btn"
								onclick="window.location.href='http://kauth.kakao.com/oauth/authorize?response_type=code&client_id=a1c0a96f3d1b22d355a2beb880950df0&redirect_uri=http://localhost:8080/login'">
								<i class="fab fa-kakao"></i> 카카오 로그인
							</button>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>

	<script>
		Kakao.init('YOUR_KAKAO_JAVASCRIPT_KEY');
		$('#kakao-login-btn').click(function() {
			Kakao.Auth.login({
				success : function(authObj) {
					console.log(authObj);
				},
				fail : function(err) {
					alert(JSON.stringify(err));
				}
			});
		});

		$(document).ready(function() {
			$('#loginForm').submit(function(e) {
				e.preventDefault();
			});
		});
	</script>

	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
