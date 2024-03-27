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
    
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
   <style>
   
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

    </style>
</head>
<body class="bg-gray-100 h-screen antialiasd leading-none">
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">${room.chatroomName}</a>
        <!-- 참여중인 유저 인원수 출력 + 카톡기본이미지같은거 하나 넣어두고 -->
        <!-- 클릭하면 유저 검색해서 추가할수있게 기능추가할것 -->
        <!-- 클릭 가능한 요소 -->
<span id="countUser">현재 참여인원</span>
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
	<ul class="countUser">
	<ul id="userList"></ul>
		<button id="modalBtn" class="btn user-insert-btn" type="button">+ 대화상대 초대</button>
    </ul>
  </div>
</div>
<!-- 대화상대 추가 모달 -->
<div id="myModal5" class="modal5">
  <div class="modal-content">
	    <div id="selectedItems"></div> <!-- 선택된 항목을 표시할 영역 -->
	    <input type="text" id="searchInput" placeholder="검색"> <!-- 검색 입력 상자 -->
	    <ul id="searchResults"></ul> <!-- 검색 결과를 표시할 리스트 -->
		    <button id="addBtn">추가</button> <!-- 저장 버튼 -->
		    <button id="closeBtn">취소</button> <!-- 저장 버튼 -->
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

document.getElementById("countUser").innerHTML = "현재 참여인원" + users;

