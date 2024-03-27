<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/WEB-INF/views/navbar.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<title>chat room</title>
<style>
  /* 모달 스타일링 */
  .modal {
    display: none; /* 초기에는 숨겨진 상태 */
    position: fixed; /* 고정 위치 */
    z-index: 1; /* 다른 요소 위에 표시 */
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto; /* 스크롤 가능하도록 설정 */
    background-color: rgba(0,0,0,0.4); /* 반투명한 배경 */
  }

  .modal-content {
    background-color: #fefefe; /* 모달 내용 배경색 */
    margin: 15% auto; /* 중앙 정렬 */
    padding: 20px;
    border: 1px solid #888;
    width: 80%; /* 모달 너비 */
  }

  /* 닫기 버튼 스타일링 */
  .close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
  }

  .close:hover,
  .close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
  }

  /* 선택된 항목 스타일링 */
  .selected-item {
    background-color: #f0f0f0;
    padding: 5px;
    margin-bottom: 5px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  /* 추가된 CSS */
  .fa-times {
    margin-left: 5px; /* X 아이콘과 텍스트 사이 간격 조정 */
  }
</style>

<!-- Font Awesome 아이콘 CDN 링크 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
<button id="openModalBtn">채팅룸 생성</button>
<div class="container">
    <div id="chatroomList">
    	<c:forEach items="${rooms}" var="room">
    		 <ul class="list-group">
	            <li class="list-group-item">
	            	<a href="javascript:void(0)" onclick="openChatRoom('${room.chatroomId}')" data-room-id="${room.chatroomId}">${room.chatroomName}</a>
	            	<div id="lastMsg">
	            		${room.userId} : ${room.content} <br>
	            		<fmt:formatDate value="${room.sentAt }" pattern="yyyy년 MM월 dd일 HH:mm"/>
	            		<!-- receiveCount가 0보다 크고 null이 아닐 때에만 출력 -->
					    <c:if test="${room.receiveCount > 0 and room.receiveCount ne null}">
					        <span id="receiveCount">안읽은메시지 : ${room.receiveCount}</span>
					    </c:if>
	            	</div>
	            </li>
	        </ul>
    	</c:forEach>
    </div>
</div>

<!-- 모달 버튼 -->

<!-- 유저목록조회 + 방 생성 -->
<div id="myModal" class="modal">
	<div class="modal-content">
	    <span class="close">x</span> <!-- 닫기 버튼 -->
	    <input type="text" id="searchInput" placeholder="검색"> <!-- 검색 입력 상자 -->
	    <ul id="searchResults"></ul> <!-- 검색 결과를 표시할 리스트 -->
	    <div id="selectedItems"></div> <!-- 선택된 항목을 표시할 영역 -->
	    <button id="createBtn">생성</button> <!-- 저장 버튼 -->
	</div>
</div>
<!-- 방 나가기 -->
<div id="myModal2" class="modal">
	<div class="modal-content">
	<span>정말 방에서 나가시겠습니까?</span>
	<div>
		<button id="yesBtn">예</button>
    	<button id="noBtn">아니오</button>
	</div>
	</div>
</div>
<!-- 제목 수정 -->
<div id="myModal3" class="modal">
	<div class="modal-content">
	    <span class="close">x</span>
	    <input type="text" id="roomName" placeholder="수정할 제목 입력"> <!-- 검색 입력 상자 -->
	    <!-- X 아이콘 모양의 텍스트 초기화 버튼 -->
	    <button id="clearInputBtn" class="clear-input-btn" onclick="clearInput()">초기화</button>
	    <button id="saveBtn">확인</button>
	</div>
</div>

<script>
<%
int sessionId = (Integer)session.getAttribute("userId");
String sessionNickname = (String)session.getAttribute("nickname");
%>
var sessionId = '<%= sessionId %>';
var sessionNickname = '<%= sessionNickname %>';
var rooms = document.querySelectorAll('.list-group-item a[data-room-id]');
var lastMsg = document.getElementById("lastMsg");


//채팅방 리스트를 업데이트하는 함수
function updateChatroomList() {
    $.ajax({
        url: '/chat/listUpdate', // 채팅방 리스트를 가져올 URL
        type: 'GET',
        success: function(response) {
            displayChatrooms(response); // 가져온 데이터를 화면에 표시하는 함수 호출
        },
        error: function(xhr, status, error) {
            // 오류 발생 시 처리하는 부분
            console.error('Failed to update chatroom list:', error);
        }
    });
}

//각 방의 ID를 출력
rooms.forEach(function(room) {
    var roomId = room.getAttribute('data-room-id');
    console.log("Room ID:", roomId);
    
    var sockJs = new SockJS("/stomp/chat");
	// SockJS를 STOMP로 전달
	var stomp = Stomp.over(sockJs);
    // 연결
    stomp.connect({}, function () {
        // subscribe(path, callback) 서버로부터 메세지를 수신
        let content = '';
        stomp.subscribe("/sub/chat/room/" + roomId, function (chat) {
            var messages = JSON.parse(chat.body);
            console.log(messages);
            updateChatroomList();
        });
    });
});

//페이지 로드 시 실행되는 함수
$(document).ready(function() {
    // AJAX를 통해 채팅방 리스트를 업데이트하는 함수 호출
    updateChatroomList();
});

// 날짜 형태 변환
function dateConversion(chatroom) {
    // 주어진 날짜 문자열을 Date 객체로 변환
    var sentAtDate = new Date(chatroom.sentAt);

    // 현재 날짜
    var currentDate = new Date();

 	// 날짜가 다르면 무조건 하루로 간주
    var dayDiff = sentAtDate.getDate() !== currentDate.getDate() ? 1 : 0;

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

// 채팅방 리스트를 화면에 표시하는 함수
function displayChatrooms(chatrooms) {
    chatroomList.innerHTML = ''; // 기존에 표시되어 있던 채팅방 리스트 초기화

    // 받아온 채팅방 리스트를 순회하면서 화면에 표시
    chatrooms.forEach(function(chatroom) {
    	console.log(chatroom);
        var str = '';
        // 각 채팅방을 표시할 HTML 코드 생성
        str += "<ul class='list-group'>";
        str += "<li class='list-group-item'>";
        str += "<a href='#' onclick='openChatRoom(" + chatroom.chatroomId + ")' value=" + chatroom.chatroomId + ">" + chatroom.chatroomName + "</a>" + " 참여인원 : " + chatroom.members;
        str += "<div id='lastMsg_" + chatroom.chatroomId + "'>";
        if(chatroom.content != null){
	        str += chatroom.nickname + " : " +  chatroom.content + "<br>";
        }
        str += dateConversion(chatroom); // 변환된 날짜와 시간을 추가
        
     	// receiveCount가 0보다 크고 null이 아닌 경우에만 출력
        if (chatroom.receiveCount > 0 && chatroom.receiveCount != null) {
            str += "<span id='receiveCount'>  안 읽은 메시지 : " + chatroom.receiveCount + "</span>";
        }
        
        // 안읽은 메시지 등 추가 정보도 여기에 표시
        str += "</div>" + "</li>" + "</ul>";
        chatroomList.innerHTML += str; // 생성한 HTML 코드를 컨테이너에 추가
    });
}
// ----------------------------------------------------------------------------------------------------

// 채팅창 띄우기
function openChatRoom(roomId) {
 	var leftPosition = (window.screen.width * 2 / 3) // / 2) - (512 / 2); 가운데 띄울때
	var topPosition = (window.screen.height * 2 / 5) // / 2) - (568 / 2);
	window.open('http://localhost:8080/chat/room?roomId=' + roomId, 'win0', 'width=512,height=568,left=' + leftPosition + ',top=' + topPosition + ',status=no,toolbar=no,scrollbars=no');
	updateChatroomList();
	
	// 페이지 이동으로 할때 사용
	//window.location.href = 'http://localhost:8080/chat/room?roomId=' + roomId;
}

// json 데이터 가져오기
var userList = JSON.parse('${userList}');

//모달 버튼 요소 가져오기
var modalBtn = document.getElementById("openModalBtn");

// 모달 창 요소 가져오기
var modal = document.getElementById("myModal");
var modal2 = document.getElementById("myModal2");
var modal3 = document.getElementById("myModal3");

// 닫기 버튼 요소 가져오기
var closeBtn = modal.querySelector(".close");
var yesBtn = modal2.querySelector("#yesBtn"); // 모달2
var noBtn = modal2.querySelector("#noBtn"); // 모달2
var closeBtn3 = modal3.querySelector(".close");

// 모달 버튼 클릭 시 모달 열기
modalBtn.onclick = function() {
	openModal(modal);
};

// 닫기 버튼 클릭 시 모달 닫기
closeBtn.onclick = function() {
  closeModal(modal);
  resetModalContent();
};
closeBtn3.onclick = function() {
  closeModal(modal3);
  resetModalContent();
  var roomNameInput = document.getElementById("roomName");
  roomNameInput.value = ''; 
};

// 방 생성 모달1 열기
function openModal(modal) {
  modal.style.display = "block";
}

// 방 생성 모달1 닫기 
function closeModal(modal) {
  modal.style.display = "none";
  resetModalContent(); // 모달 내용 초기화
}



// 모달 외부 영역 클릭 시 모달 닫기
window.onclick = function(event) {
  if (event.target == modal) {
    closeModal(modal);
  } else if (event.target == modal2) {
    closeModal(modal2);
  } else if (event.target == modal3) {
    closeModal(modal3);
    /* var roomNameInput = document.getElementById("roomName");
    roomNameInput.value = '';  */
  }
};

//input 초기화 함수
function clearInput() {
    var roomNameInput = document.getElementById("roomName");
    roomNameInput.value = ''; // input 빈값으로 초기화
}

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



//선택된 항목을 추가하는 함수
function addToSelectedItems(item) {
  selectedItems.push(item);
  renderSelectedItems();
  
  // 선택된 userId와 nickname 설정
  var selectedItem = userList.find(user => user.nickname === item);
  document.getElementById("selectedUserId").value = selectedItem.userId;
  document.getElementById("selectedNickname").value = selectedItem.nickname;
}

//검색 입력 상자 요소 가져오기
var searchInput = document.getElementById("searchInput");

//검색 입력 상자에 입력 이벤트 추가
searchInput.addEventListener("input", function() {
  var searchValue = this.value.toLowerCase(); // 검색어를 소문자로 변환
  var searchResults = document.getElementById("searchResults");
  searchResults.innerHTML = ''; // 결과 초기화

  
//검색 결과 생성
  for (var i = 0; i < userList.length; i++) {
    var item = userList[i].nickname.toLowerCase(); // 객체의 속성에 접근하여 소문자로 변환
    
      if (item.includes(searchValue)) {
      var listItem = document.createElement("li");
      
      // 체크박스 생성
      var checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.setAttribute("data-index", i); // 해당 항목의 인덱스를 저장하기 위한 속성 추가 
      checkbox.setAttribute("value", userList[i].userId); // 
      checkbox.setAttribute("nickname", userList[i].nickname); // 해당 항목의 텍스트를 저장하기 위한 속성 추가
      listItem.appendChild(checkbox);
      
      // 검색된 항목의 텍스트 표시
      var textNode = document.createTextNode(userList[i].nickname + " (" + userList[i].email + ")");
      listItem.appendChild(textNode);
      
      // 
      // 클릭 이벤트 핸들러 함수 내부에서 checkbox의 value와 nickname 값을 읽어와서 활용
	  listItem.addEventListener("click", function(event) {
	      var checkbox = this.querySelector("input[type='checkbox']");
	      var userId = checkbox.value;
	      var nickname = checkbox.getAttribute("nickname");
	
	      if (!checkbox.checked) {
	          // 선택 취소
	          var itemIndex = selectedItems.findIndex(item => item.userId === userId);
	          if (itemIndex !== -1) {
	              selectedItems.splice(itemIndex, 1);
	              renderSelectedItems();
	          }
	      } else {
	          // 선택 추가
	          selectedItems.push({ userId: userId, nickname: nickname });
	          renderSelectedItems();
	      }
	  });

        searchResults.appendChild(listItem);
      }
    }
  });
      

//선택된 항목을 저장할 배열
var selectedItemsContainer = document.getElementById("selectedItems");
var selectedItems = [];

// 선택된 항목을 제거하는 함수
function removeSelectedItem(item) {
  var itemIndex = selectedItems.indexOf(item);
  if (itemIndex !== -1) {
    selectedItems.splice(itemIndex, 1);
    renderSelectedItems(); // 선택된 항목을 다시 렌더링하여 변경 사항 적용
  }
}

//선택된 항목을 표시하는 함수
function renderSelectedItems() {
    var selectedItemsContainer = document.getElementById("selectedItems");
    selectedItemsContainer.innerHTML = ''; // 영역 초기화

    // 선택된 항목을 표시
    for (var i = 0; i < selectedItems.length; i++) {
        var selectedItemElement = document.createElement("div");
        selectedItemElement.textContent = selectedItems[i].nickname;
        selectedItemElement.className = "selected-item";

        // 삭제 버튼 아이콘 추가
        var deleteIcon = document.createElement("i");
        deleteIcon.className = "fas fa-times"; // Font Awesome의 X 아이콘 사용
        deleteIcon.style.cursor = "pointer";
        deleteIcon.onclick = function() {
            var userId = this.parentElement.dataset.userId;
            var itemIndex = selectedItems.findIndex(item => item.userId === userId);
            if (itemIndex !== -1) {
                selectedItems.splice(itemIndex, 1);
                renderSelectedItems(); // 선택된 항목을 다시 렌더링하여 삭제 적용
            }
        };
        selectedItemElement.appendChild(deleteIcon);
        selectedItemElement.dataset.userId = selectedItems[i].userId; // userId를 dataset에 추가

        selectedItemsContainer.appendChild(selectedItemElement);
    }
}

//"생성" 버튼 클릭 시
document.getElementById("createBtn").addEventListener("click", function() {
  var selectedItems = document.querySelectorAll("#selectedItems .selected-item");
  var selectedValues = [];

  selectedItems.forEach(function(item) {
	    selectedValues.push({
	      userId: item.getAttribute("data-user-id"),
	      nickname: item.textContent.trim()
	    });
	  });

  if (selectedValues.length === 0) {
    alert("선택된 항목이 없습니다.");
    return;
  }
  
  // 선택된 항목들을 배열로 묶어서 JSON 형식으로 변환
  var jsonData = JSON.stringify(selectedValues);

  // JSON 데이터를 서버로 전송
  $.ajax({
    type: "POST",
    url: "/chat/room",
    contentType: "application/json", // JSON 데이터 형식으로 전송
    data: jsonData,
    success: function(response) {
      // 성공 시 처리
      console.log("선택된 항목을 서버로 전송했습니다.");
      modal.style.display = "none"; // 모달 닫기
      resetModalContent();
      location.reload();
    },
    error: function(xhr, status, error) {
      // 에러 발생 시 처리
      console.error("서버로의 전송에 실패했습니다:", error);
    }
  }); //$
});


/////////////////////////////////////

//기본 컨텍스트 메뉴 막기
window.oncontextmenu = function() {
    return false;
};

// room 리스트 요소 가져오기
var roomList = document.querySelector(".list-group");

//오른쪽 클릭된 room의 ID와 이름을 저장할 변수
var clickedRoomId = null;
var clickedRoomName = null;

//문서에서 마우스 다운 이벤트를 감지하여 오른쪽 버튼 클릭을 확인
document.addEventListener('mousedown', function(event) {
    // 오른쪽 버튼이 클릭되었는지 확인
    if ((event.button == 2) || (event.which == 3)) {
        // 오른쪽 버튼 클릭된 요소가 li 요소인지 확인
        if (event.target.tagName === "A") {
            // 오른쪽 클릭된 room의 ID와 이름을 저장
            clickedRoomId = event.target.getAttribute("onclick").match(/\d+/)[0];
            clickedRoomName = event.target.textContent.trim();

            // 메뉴를 표시할 위치를 정의.  오른쪽 클릭된 위치를 기준으로 함
            var menuX = event.pageX;
            var menuY = event.pageY;

            // 기존에 메뉴가 있다면 제거
            var existingMenu = document.querySelector(".context-menu");
            if (existingMenu) {
                existingMenu.remove();
            }

            // 원하는 메뉴를 생성하고 위치를 설정
            var menu = document.createElement("div");
            menu.classList.add("context-menu");
            menu.style.position = "fixed";
            menu.style.left = menuX + "px";
            menu.style.top = menuY + "px";
            menu.style.backgroundColor = "white";
            menu.style.border = "1px solid black";

            // 메뉴에 내용 추가
            menu.innerHTML = `
                <ul>
                    <li onclick="handleMenuAction('edit')">제목 수정</li>
                    <li onclick="handleMenuAction('delete')">방 나가기</li>
                </ul>
            `;

            // body에 메뉴 추가
            document.body.appendChild(menu);
        }
    }
});

//문서에서 터치 시작 이벤트를 감지하여 터치 타이머 시작
document.addEventListener('touchstart', function(event) {
    // 터치 타이머 시작
    touchTimer = setTimeout(function() {
        // 터치가 일정 시간 동안 유지되었을 때 메뉴를 열도록 처리
        openMenu();
    }, 1000); // 1초 후에 메뉴를 엽니다.
});

// 문서에서 터치 종료 이벤트를 감지하여 터치 타이머 초기화
document.addEventListener('touchend', function(event) {
    clearTimeout(touchTimer); // 터치 타이머 초기화
});
document.addEventListener('contextmenu', function(event) {
    // 오른쪽 클릭된 요소가 <a> 태그인지 확인
    if (event.target.tagName === "A") {
        // 클릭된 room의 ID와 이름을 저장
        clickedRoomId = event.target.getAttribute("onclick").match(/\d+/)[0];
        clickedRoomName = event.target.textContent.trim();

        // 메뉴를 표시할 위치를 정의.  오른쪽 클릭된 위치를 기준으로 함
        var menuX = event.pageX;
        var menuY = event.pageY;

        // 기존에 메뉴가 있다면 제거
        var existingMenu = document.querySelector(".context-menu");
        if (existingMenu) {
            existingMenu.remove();
        }

        // 원하는 메뉴를 생성하고 위치를 설정
        var menu = document.createElement("div");
        menu.classList.add("context-menu");
        menu.style.position = "fixed";
        menu.style.left = menuX + "px";
        menu.style.top = menuY + "px";
        menu.style.backgroundColor = "white";
        menu.style.border = "1px solid black";

        // 메뉴에 내용 추가
        menu.innerHTML = `
            <ul>
                <li onclick="handleMenuAction('edit')">제목 수정</li>
                <li onclick="handleMenuAction('delete')">방 나가기</li>
            </ul>
        `;

        // body에 메뉴 추가
        document.body.appendChild(menu);

        // contextmenu 이벤트의 기본 동작을 막음
        event.preventDefault();
    }
});

function openMenu() {
    console.log('Menu opened');
    

}

// 메뉴 항목 처리 함수
function handleMenuAction(action) {
    // 각 메뉴 항목에 대한 동작
    if (action === 'edit') {
        // 제목수정 
        console.log('Edit room');
    } else if (action === 'delete') {
        // 방나가기
        console.log('Leave room');
    }
}

// 메뉴 항목 처리 함수
function handleMenuAction(action) {
    // 각 메뉴 항목에 대한 동작을 처리합니다.
    if (action === 'edit') {
        console.log('Edit room');
        // 여기에 제목 수정에 대한 동작을 추가합니다.
    } else if (action === 'delete') {
        console.log('Leave room');
        // 여기에 방 나가기에 대한 동작을 추가합니다.
    }
}

// 문서 전체에 클릭 이벤트 리스너 추가하여 메뉴 숨김
document.addEventListener("click", function(event) {
    var menu = document.querySelector(".context-menu");
    if (menu && !menu.contains(event.target)) {
        menu.remove();
    }
});

function handleMenuAction(action, roomName) {
    switch (action) {
        case "delete":
            openModal(modal2); // 삭제 항목 선택시 모달2 오픈
            break;
        case "edit":
            openModal(modal3); // 수정 항목 선택시 모달3 오픈
        	// 모달3에 클릭된 링크의 텍스트 설정
            var roomNameInput = document.getElementById("roomName");
            roomNameInput.value = clickedRoomName;
            break;
        default:
            break;
    }
 // 메뉴 숨기기
    var menu = document.querySelector(".context-menu");
    if (menu) {
        menu.remove();
    }
}


// 방 나갈때 시스템메시지 보내기
function leaveMessage() {
	var sockJs = new SockJS("/stomp/chat");
	// SockJS를 STOMP로 전달
	var stomp = Stomp.over(sockJs);
    // 연결
    stomp.connect({}, function () {
    	
    var msg = sessionNickname + '님이 나갔습니다.';
    var messageType = 'SYSTEM';
    stomp.send('/pub/chat/message', {}, 
    		JSON.stringify({chatroomId: clickedRoomId, content: msg, senderId: sessionId, messageType: messageType}));
    });
}

//모달2의 예 버튼 클릭 시 AJAX 요청 보내기
var modal2YesBtn = modal2.querySelector("#yesBtn");
if (modal2YesBtn) {
  modal2YesBtn.onclick = function() {
    closeModal(modal2);
    
 	// 클릭된 방의 ID 가져오기
    var chatRoomId = clickedRoomId;

    // roomId 값이 존재하는지 확인
    if (chatRoomId) {

   	// 요청 데이터 생성
       var requestData = {
         chatroomId: chatRoomId,
         userId: sessionId // 세션 아이디
       };
      // 방 나가기 요청 보내기
      $.ajax({
        type: "POST",
        url: "/chat/leave",
        contentType: "application/json",
        data: JSON.stringify(requestData),
        success: function(response) {
          console.log("방 나가기 요청 성공");
          // 누가 방 나갔는지 시스템메시지 보내기
          leaveMessage();
          // 새로고침
          location.reload();
        },
        error: function(xhr, status, error) {
          // 요청이 실패한 경우 처리
          console.error("방 나가기 요청 실패:", error);
        }
      });
    } else {
      console.error("roomId 값이 존재하지 않습니다.");
    }
  };
}
// 아니오 버튼 클릭 시 모달 닫기
if (noBtn) {
  noBtn.onclick = function() {
    closeModal(modal2);
  };
}

//모달3의 확인 버튼 클릭 시 AJAX 요청 보내기
var modal3SaveBtn = modal3.querySelector("#saveBtn");
if (modal3SaveBtn) {
  modal3SaveBtn.onclick = function() {
    
	var roomNameInput = document.getElementById("roomName");
    var roomName = roomNameInput.value.trim(); // 입력된 값

    // 입력된 값이 비어 있는지 확인
    if (!roomName) {
      alert("수정할 제목을 입력하세요.");
      return;
    }

    // 클릭된 방의 ID 가져오기
    var chatRoomId = clickedRoomId;
	console.log(chatRoomId);
    // 요청 데이터 생성
    var requestData = {
      chatroomId: chatRoomId,
      chatroomName: roomName,
      userId: sessionId // 세션 아이디
    };

    // AJAX 요청 보내기
    $.ajax({
      type: "POST",
      url: "/chat/roomName",
      contentType: "application/json",
      data: JSON.stringify(requestData),
      success: function(response) {
        // 요청이 성공한 경우 처리
        console.log("제목 수정 요청이 성공했습니다.");
        // 새로고침
        location.reload();
      },
      error: function(xhr, status, error) {
        // 요청이 실패한 경우 처리
        console.error("제목 수정 요청이 실패했습니다:", error);
      }
    });

    // 모달 닫기
    closeModal(modal3);
    
 	// input 초기화
    roomNameInput.value = ''; 
  };
}

</script>

</body>
</html> 