<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<title>Modal with Autocomplete</title>
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
<% 
	session.setAttribute("userId", "유저네임 1");
	%>
<div class="container">
    <div>
    	<c:forEach items="${rooms}" var="room">
	        <ul class="list-group">
	            <li class="list-group-item"><a href="/chat/room?roomId=${room.chatroomId}">${room.name}</a></li>
	        </ul>
    	</c:forEach>
    </div>
</div>

<!-- 모달 버튼 -->
<button id="openModalBtn">채팅룸 생성</button>

<!-- 유저목록조회 + 방 생성 -->
<div id="myModal" class="modal">
	<div class="modal-content">
	    <span class="close">&times;</span> <!-- 닫기 버튼 -->
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
	    <span class="close">&times;</span>
	    <input type="text" id="roomName" placeholder="수정할 제목 입력"> <!-- 검색 입력 상자 -->
	    <!-- X 아이콘 모양의 텍스트 초기화 버튼 -->
	    <button id="clearInputBtn" class="clear-input-btn" onclick="clearInput()">초기화</button>
	    <button id="saveBtn">확인</button>
	</div>
</div>

<script>
<%
String userId = (String)session.getAttribute("userId");
%>
var userId = '<%= userId %>';
// json 데이터 가져오기
var json = JSON.parse('${json}');
//모달 버튼 요소 가져오기
var modalBtn = document.getElementById("openModalBtn");

// 모달 창 요소 가져오기
var modal = document.getElementById("myModal");
var modal2 = document.getElementById("myModal2");
var modal3 = document.getElementById("myModal3");

// 닫기 버튼 요소 가져오기
var closeBtn = document.querySelector(".close");
var yesBtn = modal2.querySelector("#yesBtn"); // 모달2
var noBtn = modal2.querySelector("#noBtn"); // 모달2
var closeBtn3 = modal3.querySelector(".close");

//모달 열기 함수
function openModal(modal) {
  modal.style.display = "block";
}

// 모달 닫기 함수
function closeModal(modal) {
  modal.style.display = "none";
  resetModalContent(); // 모달 내용 초기화
}

// 선택된 항목 초기화 함수
function clearSelectedItems() {
  // 선택된 항목 초기화 로직 추가
}

// 체크박스 초기화 함수
function clearCheckboxes() {
  // 체크박스 초기화 로직 추가
}

// 모달 버튼 클릭 시 모달 열기
modalBtn.onclick = function() {
	openModal(modal);
};

// 닫기 버튼 클릭 시 모달 닫기
closeBtn.onclick = function() {
  closeModal(modal);
  clearSelectedItems();
  clearCheckboxes();
};
closeBtn3.onclick = function() {
  closeModal(modal3);
  var roomNameInput = document.getElementById("roomName");
  roomNameInput.value = ''; 
};

// 모달 외부 영역 클릭 시 모달 닫기
window.onclick = function(event) {
  if (event.target == modal) {
    closeModal(modal);
    clearSelectedItems();
    clearCheckboxes();
  } else if (event.target == modal2) {
    closeModal(modal2);
  } else if (event.target == modal3) {
    closeModal(modal3);
    var roomNameInput = document.getElementById("roomName");
    roomNameInput.value = ''; 
  }
};

