<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Chat Room</title>
    <!-- 임시로 사용함 지워도 무방 -->
     <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@600&display=swap"
	rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
   <style>
   body {
    font-family: 'Noto Sans KR', sans-serif;
    font-weight: 600;
}
   
nav {
    position: fixed; /* 화면 상단에 고정 */
    top: 0; /* 화면의 맨 위에 배치 */
    width: 100%; /* 너비 100%로 설정하여 화면 전체 너비를 차지하도록 함 */
    height: 50px; /* 네비게이션 바의 높이 설정 */
    background-color: #ffffff; /* 배경색 지정 */
    z-index: 500; /* 다른 요소 위에 표시되도록 z-index 설정 */
    border-bottom: 1px solid #ccc; /* 하단 테두리 추가 */
}

.input-group {
    position: fixed; /* 화면 하단에 고정 */
    bottom: 0; /* 화면의 맨 아래에 배치 */
    left: 0; /* 좌측에 정렬 */
    width: 100%; /* 너비 100%로 설정하여 화면 전체 너비를 차지하도록 함 */
    height: 100px; /* 입력창의 높이 설정 */
    padding: 10px; /* 여백 설정 */
    padding-bottom: 0;
    margin-bottom: 0px;
    background-color: #fff; /* 배경색 지정 */
    border-top: 1px solid #ccc; /* 상단 테두리 추가 */
    z-index: 500; /* 다른 요소 위에 표시되도록 z-index 설정 */
}

.container {
    margin-top: 58px; /* 네비게이션 바의 높이만큼 공간을 확보 */
    margin-bottom: 113px; /* 입력창의 높이만큼 공간을 확보 */
    /* 네비게이션 바와 입력창 사이의 공간 설정 */
    z-index: 10;
}
.modal {
	margin-top: 50px;
	z-index: 1000;
}
.modal5 {
	margin-top: 50px;
    display: none; /* 초기에는 숨겨진 상태 */
    position: fixed; /* 고정 위치 */
    z-index: 1000; /* 다른 요소 위에 표시 */
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto; /* 스크롤 가능하도록 설정 */
    background-color: rgba(0,0,0,0.4); /* 반투명한 배경 */
  }
  span {
        white-space: nowrap; /* 텍스트가 줄 바꿈되지 않도록 설정 */
        margin-right: 5px;
        margin-left: 5px;
    }
#selectedItems {
    min-height: 15px; /* 기본 높이 설정 */
    max-height: 100px; /* 최대 높이를 200px로 제한 */
    overflow: auto; /* 내용이 영역을 넘어갈 경우 스크롤이 표시 */
}
#searchResults {
    min-height: 150px; /* 기본 높이 설정 */
    max-height: 150px; /* 최대 높이를 200px로 제한 */
    overflow: auto; /* 내용이 영역을 넘어갈 경우 스크롤이 표시 */
}
.chat-title {
    font-size: 1.5rem; /* 5번 크기에 해당하는 폰트 사이즈 */
}

.participants-count {
    font-size: 1rem; /* 기본 폰트 사이즈 */
}

/* 기본 말풍선 스타일 */
.bubble {
    padding: 10px 15px;
    border-radius: 20px;
    display: inline-block;
    max-width: 60%; /* 말풍선의 최대 너비를 조정 */
    margin-bottom: 5px; /* 메시지 간 간격 */
}

/* 보내는 사람(나)의 말풍선 스타일 */
.my-message {
    background-color: #DCF8C6; /* 라이트 그린 */
    margin-right: 0;
    margin-left: auto; /* 오른쪽 정렬을 위해 auto 사용 */
    border-bottom-right-radius: 0;
    float: right; /* 오른쪽에 위치 */
}

/* 받는 사람의 말풍선 스타일 */
.their-message {
    background-color: #ECECEC; /* 라이트 그레이 */
    margin-left: 0;
    margin-right: auto; /* 왼쪽 정렬을 위해 auto 사용 */
    border-bottom-left-radius: 0;
    float: left; /* 왼쪽에 위치 */
}

/* 시스템 메시지 스타일 */
.system-message {
    background-color: #FFFFE0; /* 라이트 옐로우 */
    text-align: center;
    margin: 10px auto; /* 중앙 정렬 */
    width: 100%; /* 전체 너비 사용 */
}

/* 말풍선 아래에 clearfix 추가 */
.message-clearfix {
    clear: both;
}

