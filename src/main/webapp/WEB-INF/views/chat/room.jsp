<%-- <%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

<head>
  <title>Chat</title>
  <!-- Required meta tags -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
    integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
  <link rel="stylesheet" type="text/css"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
  <link rel="stylesheet" type="text/css" href="../resources/css/style.css">
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>

<body>
  <div class="container-fluid">

    <div class="row">

      <div class="col-sm-12">


        <div id="user_chat_data" class="user_chat_data">
          <div class="profile_name">
            &nbsp;&nbsp;&nbsp;&nbsp;
            <img src="../resources/img/profile.png" class="mr-3 rounded-circle"> &nbsp;&nbsp; ${room.chatroomName } </div>

          <div class="container-fluid chat_section" id="chat-box">


		<c:forEach items="${preMsg}" var="preMsg">
		    <c:choose>
			    <c:when test="${preMsg.senderId eq room.userId}">
			       <div class="outgoing_msg">
	                <div class='sent_msg'>
	                	<p>${preMsg.content}</p>
	               		<span class="time_date">${preMsg.sentAt}</span>
	                </div>
	            </div>
			    </c:when>
		    <c:otherwise>
	            <!-- senderId와 room.userId가 같지 않은 경우 -->
	            <div class="incoming_msg">
		            <div class="received_msg">
		                <div class='received_withd_msg'>
		                	<p>${preMsg.content}</p>
		               		<span class="time_date">${preMsg.sentAt}</span>
		                </div>
		            </div>
	            </div>
	        </c:otherwise>
		    </c:choose>
		    </c:forEach>
		    <div class="received_msg">
		<c:forEach items="${preMsg}" var="preMsg">
		    <c:choose>
			    <c:when test="${preMsg.senderId eq room.userId}">
			       <div class="outgoing_msg">
	                <div class='sent_msg'>
	                	<p>${preMsg.content}</p>
	               		<span class="time_date">${preMsg.sentAt}</span>
	                </div>
	            </div>
			    </c:when>
		    <c:otherwise>
	            <!-- senderId와 room.userId가 같지 않은 경우 -->
	            <div class="incoming_msg">
		            <div class="received_msg">
		                <div class='received_withd_msg'>
		                	<p>${preMsg.content}</p>
		               		<span class="time_date">${preMsg.sentAt}</span>
		                </div>
		            </div>
	            </div>
	        </c:otherwise>
		    </c:choose>
		    </c:forEach>
		     </div>
            <!-- 받은메시지 시작 -->
            
              <div class="received_msg">
                <div class="received_withd_msg">
                  <p>Lorem Ipsum refers to text that the DTP (Desktop Publishing) industry use as replacement text when
                    the real text is not </p>
                  <span class="time_date"> 11:18 | Today</span>
                </div>
              </div>
            </div>
            <!-- 받은메시지 끝 -->

            <!-- 보낸메시지 시작 -->
            <div class="outgoing_msg">
              <div class="sent_msg">
                <p>Lorem Ipsum refers to text that the DTP (Desktop Publishing) industry use as replacement text when
                  the real text is not </p>
                <span class="time_date"> 11:18 | Today</span>
              </div>
            </div>
            <!-- 보낸메시지 끝 -->
            
	            

          </div>

          <div class="type_msg">
            <div class="input_msg_write">
              <input id="chat-outgoing-msg" type="text" class="write_msg" placeholder="Type a message" />
              <button id="send-button" class="msg_send_btn" type="button"><i class="fa fa-paper-plane"
                  aria-hidden="true"></i></button>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>

  <script src="../resources/js/chat.js"></script>

  <!-- jQuery first, then Popper.js, then Bootstrap JS -->
  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
    integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
    integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
    crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
    integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
    crossorigin="anonymous"></script>
    
<script>
var roomName = "${room.chatroomName}";
var roomId = "${room.chatroomId}";
var userId = "${room.userId}";

