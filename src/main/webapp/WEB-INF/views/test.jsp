<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Dashboard</title>
    <!-- Bootstrap CSS 추가 -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Kakao 지도 API -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4ab58942baeca720a2aebc0f0502fb9f&libraries=services"></script>
</head>
<body>

<div class="container mt-5">
    <h2>여행 계획하기</h2>
    <!-- 여행 계획 폼 -->
    <form>
        <div class="form-group">
            <label for="startPoint">출발점:</label>
            <input type="text" class="form-control" id="startPoint" name="startPoint">
        </div>
        <div class="form-group">
            <label for="endPoint">도착점:</label>
            <input type="text" class="form-control" id="endPoint" name="endPoint">
        </div>
        <div class="form-group">
            <label for="transport">이동 수단:</label>
            <select class="form-control" id="transport" name="transport">
                <option value="public">대중교통</option>
                <option value="car">자차</option>
                <option value="walk">걷기</option>
            </select>
        </div>
        <div class="form-group">
            <label for="store">방문할 가게:</label>
            <input type="text" class="form-control" id="store" name="store">
        </div>
        <button type="submit" class="btn btn-primary">계획하기</button>
    </form>

    <!-- 날씨 정보를 위한 빈 컨테이너 -->
    <div id="weatherContainer" class="mt-5">
        <h3>날씨 정보</h3>
        <!-- 날씨 정보가 여기에 표시됩니다 -->
    </div>

    <!-- 지도를 위한 빈 컨테이너 -->
    <div id="map" style="width:500px;height:400px;" class="mt-5"></div>
</div>

<!-- Bootstrap JS, Popper.js, and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.6/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    // 지도를 담을 영역의 DOM 레퍼런스를 가져옵니다.
    var container = document.getElementById('map');
    // 지도를 생성할 때 필요한 기본 옵션을 설정합니다.
    var options = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 초기 중심좌표를 설정합니다.
        level: 3 // 지도의 레벨(확대, 축소 정도)을 설정합니다.
    };

    // 지도를 생성하고 객체를 리턴받습니다.
    var map = new kakao.maps.Map(container, options);

    // OpenWeatherMap API를 사용하여 날씨 정보를 불러오는 함수입니다.
    function getWeather(lat, lon) {
        var apiKey = "6a1afcb75dd2ad7da37f056caaa60d7a"; // 여기에 발급받은 OpenWeatherMap API 키를 넣어주세요.
        if (!apiKey) {
            console.error("OpenWeatherMap API 키가 설정되지 않았습니다.");
            return;
        }
        var url = `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}`;

        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                var weatherContainer = document.getElementById('weatherContainer');
                weatherContainer.innerHTML = `현재 위치의 날씨: ${data.weather[0].description}, 온도: ${data.main.temp}°C`;
            })
            .catch(error => console.error('Error:', error));
    }

    // 브라우저의 현재 위치를 얻어와서 날씨 정보를 불러오는 함수를 호출합니다.
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            var lat = position.coords.latitude; // 위도
            var lon = position.coords.longitude; // 경도
            console.out
            getWeather(lat, lon); // 날씨 정보를 불러옵니다.
        });
    } else {
        console.error("Geolocation is not supported by this browser.");
    }
</script>
</body>
</html>
</html>