.system-message {
    text-align: center; /* 텍스트를 중앙으로 정렬 */
    margin: 10px 0; /* 상하 여백 추가 */
    display: block; /* 블록 레벨 요소로 설정 */
    background-color: #f0f0f0; /* 배경색 설정, 필요에 따라 조정 */
    border-radius: 10px; /* 테두리 둥글게 */
    padding: 5px; /* 내부 여백 */
}



    </style>
</head>
<body class="bg-gray-100 h-screen antialiasd leading-none">
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
       <!--  <a class="navbar-brand" href="#"></a> -->
        <span id="title"><font size=5>${room.chatroomName}</font></span>
        <!-- 참여중인 유저 인원수 출력 + 카톡기본이미지같은거 하나 넣어두고 -->
        <!-- 클릭하면 유저 검색해서 추가할수있게 기능추가할것 -->
        <!-- 클릭 가능한 요소 -->
<span id="countUser">현재 참여인원:</span>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item active">
                    <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Features</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Pricing</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<div class="container">
	<div id="preMsgArea" class="col">
	    <div class="col-6">
	    </div>
    </div>
        <div id="msgArea" class="col"></div>
        <div class="col-6">
            <!-- 여기에 대화 들어옴 -->
        <div class="input-group mb-3">
            <textarea id="msg" class="form-control" style="resize: none; height: 100px;"></textarea>
            <div class="input-group-append">
                <button class="btn btn-outline-secondary" type="button" id="button-send">전송</button>
            </div>
        </div>
    </div>
    <div class="col-6"></div>
    <!-- <span style="float: left; margin-right:7px;">
        <input type="button" value="닫기" class="Btn" onclick="closeWindow()">
        <input type="button" value="방 나가기" class="Btn" onclick="location.href='/chat/roomDel'">
    </span> -->
</div>

<!-- 대화상대 리스트 -->
<div id="myModal4" class="modal">
  <div class="modal-content">
      <div class="countUser">
        <ul id="userList"></ul>
        <button id="modalBtn" class="btn user-insert-btn" type="button">+ 대화상대 초대</button>
      </div>
  </div>
</div>
<!-- 대화상대 추가 모달 -->
<div id="myModal5" class="modal">
	<div class="modal-content">
	    <span class="close">x</span> <!-- 닫기 버튼 -->
	    <div>대화상대 선택</div>
	    <div id="ingMembers"></div> <!-- 선택된 항목을 표시할 영역 -->
	    <div id="selectedItems"></div> <!-- 선택된 항목을 표시할 영역 -->
	    <input type="text" id="searchInput" placeholder="검색"> <!-- 검색 입력 상자 -->
	    <div id="searchResults"></div> <!-- 검색 결과를 표시할 리스트 -->
	    <div>
		    <button id="addBtn">확인</button> <!-- 저장 버튼 -->
		    <button id="closeBtn">취소</button> <!-- 저장 버튼 -->
	    </div>
	</div>
</div>

<script>
var roomUserList = JSON.parse('${roomUserList}'); // 방에 참여중인유저
var userList = JSON.parse('${userList}'); // 검색용 모든유저
var nickname = "${sessionScope.nickname }";
var roomName = "${room.chatroomName}";
var roomId = "${room.chatroomId}";
var userId = "${room.userId}";
var leaveUser =  JSON.parse('${leaveUser}'); // 방을 떠난 유저
// 참여중인 유저 수
var users = ${roomUserList}.length - leaveUser.length;

document.getElementById("countUser").innerHTML = "현재 참여인원: " + users;
document.getElementById("countUser").classList.add("participants-count");
console.log(roomId);