//input 초기화 함수
function clearInput() {
    var roomNameInput = document.getElementById("roomName");
    roomNameInput.value = ''; // input 값을 비웁니다.
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

  // 체크된 상태 초기화
  var checkboxes = document.querySelectorAll('#searchResults input[type="checkbox"]');
  checkboxes.forEach(function(checkbox) {
    checkbox.checked = false;
  });
}

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
            clickedRoomId = event.target.getAttribute("href").split("=")[1];
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
            openModal(modal2); // 삭제 항목을 선택했을 때 모달2를 엽니다.
            break;
        case "edit":
            openModal(modal3); // 수정 항목을 선택했을 때 모달3를 엽니다.
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
         userId: userId // 세션 아이디
       };
      // 방 나가기 요청 보내기
      $.ajax({
        type: "POST",
        url: "/chat/deleteRoom",
        contentType: "application/json",
        data: JSON.stringify(requestData),
        success: function(response) {
          // 요청이 성공한 경우 처리
          console.log("방 나가기 요청이 성공했습니다.");
          // 성공한 경우에 필요한 추가 작업 수행
        },
        error: function(xhr, status, error) {
          // 요청이 실패한 경우 처리
          console.error("방 나가기 요청이 실패했습니다:", error);
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

    // 요청 데이터 생성
    var requestData = {
      chatroomId: chatRoomId,
      roomName: roomName,
      userId: userId // 세션 아이디
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
        // 성공한 경우에 필요한 추가 작업 수행
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

// 검색 입력 상자 요소 가져오기
var searchInput = document.getElementById("searchInput");

//검색 입력 상자에 입력 이벤트 추가
searchInput.addEventListener("input", function() {
  var searchValue = this.value.toLowerCase(); // 검색어를 소문자로 변환
  var searchResults = document.getElementById("searchResults");
  searchResults.innerHTML = ''; // 결과 초기화

//검색 결과 생성 > 카카오id 수정해야함
  for (var i = 0; i < json.length; i++) {
    var item = json[i].kakaoId.toLowerCase(); // 객체의 속성에 접근하여 소문자로 변환
    if (item.includes(searchValue)) {
      var listItem = document.createElement("li");
      
      // 체크박스 생성
      var checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.setAttribute("data-index", i); // 해당 항목의 인덱스를 저장하기 위한 속성 추가
      checkbox.setAttribute("data-text", json[i].kakaoId); // 해당 항목의 텍스트를 저장하기 위한 속성 추가
      listItem.appendChild(checkbox);
      
      // 검색된 항목의 텍스트 표시
      var textNode = document.createTextNode(json[i].kakaoId);
      listItem.appendChild(textNode);
      
      // 이전에 선택된 상태 유지
      if (json[i].isChecked) {
        checkbox.checked = true;
      }
      
      listItem.addEventListener("click", function(event) {
        var index = parseInt(this.firstChild.getAttribute("data-index"));
        var checkbox = this.querySelector("input[type='checkbox']");
        if (!json[index].isChecked) {
          // 체크박스 상태가 해제된 경우
          addToSelectedItems(json[index].kakaoId); // 선택된 항목으로 추가
          json[index].isChecked = true;
          checkbox.checked = true; // 체크박스 선택 상태로 변경
        } else {
          // 체크박스 상태가 선택된 경우
          var itemToRemove = json[index].kakaoId;
          var itemIndex = selectedItems.indexOf(itemToRemove);
          if (itemIndex !== -1) {
            selectedItems.splice(itemIndex, 1);
            renderSelectedItems();
          }
          json[index].isChecked = false;
          checkbox.checked = false; // 체크박스 해제 상태로 변경
        }
      });
      
      searchResults.appendChild(listItem);
    }
  }
});

// 선택된 항목을 제거하는 함수
function removeSelectedItem(item) {
  var itemIndex = selectedItems.indexOf(item);
  if (itemIndex !== -1) {
    selectedItems.splice(itemIndex, 1);
    renderSelectedItems(); // 선택된 항목을 다시 렌더링하여 변경 사항 적용
  }
}

// 선택된 항목을 저장할 배열
var selectedItemsContainer = document.getElementById("selectedItems");
var selectedItems = [];

// "생성" 버튼 클릭 시 항목없으면
document.getElementById("createBtn").addEventListener("click", function() {
  if (selectedItems.length === 0) {
    alert("선택된 항목이 없습니다.");
    return;
  }
  console.log(selectedItems);
});

// 선택된 항목을 추가하는 함수
function addToSelectedItems(item) {
  selectedItems.push(item);
  renderSelectedItems();
}

// 선택된 항목을 표시하는 함수
function renderSelectedItems() {
  var selectedItemsContainer = document.getElementById("selectedItems");
  selectedItemsContainer.innerHTML = ''; // 영역 초기화

  // 선택된 항목을 표시
  for (var i = 0; i < selectedItems.length; i++) {
    var selectedItemElement = document.createElement("div");
    selectedItemElement.textContent = selectedItems[i];
    selectedItemElement.className = "selected-item";
    
    // 삭제 버튼 아이콘 추가
    var deleteIcon = document.createElement("i");
    deleteIcon.className = "fas fa-times"; // Font Awesome의 X 아이콘 사용
    deleteIcon.style.cursor = "pointer";
    deleteIcon.onclick = function() {
      var itemIndex = selectedItems.indexOf(this.parentElement.textContent);
      selectedItems.splice(itemIndex, 1);
      renderSelectedItems(); // 선택된 항목을 다시 렌더링하여 삭제 적용
    };
    selectedItemElement.appendChild(deleteIcon);

    selectedItemsContainer.appendChild(selectedItemElement);
  }
}


//"생성" 버튼 클릭 시
document.getElementById("createBtn").addEventListener("click", function() {
  var selectedItems = document.querySelectorAll("#selectedItems .selected-item");
  var selectedValues = [];

  selectedItems.forEach(function(item) {
    selectedValues.push(item.textContent.trim()); // 공백 제거 후 배열에 추가
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
      clearCheckboxes(); // 체크박스 초기화
      clearSelectedItems(); // 선택된 항목 초기화
      
    },
    error: function(xhr, status, error) {
      // 에러 발생 시 처리
      console.error("서버로의 전송에 실패했습니다:", error);
    }
  }); //$
});

// 삭제해도 무방
console.log("카카오 ID: " + json[0].kakaoId);
console.log(userId);

</script>

</body>
</html>