console.log(roomName + ", " + roomId + ", " + userId);

let inMsg = document.querySelector(".incoming_msg");
//let outMsg = document.querySelector(".outgoing_msg");

var sockJs = new SockJS("/stomp/chat");
var stomp = Stomp.over(sockJs);

// stomp연결
stomp.connect({}, function (){
    let content = '';
    stomp.subscribe("/sub/chat/room/" + roomId, function (chat) {
        var messages = JSON.parse(chat.body);
        var writer = messages.senderId;
        var message = messages.content;
        var sendAt = messages.sentAtAsString;
        console.log(sendAt);
        var str = '';

        if(writer == userId){
            str = "<div class='sent_msg'>";
            str += "<p>" + message + "</p>";
            str += "<span class='time_date'>" + sendAt + "</span>";
            str += "</div>";
            inMsg.innerHTML += str;
        }
        else{
            str = "<div class='received_withd_msg'>";
            str += "<p>" + message + "</p>";
            str += "<span class='time_date'>" + sendAt + "</span>";
            str += "</div>";
            content += str;
            inMsg.innerHTML = content;
        }
    });

    stomp.send('/pub/chat/enter', {}, JSON.stringify({chatroomId: roomId, senderId: userId}))
});

let sendBtn = document.getElementById("send-button");
let msgInput = document.getElementById("chat-outgoing-msg");

// 전송버튼 클릭시
sendBtn.addEventListener('click', (e) => { 
    sendMessage();
});
// 엔터클릭시
msgInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        sendMessage();
    }
});

function initMessage(preMessage) {
    var msg = preMessage; // 수정: jQuery를 사용하여 요소를 선택
    console.log(userId + ":" + msg);
    stomp.send('/pub/chat/message', {}, JSON.stringify({chatroomId: roomId, content: msg, senderId: userId}));
    $("#chat-outgoing-msg").val(''); // 수정: 메시지 전송 후 입력 필드 초기화
}

function sendMessage() {
    var msg = $("#chat-outgoing-msg").val(); // 수정: jQuery를 사용하여 요소를 선택
    console.log(userId + ":" + msg);
    stomp.send('/pub/chat/message', {}, JSON.stringify({chatroomId: roomId, content: msg, senderId: userId}));
    $("#chat-outgoing-msg").val(''); // 수정: 메시지 전송 후 입력 필드 초기화
}
</script>
</body>

</html>
 --%>
















<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Chat Room</title>
     <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
   <style>
   
nav {
    position: fixed; /* 화면 상단에 고정 */
    top: 0; /* 화면의 맨 위에 배치 */
    width: 100%; /* 너비 100%로 설정하여 화면 전체 너비를 차지하도록 함 */
    height: 50px; /* 네비게이션 바의 높이 설정 */
    background-color: #ffffff; /* 배경색 지정 */
    z-index: 9999; /* 다른 요소 위에 표시되도록 z-index 설정 */
    border-bottom: 1px solid #ccc; /* 하단 테두리 추가 */
}

.input-group {
    position: fixed; /* 화면 하단에 고정 */
    bottom: 0; /* 화면의 맨 아래에 배치 */
    left: 0; /* 좌측에 정렬 */
    width: 100%; /* 너비 100%로 설정하여 화면 전체 너비를 차지하도록 함 */
    height: 50px; /* 입력창의 높이 설정 */
    padding: 10px; /* 여백 설정 */
    background-color: #fff; /* 배경색 지정 */
    border-top: 1px solid #ccc; /* 상단 테두리 추가 */
    z-index: 9999; /* 다른 요소 위에 표시되도록 z-index 설정 */
}