// 여러 명일 때 제목 '그룹채팅'으로 변경
if (roomUserList.length > 2) {
    document.getElementById("title").innerHTML = '그룹';
    document.getElementById("title").classList.add("chat-title");
}
//========================================================================
	function scrollToBottom() {
    var msgArea = $('#msgArea');
    msgArea.scrollTop(msgArea.prop('scrollHeight'));
}
//날짜 형태 변환
function dateConversion(chatroom) {
    // 주어진 날짜 문자열을 Date 객체로 변환
    var sentAtDate = new Date(chatroom.sentAt);

    // 현재 날짜
    var currentDate = new Date();
    // 날짜 차이 계산 (단위: 밀리초)
    var timeDiff = currentDate - sentAtDate;
    var dayDiff = Math.floor(timeDiff / (1000 * 60 * 60 * 24));
    // 년, 월, 일을 가져오기
    var year = sentAtDate.getFullYear();
    var month = sentAtDate.getMonth() + 1; // 월 (0부터 시작하기 때문에 1을 더해줍니다.)
    var day = sentAtDate.getDate(); // 일

    // 시간을 가져오기
    var hours = sentAtDate.getHours(); // 시간 (0부터 23까지)
    var minutes = sentAtDate.getMinutes(); // 분 (0부터 59까지)

    // 시간을 두 자리 숫자로 표시하기 위해 10 미만의 값에는 앞에 0을 추가
    var ampm = hours < 12 ? '오전' : '오후';
    hours = hours % 12;
    hours = hours ? hours : 12; // 시간이 0시인 경우 12시로 표시
    minutes = (minutes < 10 ? '0' : '') + minutes;

    // 현재 날짜와의 차이에 따라 날짜를 표시하는 방식 선택
    var formattedDate = '';
    if (dayDiff === 0) {
        // 오늘일 경우 시간만 표시
        formattedDate = ampm + ' ' + hours + ':' + minutes;
    } else if (dayDiff === 1) {
        // 어제일 경우 '어제' 표시
        formattedDate = '어제';
    } else {
        // 그 외에는 월 일 표시
        formattedDate = year + '-' + month + '-' + day;
    }

    // 반환
    return formattedDate;
}
function loadDataInterval() {
    $.ajax({
        url: '/chat/ajaxInfo',
        type: 'GET',
        data: { roomId: roomId },
        success: function(response) {
            var messages = '';
            response.forEach(function(item) {
                var str = '<div class="row">'; // 메시지를 row로 시작
                if (item.messageType === 'SYSTEM') {
                    str += "<div class='col-12'>";
                    str += "<div class='system-message'>";
                    str += "<b>" + item.content + "</b><br>" + item.sentAt;
                    str += "</div></div>";
                } else {
                    var bubbleClass = item.senderId == userId ? 'my-message' : 'their-message';
                    str += "<div class='col-12'>";
                    str += "<div class='bubble " + bubbleClass + "'>";
                    str += "<b>" + (item.senderId == userId ? "" : item.nickname) + " </b>" + item.content + "<br><small>" + item.sentAt + "</small>";
                    if (item.count > 0) {
                        str += "<br><small>읽음 표시 : " + item.count + "</small>";
                    }
                    str += "</div></div>";
                }
                str += '</div>'; // row 닫기
                messages += str;
            });
            $('#msgArea').html(messages);
            $('#msgArea').scrollTop($('#msgArea')[0].scrollHeight);
        },
        error: function(xhr, status, error) {
            console.error('Failed to load previous chat history:', error);
        }
    });
}


	
// 스크롤 위치 내리기, 기존채팅 가져오기
// $(document).ready(function() {
window.onload = function() {
   window.scrollTo(0, document.body.scrollHeight);
   loadDataInterval();
};
const display = document.getElementsByClassName("container");

