<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Event Details</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9496f9be338adc74c68fd22757fd2e12&libraries=services"></script>
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<style>
.image-container img {
	max-width: 100%;
	height: auto;
}
</style>
</head>
<body>

	<div class="container mt-5">
		<h1 id="eventTitle" class="mb-4">상세정보</h1>

		<div class="row">
			<div class="col-md-6 image-container">
				<img id="eventImage" alt="Event Image" class="img-fluid">
			</div>
			<div class="col-md-6">
				<table class="table">
					<tbody>
						<tr>
							<th scope="row">주소</th>
							<td id="eventAddress"></td>
						</tr>
						<tr>
							<th scope="row">전화번호</th>
							<td id="eventTel"></td>
						</tr>
						<tr>
							<th scope="row">상세 설명</th>
							<td id="eventOverview"></td>
						</tr>
						<tr>
							<th scope="row">행사기간</th>
							<td>2024.4.25(목) - 05.20(월)</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
		<div class="row mt-4">
			<div class="col-12">
				<h2>개요</h2>
				<p>- 보신각 타종행사 시민과 함께하는 천년의 종소리 ! 보신각 타종행사...</p>
				<!-- 개요 내용 추가 -->
			</div>
		</div>
		<div class="container">
        <h2>행사 위치정보</h2>
        <div id="map" style="width:100%;height:350px;"></div>
		
		<div class="row mt-4">
    	<div class="col-12">
        <!-- 일정 생성/저장 버튼 -->
        <button type="button" class="btn btn-warning mt-3" id="createScheduleModal">일정 생성/저장</button>
    	</div>
		</div>
		<!-- 로그인이 필요한 알림 모달 -->
		<div class="modal fade" id="loginRequiredModal" tabindex="-1" role="dialog" aria-labelledby="loginRequiredModalLabel" aria-hidden="true">
    		<div class="modal-dialog" role="document">
        		<div class="modal-content">
            		<div class="modal-header">
               		 <h5 class="modal-title" id="loginRequiredModalLabel">로그인 필요</h5>
                		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                로그인이 필요한 서비스입니다. 로그인을 진행해주세요.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>


                <!-- 일정 생성 모달 -->
                <div class="modal" id="scheduleModal">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title">일정 생성</h4>
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                            </div>
                            <div class="modal-body">
                                <form id="scheduleForm">
                                    <div class="form-group">
                                        <label for="eventTitle">일정 이름:</label>
                                        <input type="text" class="form-control" id="eventTitle" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="contentId">Content ID:</label>
                                        <input type="text" class="form-control" id="contentId" required>
                                    </div>
                                    <!-- 사용자 세션에서 user ID 자동으로 가져오기 -->
                                    <input type="hidden" id="userId" value="${sessionScope.userId}">
                                    <div class="form-group">
                                        <label for="eventStartDate">시작 날짜:</label>
                                        <input type="date" class="form-control" id="eventStartDate" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="eventEndDate">종료 날짜:</label>
                                        <input type="date" class="form-control" id="eventEndDate" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="promiseDate">약속 날짜:</label>
                                        <input type="date" class="form-control" id="promiseDate" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="latitude">위도:</label>
                                        <input type="text" class="form-control" id="latitude" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="longitude">경도:</label>
                                        <input type="text" class="form-control" id="longitude" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary">저장</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
	
	
<script>
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
   		center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
    	level: 3 // 지도의 확대 레벨
		};  

		//지도를 생성합니다    
		var map = new kakao.maps.Map(mapContainer, mapOption); 

		//주소-좌표 변환 객체를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder();

		//주소로 좌표를 검색합니다
		geocoder.addressSearch('서울특별시 종로구 종로 54 보신각', function(result, status) {

		// 정상적으로 검색이 완료됐으면 
 		if (status === kakao.maps.services.Status.OK) {

    	var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

    	// 결과값으로 받은 위치를 마커로 표시합니다
    	var marker = new kakao.maps.Marker({
        map: map,
        position: coords
   		});

    	// 인포윈도우로 장소에 대한 설명을 표시합니다
    	var infowindow = new kakao.maps.InfoWindow({
        content: '<div style="width:150px;text-align:center;padding:6px 0;">보신각</div>'
    	});
    	infowindow.open(map, marker);

    	// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
    	map.setCenter(coords);
		} 
		}); 
	    // 일정 생성 버튼 클릭 이벤트 처리
	    $('#createScheduleModal').click(function() {
	        // 로그인 여부 확인
	        var userId = '${sessionScope.userId}';
	        if (!userId) {
	            // 로그인이 되어 있지 않은 경우, 로그인 필요 알림 모달 표시
	            $('#loginRequiredModal').modal('show');
	            return;
	        }

	        // 로그인이 되어 있는 경우, 일정 생성 모달 표시
	        $('#scheduleModal').modal('show');
	    });

        // 일정 생성 폼 제출 시 실행되는 함수
        $('#scheduleForm').submit(function(event) {
            event.preventDefault(); // 폼 기본 동작 방지

            // 폼에 입력된 정보 가져오기
            var eventTitle = $('#eventTitle').val();
            var eventStartDate = $('#eventStartDate').val();
            var eventEndDate = $('#eventEndDate').val();
            var promiseDate = $('#promiseDate').val();
            var latitude = $('#latitude').val();
            var longitude = $('#longitude').val();
            var contentId = $('#contentId').val();
            var userId = $('#userId').val();

            // 폼 데이터 생성
            var formData = {
                eventTitle: eventTitle, 
                eventStartDate: eventStartDate,
                eventEndDate: eventEndDate,
                promiseDate: promiseDate,
                latitude: latitude,
                longitude: longitude,
                contentId: contentId,
                userId: userId
            };

            // 서버로 데이터 전송
            $.ajax({
                type: 'POST',
                url: '/saveSchedule',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                success: function(response) {
                    console.log('일정이 성공적으로 저장되었습니다.');
                    // 성공 시 필요한 처리 작업 추가
                },
                error: function(xhr, status, error) {
                    console.error('일정 저장 중 오류 발생:', error);
                    // 오류 발생 시 필요한 처리 작업 추가
                }
            });

            // 모달 닫기
            $('#scheduleModal').modal('hide');
        });
</script>

</body>
</html>


