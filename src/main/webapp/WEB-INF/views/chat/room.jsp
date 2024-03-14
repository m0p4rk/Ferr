<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Chat Room</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>
<body>
	<div class="container">
	    <div class="col-6">
	        <h1>${room.name}</h1>
	    </div>
	    <%-- <div>
    	<!-- c:foreach -->
    	<c:forEach items="${rooms}" var="room">
	        <ul class="list-group">
	            <li class="list-group-item"><a href="/chat/room?roomId=${room.roomId}">Chat Room Name : ${room.name}</a></li>
	        </ul>
    	
    	</c:forEach>
    	</div> --%>
	    <div>
	        <div id="msgArea" class="col"></div>
	        <div class="col-6">
	            <div class="input-group mb-3">
	                <input type="text" id="msg" class="form-control">
	                <div class="input-group-append">
	                    <button class="btn btn-outline-secondary" type="button" id="button-send">전송</button>
	                </div>
	            </div>
	        </div>
	    </div>
	    <div class="col-6"></div>
	    	<span style="float: left; margin-right:7px;">
	    		<input type="button" value="목록으로" class="Btn" onclick="location.href='/chat/rooms'">
	    		<input type="button" value="방 나가기" class="Btn" onclick="location.href='/chat/roomDel'">
	    	</span>
	</div>
	<%! int num; %>
	<%  num++;   %>
	<% 
		session.setAttribute("userId", num);
	%>
	<div>세션 userId : ${userId }</div>
	<script>
		var roomName = "${room.name}";
		var roomId = "${room.chatroomId}";
		var userId = "${userId}";
		
		console.log(roomName + ", " + roomId + ", " + userId);
		
		let msgArea = document.getElementById("msgArea");
		
		// SockJS : WebSocket을 지원하지 않는 브라우저에서 실행시 런타임에서 필요 코드 생성하는 라이브러리
		var sockJs = new SockJS("/stomp/chat");
		// 1. SockJS를 STOMP로 전달
		var stomp = Stomp.over(sockJs);
		// 2. 연결
		stomp.connect({}, function (){
		
		   //4. subscribe(path, callback) 서버로부터 메세지를 수신
		   let contentt = '';
		   stomp.subscribe("/sub/chat/room/" + roomId, function (chat) {
		       var content = JSON.parse(chat.body);
		
		       var writer = content.senderId;
		       var message = content.content;
		       var str = '';
		
		       if(writer == userId){
		           str = "<div class='col-6'>";
		           str += "<div class='alert alert-secondary'>";
		           str += "<b>" + " : " + message + "</b>";
		           str += "</div></div>";
					content += str;
					msgArea.innerHTML = content;
		       }
		       else{
		           str = "<div class='col-6'>";
		           str += "<div class='alert alert-warning'>";
		           str += "<b>" + writer + " : " + message + "</b>";
		           str += "</div></div>";
		       }
		
		       contentt += str;
				msgArea.innerHTML = contentt;
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