// 네비게이션 바를 스크롤해도 화면 상단에 고정
	window.addEventListener("scroll", function() {
	    var nav = document.querySelector("nav");
	    if (nav) {
	        nav.style.top = window.scrollY + "px";
	    }
	});

    // 창 닫기
    function closeWindow() {
        window.close();
    }
	let msgArea = document.getElementById("msgArea");
	
	// SockJS : WebSocket을 지원하지 않는 브라우저에서 실행시 런타임에서 필요 코드 생성하는 라이브러리
	var sockJs = new SockJS("/stomp/chat");
	// SockJS를 STOMP로 전달
	var stomp = Stomp.over(sockJs);
	// 연결
	stomp.connect({}, function (){
    // subscribe(path, callback) 서버로부터 메세지를 수신
    let content = '';
    // '/sub/chat/room/' 구독
    stomp.subscribe("/sub/chat/room/" + roomId, function (chat) {
        loadDataInterval();
/*         var messages = JSON.parse(chat.body);
        var writer = messages.senderId;
        var message = messages.content;
        var sendAt = messages.sentAtAsString
        var nickname = messages.nickname;
 */        var str = '';
    });
    // '/sub/chat/rooms/' 구독
    stomp.subscribe("/sub/chat/rooms/" + roomId, function (chat) {
        loadDataInterval();
    });
	   // send(path, header, message) 서버로 메세지 전송
	   stomp.send('/pub/chat/enter', {}, JSON.stringify({chatroomId: roomId, senderId: userId}))
	});
	
	let sendBtn = document.getElementById("button-send");
	let msgInput = document.getElementById("msg");

	// 버튼 클릭시 서버로 메세지 전송
	sendBtn.addEventListener('click', (e) => { 
	    sendMessage();
	});

	// Enter 키 입력시 서버로 메세지 전송
	msgInput.addEventListener('keypress', (e) => {
	    if (e.key === 'Enter') {
	        if (!e.shiftKey) {
	            sendMessage();
	         }
	    }
	});
	
	function scrollToBottom() {
	    var msgArea = document.getElementById('msgArea');
	    msgArea.scrollTop = msgArea.scrollHeight;
	}
	
	function sendMessage() {
	    var msg = msgInput.value.trim(); // 입력된 메시지 가져오기 및 공백 제거
	    if (msg) { // 메시지가 비어있지 않은 경우에만 실행
	        console.log(userId + ":" + msg);
	        stomp.send('/pub/chat/message', {}, JSON.stringify({
	            chatroomId: roomId,
	            content: msg,
	            senderId: userId,
	            count: users
	        }));
	        msgInput.value = ''; // 메시지 입력란 비우기
	        scrollToBottom(); // 스크롤 맨 아래로 이동
	    }
	}

	
		
		
	//========================================================================
	//모달 버튼 요소 가져오기
	var modalBtn = document.getElementById("modalBtn");
	var modal5 = document.getElementById("myModal5");
	var addBtn = document.getElementById("addBtn");
	var closeBtn = document.getElementById("closeBtn");
	//모달 버튼 클릭 시 해당 모달 열기
	modalBtn.onclick = function() {
		openModal5();
	};
	// 취소버튼으로 모달 닫기
	closeBtn.onclick = function() {
		closeModal5();
	}
	// 모달 열기
	function openModal5() {
		closeModal();
		modal5.style.display = "block";
		clickCount = 0;
	}
	// 대화상대 추가 모달 닫기 
	function closeModal5() {
	    modal5.style.display = "none";
	    resetModalContent(); // 모달 내용 초기화
	}
	// 모달 외부를 클릭하면 모달 닫기
	window.addEventListener("click", function(event) {
	    if (event.target == modal5) {
	        modal5.style.display = "none";
	        resetModalContent();
	    }
	});
	
	
	//모달 내용 초기화 함수
	function resetModalContent() {
	  // 검색 입력 상자 초기화
	  var searchInput = document.getElementById("searchInput");
	  searchInput.value = '';

	  // 검색 결과 리스트 초기화
	  var searchResults = document.getElementById("searchResults");
	  searchResults.innerHTML = '';

	  // 선택된 항목 초기화
	  var selectedItemsContainer = document.getElementById("selectedItems");
	  selectedItemsContainer.innerHTML = '';
	  selectedListId = [];	
	  // 체크된 상태 초기화
	  var checkboxes = document.querySelectorAll('#searchResults input[type="checkbox"]');
	  checkboxes.forEach(function(checkbox) {
	    checkbox.checked = false;
	  });
	}
	

	/////////////////////////////////////////////////////////////////////////

	var dump = []; // 고정된 멤버 id 담을 배열
		roomUserList.forEach(function(user) {
	        // 중복되지 않은 사용자인지를 나타내는 플래그 변수
	        var isUserLeft = true;

	        // leaveUser 배열에 있는 사용자와 userList 배열에 있는 사용자를 비교
	        leaveUser.forEach(function(leaveUser) {
	            if (leaveUser.userId === user.userId) {
	                // 만약 leaveUser에 해당 사용자가 있다면 중복되는 사용자이므로 플래그 변수를 false로 설정
	                isUserLeft = false;
	            }
	        });
		
		if(isUserLeft && user.userId != userId) {
				var str = '';
			  	str += "<span class='checkList'><img src='" + "/img/1581304118739.jpg'" + " class='user-img' alt='"  // item.profileImageUrl 로 바꿔야함
			  				+ user.userId + "' style='width: 25px; height: 25px;'>";
			  	str += "<label='checkbox'>" + user.nickname + "</label>";
			  	str += "<input type='checkbox' checked disabled id='list-user '"; 
		  		str += "checked "; 
		  		str += "userId='" + user.userId + "'></span>";
		  		
		  		document.getElementById("ingMembers").innerHTML += str;
		  		dump.push(user.userId);
		  		
		}
	});
	
	//검색 입력 상자 요소 가져오기
	var searchInput = document.getElementById("searchInput");

	//검색 입력 상자에 입력 이벤트 추가
	searchInput.addEventListener("input", function() {
		var searchValue = this.value.toLowerCase(); // 검색어를 소문자로 변환
		var searchResults = document.getElementById("searchResults");
		
		searchResults.innerHTML = ''; // 결과 초기화
		console.log("searchValue: " + searchValue);
		
		// 검색 결과 생성
		for (var i = 0; i < userList.length; i++) {
			  
		  var item = userList[i].nickname.toLowerCase(); // 객체의 속성에 접근하여 소문자로 변환 >> 닉네임으로 검색중
		  if(item.includes(searchValue)) {
		  	console.log("item: " + item);
		  	var str = '';
		  	str += "<div class='checkList'><img src='" + "/img/1581304118739.jpg'" + " class='user-img' alt='"  // item.profileImageUrl 로 바꿔야함
		  				+ userList[i].userId + "' style='width: 25px; height: 25px;'>";
		  	str += "<label='checkbox'>" + userList[i].nickname + "</label>";
		  	str += "<input type='checkbox' style='display: none' id='list-user '"; 
	  		str += "userId='" + userList[i].userId + "'></div>";
	  		searchResults.innerHTML += str;
			  } //if
		  } //for
		inputData();

		  
	}); // addEvent

	var selectedListId = []; // 선택된 아이템 담아줄 배열
	var selectedItems = document.getElementById("selectedItems"); // 선택된 아이템 출력되는 영역
	var selectedList = document.querySelectorAll(".selectedList"); // 선택된 각각의 아이템 전체 리스트

	// 체크박스 클릭시 이벤트 : userId 받아옴
	function inputData () {
		// checkList 클래스명을 가진 모든 요소
		var checkLists = document.querySelectorAll(".checkList");
		var clickNum = 0;  
		// 각 요소에 대해 이벤트 리스너를 추가
		checkLists.forEach(function(checkList) {
		    checkList.addEventListener("click", function() {
	    		var userId = checkList.querySelector("input[type='checkbox']").getAttribute("userid");
		    	console.log("userId ??" + userId);	
	    		selectArray(userId); // 선택된 값 담아주는 함수
		    		
		    });
		});
	}


	// 결과 선택하면 배열에 저장
	function selectArray(userId) { // 선택한 값의 userId
		if(selectedListId.length == 0) {
			
			for(var i = 0; i < dump.length; i++) {
				var res1 = true;
				if(dump[i] == userId){
					res1 = false;
					break;
				}
			}
			if(res1){
				selectedListId.push(userId);
				console.log("userId : " + userId);
			}
		} else {
			for(var i = 0; i < selectedListId.length; i++) {
				var res = true;
				if(selectedListId[i] == userId) {
					res = false;
					break;
				}
			}
			for(var i = 0; i < dump.length; i++) {
				var res2 = true;
				if(dump[i] == userId) {
					res2 = false;
					break;
				}
			}
			if(res && res2){
				
				selectedListId.push(userId);
				console.log("slectdeListID + " + selectedListId);
			}
		}
		cnffur(); // 선택한 결과 배열 출력
	};

	// 결과 출력
	function cnffur(){
		selectedItems.innerHTML = '';
		for(var i = 0; i < selectedListId.length; i++) {
			for(var j = 0; j < userList.length; j++) {
				if(selectedListId[i] == userList[j].userId){	
					var str = '';
					str += "<span class='selectedList'><img src='/img/1581304118739.jpg' alt='" + selectedListId[i] + "' style='width: 25px; height: 25px;'>";
					str += "<label for='checkbox'>" + userList[j].nickname+ "</label>";
					str += "<input type='checkbox' class='selectedUser' checked userId='" + selectedListId[i] + "'></span>";
					selectedItems.innerHTML += str;
					break;
				}
			}
		}
		// 선택된 아이템 id 값 가져오기
		var selectedUsers = selectedItemsDiv.querySelectorAll('.selectedUser');
		selectedUsers.forEach(function(selectedUser) {
	        selectedUser.addEventListener('click', function() {
	            var userId = this.getAttribute('userId');
	            console.log('Clicked user ID:', userId);
	            deleteItem(userId);
	        });
	    });
	}

	// 선택된 아이템 제거
	function deleteItem(userId) {
		for (var i = 0; i < selectedListId.length; i++) {
		    if (selectedListId[i] === userId) {
		        selectedListId.splice(i, 1); // 중복된 userId를 배열에서 제거
		        break; // 값이 하나씩 들어올테니 증복되면 바로 종료
		    }
		} 
		cnffur();
	}

	//선택된 사용자 목록을 담고 있는 div 요소
	var selectedItemsDiv = document.getElementById('selectedItems');

	//"확인" 버튼 클릭 시
	document.getElementById("addBtn").addEventListener("click", function() {

	  if (selectedListId.length === 0) {
	    alert("선택된 항목이 없습니다.");
	    return;
	  }
	// 선택된 항목들을 배열로 묶어서 JSON 형식으로 변환
	  var jsonData = JSON.stringify(selectedListId);
	

	  // JSON 데이터를 서버로 전송
	  $.ajax({
	    type: "POST",
	    url: "/chat/addMember",
	    contentType: "application/json", // JSON 데이터 형식으로 전송
	    data: JSON.stringify({ userId: selectedListId, chatroomId: roomId }),
	    success: function(response) {
	      // 성공 시 처리
	      console.log("선택된 항목을 서버로 전송했습니다.");
	      inviteMsg();
	      modal5.style.display = "none"; // 모달 닫기
	      resetModalContent();
	    },
	    error: function(xhr, status, error) {
	      // 에러 발생 시 처리
	      console.error("서버로의 전송에 실패했습니다:", error);
	    }
	  }); //$
	  
	});

	function inviteMsg() {
		var selectNickname = '';
		for(var i = 0; i < selectedListId.length; i++) {
			for(var j = 0; j < userList.length; j++) {
				if(selectedListId[i] == userList[j].userId){
					selectNickname += userList[j].nickname + " ";
				}
			}
		}
	    var msg = nickname + "님이 " + selectNickname + "님을 초대하였습니다.";
	    var messageType = 'SYSTEM';
	    console.log(userId + ":" + msg);
	    stomp.send('/pub/chat/message', {}, 
	    		JSON.stringify({chatroomId: roomId, content: msg, senderId: userId, messageType: messageType}));
	    msgInput.value = '';
		
	}
	
	//==========================================================================
	
	
	var clickCount = 0; // 클릭 횟수 저장할 변수
	// 클릭 이벤트 리스너 추가
	var countUserElement = document.getElementById("countUser");
	countUserElement.addEventListener("click", function() {
		clickCount++;
		if(clickCount ===1){
		    openModal();
			
		}else {
			closeModal();
			clickCount = 0;
		}
	});

	// 모달 열기 함수
	function openModal() {
	    var modal = document.getElementById("myModal4");
	    modal.style.display = "block";
	    // 유저 리스트 업데이트
	    updateUserList();
	}

	// 모달 닫기 함수
	function closeModal() {
	    var modal = document.getElementById("myModal4");
	    modal.style.display = "none";
	}

	