.container {
    margin-top: 8%; /* 네비게이션 바의 높이만큼 공간을 확보 */
    margin-bottom: 8%; /* 입력창의 높이만큼 공간을 확보 */
    /* 네비게이션 바와 입력창 사이의 공간 설정 */
}
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">${room.chatroomName}</a>
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

    <div class="col-6">
    <c:forEach items="${preMsg}" var="preMsg">
	    <c:choose>
		    <c:when test="${preMsg.senderId eq room.userId}">
		       <div class="pre-msg">
			            <div class='alert alert-warning' >
			            	<b>:${preMsg.content}</b>
			            	<span>${preMsg.sentAt} </span>
			            </div>
			        </div>
		    </c:when>
	    <c:otherwise>
            <!-- senderId와 room.userId가 같지 않은 경우 -->
            <div class="pre-msg">
                <div class='alert alert-info'>
                    <b>${preMsg.senderId}:${preMsg.content}</b>
                    <br> ${preMsg.sentAt} 
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    </c:forEach>
    </div>
        <div id="msgArea" class="col"></div>
        <div class="col-6">
            <!-- 여기에 대화 들어옴 -->
            <div class="input-group mb-3">
                <input type="text" id="msg" class="form-control">
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
<script>

	// 네비게이션 바를 스크롤해도 화면 상단에 고정
	window.addEventListener("scroll", function() {
	    var nav = document.querySelector("nav");
	    if (nav) {
	        nav.style.top = window.scrollY + "px";
	    }
	});
    // 페이지 로드 시 자동으로 스크롤을 최하단으로 이동
    window.onload = function() {
        // 스크롤 영역을 가진 요소의 ID를 변경해야 합니다. 예를 들어 'msgArea'라고 가정
        var scrollElement = document.getElementById("msgArea");

        // 스크롤 영역이 존재하면
        if (scrollElement) {
            // 스크롤 영역의 스크롤을 최하단으로 이동
            scrollElement.scrollTop = scrollElement.scrollHeight;
        }
    };

    // 창 닫기
    function closeWindow() {
        window.close();
    }
	console.log(${Session })
	var nickname = "${sessionScope.nickname }";
	var roomName = "${room.chatroomName}";
	var roomId = "${room.chatroomId}";
	var userId = "${room.userId}";
	
	console.log(roomName + ", " + roomId + ", " + userId);
	
	let msgArea = document.getElementById("msgArea");
	
	// SockJS : WebSocket을 지원하지 않는 브라우저에서 실행시 런타임에서 필요 코드 생성하는 라이브러리
	var sockJs = new SockJS("/stomp/chat");
	// 1. SockJS를 STOMP로 전달
	var stomp = Stomp.over(sockJs);
	// 2. 연결
	stomp.connect({}, function (){
	
	   //4. subscribe(path, callback) 서버로부터 메세지를 수신
	   let content = '';
	   stomp.subscribe("/sub/chat/room/" + roomId, function (chat) {
	       var messages = JSON.parse(chat.body);
			console.log(messages)
	       var writer = messages.senderId;
	       var message = messages.content;
	       var sendAt = messages.sentAtAsString;
	       var str = '';
	
	       if(writer == userId){
	           str = "<div class='col-6'>";
	           str += "<div class='alert alert-warning'>";
	           str += "<b>" + " : " + message + "</b><br>" + sendAt;
	           str += "</div></div>";
	           messages += str;
				msgArea.innerHTML = messages;
	       }
	       else{
	           str = "<div class='col-6'>";
	           str += "<div class='alert alert-info'>";
	           str += "<b>" + writer + " : " + message + "</b><br>" + sendAt;
	           str += "</div></div>";
	       }
	
	       content += str;
			msgArea.innerHTML = content;
	   });
	
	   //3. send(path, header, message) 서버로 메세지 전송
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
	        sendMessage();
	    }
	});

	function sendMessage() {
	    var msg = msgInput.value;
	    console.log(userId + ":" + msg);
	    stomp.send('/pub/chat/message', {}, JSON.stringify({chatroomId: roomId, content: msg, senderId: userId}));
	    msgInput.value = '';
	}
	
</script>
</body>
</html>