// 여러명일때 제목 그룹채팅으로 변경
window.onload = function() {
	var title = document.getElementById("chatTitle");
    title.innerHTML = "";
    if(users > 2){
		   title.innerHTML = "그룹 채팅";
    }
};
//========================================================================
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
        formattedDate = month + '월 ' + day + '일';
    }

    // 반환
    return formattedDate;
}
function loadDataInterval() {
    // 페이지 로딩 시 이전 채팅 이력을 서버로부터 받아와서 표시
    $.ajax({
        url: '/chat/ajaxInfo', // 서버의 데이터를 가져올 URL
        type: 'GET',
        data: { 
        	roomId: roomId 
        	}, // 요청 시 필요한 데이터 (예: 채팅방 ID)
        success: function(response) {
        	var item = response;
        	var count = item.count;
        	
        	 // Ajax 요청이 성공한 경우 이전 채팅 이력을 표시
            var messages = '';
            var leaveUser = response.length;
            console.log(response);
            response.forEach(function(item) {
                var str = '';
                if (item.senderId == userId) {
                    str += "<div class='col-6'>";
                    str += "<div class='alert alert-warning'>";
                    str += "<b>" + item.content + "</b><br>" + item.sentAt + "<br>";
                    if (item.count > 0) {
                        str += "읽음 표시 : " + item.count;
                        }
                    str += "</div></div>";
                } else if (item.senderId != userId) {
                    str += "<div class='col-6'>";
                    str += "<div class='alert alert-info'>";
                    str += "<b>" + item.nickname + ": " + item.content + "</b><br>" + item.sentAt + "<br>";
                    if (item.count > 0) {
	                    str += "읽음 표시 : " + item.count;
	                    }
                    str += "</div></div>";
                }
                messages += str;
            });
            $('#preMsgArea').html(messages);
            // 스크롤을 맨 아래로 이동
            $('#preMsgArea').scrollTop($('#preMsgArea')[0].scrollHeight);
            window.scrollTo(0, document.body.scrollHeight);
        },
        error: function(xhr, status, error) {
            // Ajax 요청이 실패한 경우 에러 처리
            console.error('Failed to load previous chat history:', error);
        }
    });
};
	
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
	console.log(${Session })
	console.log(roomName + ", " + roomId + ", " + userId);
	
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
	function sendMessage() {
	    var msg = msgInput.value;
	    console.log(userId + ":" + msg);
	    stomp.send('/pub/chat/message', {}, 
	    		JSON.stringify({chatroomId: roomId, content: msg, senderId: userId, count: users}));
	    msgInput.value = '';
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
		searchUser();
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
	  selectedItems = [];	
	  // 체크된 상태 초기화
	  var checkboxes = document.querySelectorAll('#searchResults input[type="checkbox"]');
	  checkboxes.forEach(function(checkbox) {
	    checkbox.checked = false;
	  });
	}
	

	
	
	// 유저 추가 리스트 생성
	function searchUser() {
		var searchResults = document.getElementById("searchResults");
		var selectedItems = document.getElementById("selectedItems");
		searchResults.innerHTML = '';
	    $.ajax({
	        url: '/chat/search', // 서버의 데이터를 가져올 URL
	        type: 'POST',
	        success: function(response) {
	            response.forEach(function(item) {
	                    var isUserLeft = true;
	                    roomUserList.forEach(function(roomUserList) {
	                        if (roomUserList.userId === item.userId) {
	                            isUserLeft = false;
	                        }
	                    });
					var str = '';
					if(isUserLeft){
						str += "<div><img src='/img/1581304118739.jpg' id='user-img' alt='" + item.userId + "' style='width: 25px; height: 25px;'>"; // item.profileImageUrl 로 바꿔야함
						str += "<label='checkbox'>" + item.nickname + "</label>";
						str += "<input type='checkbox' id='list-user' userId='" + item.userId + "'></div>";
						searchResults.innerHTML += str;
					} else{
						// false
						str += "<span><img src='/img/1581304118739.jpg' id='user-img' alt='" + item.userId + "' style='width: 25px; height: 25px;'>"; // item.profileImageUrl 로 바꿔야함
						str += "<label='checkbox'>" + item.nickname + "</label>";
						str += "<input type='checkbox' id='list-user' checked='true' disabled userId='" + item.userId + "'></span>";
						selectedItems.innerHTML += str;
						
						str = '';
						str += "<div><img src='/img/1581304118739.jpg' id='user-img' alt='" + item.userId + "' style='width: 25px; height: 25px;'>"; // item.profileImageUrl 로 바꿔야함
						str += "<label='checkbox'>" + item.nickname + "</label>";
						str += "<input type='checkbox' id='list-user' checked='true' disabled userId='" + item.userId + "'></div>";
						searchResults.innerHTML += str;
					}
	            });
	            var disabledItemsList = [];

	            var listItems = document.querySelectorAll("#selectedItems span");

	            listItems.forEach(function(item) {
	                var checkbox = item.querySelector("input[type='checkbox']");
	                
	                if (checkbox && checkbox.disabled) {
	                    var altValue = item.querySelector("img").alt;
	                    disabledItemsList.push(altValue);
	                }
	            });

	            console.log(disabledItemsList);
	            
	            
	            
	         // 검색 입력 이벤트 추가
	         	var searchInput = document.getElementById("searchInput");
	        	searchInput.addEventListener("input", function() {
	        		
	        		var searchValue = this.value.toLowerCase(); // 검색어를 소문자로 변환
	        		var searchResults = document.getElementById("searchResults"); // 검색결과창
	        		var selectedItems = document.getElementById("selectedItems"); // 체크결과창
	        		var userImg = document.getElementById("user-img");
	        		  	searchResults.innerHTML = '';
        		  	
	        		// 선택된 요소를 가진 div를 선택합니다.
	       		  	var selectedItems = document.getElementById("selectedItems");
	       		  	// 선택된 요소들을 담을 배열을 만듭니다.
	       		  	var selectedUserItems = [];
	        		  	
	        		  //검색 결과 생성
	        		  for (var i = 0; i < userList.length; i++) {
						    var item = userList[i].nickname.toLowerCase();
						    if (item.includes(searchValue)) {
						        var isDisabled = false; // 각 사용자의 활성/비활성 상태를 저장할 변수
						        for (var j = 0; j < disabledItemsList.length; j++) {
						            if (disabledItemsList[j] == userList[i].userId) {
						                isDisabled = true; // 해당 사용자가 비활성 상태인 경우에만 true로 설정
						                break; // 비활성 상태를 찾았으면 추가 검색은 불필요하므로 반복문 종료
						            }
						        }
						        var str = ''; // HTML 문자열을 저장할 변수
						        str += "<div><img src='/img/1581304118739.jpg' id='user-img' alt='" + userList[i].userId + "' style='width: 25px; height: 25px;'>";
						        str += "<label='checkbox'>" + userList[i].nickname + "</label>";
						        if (isDisabled) {
						            str += "<input type='checkbox' id='list-user' checked='true' disabled userId='" + userList[i].userId + "'>"; // 비활성 상태인 경우 checked와 disabled 속성 추가
						        } else {
						            str += "<input type='checkbox' id='list-user' userId='" + userList[i].userId + "'>"; // 활성 상태인 경우 checked와 disabled 속성 없음
						        }
						        str += "</div>";
						        searchResults.innerHTML += str;
						    }
						}
	        		  
	        		// checkbox 요소를 가져와서 클릭 이벤트를 추가합니다.
	        		  var checkboxes = document.querySelectorAll('#searchResults input[type="checkbox"]');
	        		  checkboxes.forEach(function(checkbox) {
	        		      checkbox.addEventListener('click', function() {
	        		          // 체크박스가 체크되었을 때
	        		          if (this.checked) {
	        		        	  console.log('선택된 요소 복제 중');
	        		        	  var selectedUserItem = this.parentNode.cloneNode(true);
	        		        	  console.log('선택된 요소 복제 완료');

	        		        	  // 이미지도 복사해야 합니다.
	        		        	  var image = selectedUserItem.querySelector('img');
	        		        	  if (image) {
	        		        	      var clonedImage = image.cloneNode(true);
	        		        	      selectedUserItem.prepend(clonedImage); // 이미지를 복사한 후 선택된 요소의 첫 번째 자식으로 추가합니다.
	        		        	  }

	        		        	  selectedItems.appendChild(selectedUserItem);
	        		        	  selectedUserItems.push(selectedUserItem);
	        		        	// 체크박스가 해제되었을 때
	        		          } else { 
	        		        	  console.log('체크박스 해제됨');
	        		        	    // 선택된 요소의 userId 값을 가져옵니다.
	        		        	    const userId = this.getAttribute('userId');
	        		        	    console.log('체크 해제된 사용자의 userId:', userId);
	        		        	    
	        		        	    // 배열에서 userId를 기준으로 해당 요소를 찾아 제거합니다.
	        		        	    var indexToRemove = selectedUserItems.findIndex(item => item.querySelector('input').getAttribute('userId') === userId);
	        		        	    console.log('제거할 요소 인덱스:', indexToRemove);
	        		        	    if (indexToRemove !== -1) {
	        		        	        console.log('선택된 요소 제거 중');
	        		        	        selectedItems.removeChild(selectedUserItems[indexToRemove]);
	        		        	        console.log('선택된 요소 제거 완료');
	        		        	        selectedUserItems.splice(indexToRemove, 1);
	        		        	    }
	        		        	}
	        		      }); // checkbox.addevent
	        		  }); // foreach
	        			
	        	});
	        }, // success
	        error: function(xhr, status, error) {
	            // Ajax 요청이 실패한 경우 에러 처리
	            console.error('Failed to load previous chat history:', error);
	        }
	    });
	};
	function renderSelectedItems() {

	    // 선택된 항목을 표시
	    for (var i = 0; i < selectedItems.length; i++) {

	    }
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