function updateUserList() {
    var userListElement = document.getElementById("userList");

    // 리스트 초기화
    userListElement.innerHTML = "";

    // userList와 leaveUser를 비교하여 중복되지 않는 사용자만을 리스트에 추가
    roomUserList.forEach(function(user) {
        // 중복되지 않은 사용자인지를 나타내는 플래그 변수
        var isUserLeft = true;

        // leaveUser 배열에 있는 사용자와 userList 배열에 있는 사용자를 비교
        leaveUser.forEach(function(leaveUser) {
            if (leaveUser.userId === user.userId) {
                // 만약 leaveUser에 해당 사용자가 있다면 중복되는 사용자이므로 플래그 변수를 false로 설정
                isUserLeft = false;
            }
        });

        // 중복되지 않은 사용자인 경우에만 리스트에 추가
        if (isUserLeft) {
            var listItem = document.createElement("li");
            var img = document.createElement("img");
            img.id = 'user-img';
            img.src = '/img/1581304118739.jpg'; //user.profileImageUrl;
            img.alt = user.userId;
            
         	// 이미지 크기 조절
            img.style.width = "25px";
            img.style.height = "25px";
            
         	// 사용자 닉네임 추가
            var nicknameSpan = document.createElement("span");
            nicknameSpan.textContent = user.nickname;
            
            listItem.appendChild(img);
            listItem.appendChild(nicknameSpan);
            userListElement.appendChild(listItem);
        }
    });
}


</script>
</body>
</html>