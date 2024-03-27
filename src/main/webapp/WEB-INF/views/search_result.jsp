<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ferr - research</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .box-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: start;
            gap: 20px; /* 박스 사이의 간격 */
            margin: 20px;
        }

        .image-item {
            display: inline-block;
            width: 300px;
            height: 200px;
            background-size: cover;
            background-position: center;
            position: relative;
            color: #fff;
            text-shadow: 2px 2px 4px #000;
        }

        .image-text {
            position: absolute;
            width: 100%;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            padding: 5px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div id="searchResults" class="box-container">
            <!-- 동적으로 검색 결과가 여기에 추가됩니다 -->
        </div>
    </div>

    <script>
	    document.addEventListener('DOMContentLoaded', function() {
	        document.getElementById('searchButton').addEventListener('click', function(event) {
	        	
	            event.preventDefault(); // Form의 기본 제출 동작 방지
	            var region = document.getElementById('regionFilter').value;
	            var startDate = document.getElementById('startDateFilter').value.replaceAll('-', '');
	            var endDate = document.getElementById('endDateFilter').value.replaceAll('-', '');
	            var serviceKey = 'UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D';
	            var url = `http://apis.data.go.kr/B551011/KorService1/searchFestival1?serviceKey=${serviceKey}&eventStartDate=${startDate}&eventEndDate=${endDate}&areaCode=${region}&listYN=Y&MobileOS=ETC&MobileApp=TestApp&_type=json&numOfRows=12&pageNo=1`;
	
	            fetch(url)
	            .then(response => response.json())
	            .then(data => {
	                const items = data.response.body.items.item;
	                const container = document.getElementById('searchResults');
	                container.innerHTML = ''; // 기존 내용 초기화
	                items.forEach(item => {
	                    const title = item.title;
	                    const firstImage = item.firstimage || ''; 
	                    const addr1 = item.addr1 || '';
	                    const imageItem = document.createElement('div');
	                    imageItem.className = 'image-item';
	                    imageItem.style.backgroundImage = `url(${firstImage})`;
	                    const imageText = document.createElement('div');
	                    imageText.className = 'image-text';
	                    imageText.textContent = `${title} - ${addr1}`;
	                    imageItem.appendChild(imageText);
	                    container.appendChild(imageItem);
	                });
	            })
	            .catch(error => console.error('Error:', error));
	        });
	    });
	    
	    console.log("url = " + url);

    </script>
</body>
</html>
