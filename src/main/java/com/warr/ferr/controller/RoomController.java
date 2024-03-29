package com.warr.ferr.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.HashMap;
import java.util.Iterator;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.warr.ferr.dto.ChatroomDto;
import com.warr.ferr.dto.MessageDto;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Users;
import com.warr.ferr.service.ChatService;
import com.warr.ferr.service.MessagesService;
import com.warr.ferr.service.UserService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;

@Slf4j
@RequestMapping(value = "/chat")
@RequiredArgsConstructor
@Controller
public class RoomController {

	private final ChatService chatService;
	private final UserService userService;
	private final MessagesService messagesService;

    // 채팅방 목록 조회 >> userList, chatroomList, messages sentAt
    @GetMapping(value = "/rooms")
    public String getChatRooms(Model model, HttpSession session){
    	log.info("RoomController : getChatRooms()");
    	int userId = 0;
    	
		userId = (int) session.getAttribute("userId");
		List<ChatroomDto> chatroomList = chatService.findAllRoomsByUserId(userId); // 유저가 참여중인 채팅룸 list
		model.addAttribute("userId", userId);
		model.addAttribute("rooms", chatroomList); 
        
        // user list
        List<Users> userList = userService.searchUser(userId);
		//JSONArray jsonArray = new JSONArray();
		model.addAttribute("userList", JSONArray.fromObject(userList));
	
        return "chat/rooms";
    }

//    // 채팅방개설시 중복검사
//    @PostMapping("/duple")
//    public String duplicationCheck(@RequestBody List<Users> userList, Model model, HttpSession session) {
//    	Users user = userService.findUserById((Integer) session.getAttribute("userId"));
//    	
//    	return "redirect:/chat/rooms";
//    }
    
    // 채팅방 개설
    @PostMapping("/room")
    public String createChatRoom(@RequestBody List<Integer> idList, Model model, HttpSession session) {
        log.info("RoomController : createChatRoom()");
        
        List<Users> userList = new ArrayList<>();
        for (int i = 0; i < idList.size(); i++) {
        	userList.add(userService.findUserById(idList.get(i)));
		}
        Users user = userService.findUserById((Integer) session.getAttribute("userId"));
        model.addAttribute("roomName", chatService.createChatRoom(userList, user));
       
        return "redirect:/chat/rooms";
    }
    
    // 채팅방 멤버 추가
    @PostMapping("/addMember")
    @ResponseBody
    public void addChatMember(@RequestBody Map<String, Object> requestData, HttpSession session) {
    	ArrayList<?> idList  = null;
    	List<Integer> userList = new ArrayList<>();
    	int chatroomId = 0;
    	
    	  for (Entry<String, Object> entrySet : requestData.entrySet()) {        
    		  	System.out.println(entrySet.getKey() + " : " + entrySet.getValue() + " type : " +  entrySet.getValue().getClass());     
    		  	if(entrySet.getKey() == "chatroomId") {
    		  		chatroomId = Integer.parseInt(entrySet.getValue().toString()); // chatroomId
    		  	} else if(entrySet.getKey()  == "userId") {
    		  		idList = (ArrayList<?>) entrySet.getValue();
    		  	}
    	  }
    	  // List<Integer> 변환해서 값 넘겨줌
    	  for (int i = 0; i < idList.size(); i++) {
			System.out.println("userId : "+ Integer.parseInt((String) idList.get(i)));
			userList.add(Integer.parseInt((String) idList.get(i)));
		}
    	  
        chatService.addChatMember(userList, chatroomId);
        
    }

    // 채팅방 조회-상세보기
    @GetMapping("/room")
    public void getChatRoom(int roomId, Model model, HttpSession session){
        log.info("RoomController : getChatRoom(), chatroomId : " + roomId);
        // 입장하는 채팅방 정보
        int userId = (Integer) session.getAttribute("userId");
        ChatroomMembers chatroomId = chatService.findRoomById(roomId, userId);
        model.addAttribute("room", chatroomId);
        
        // 채팅방 소속된 유저리스트 채팅방으로 넘겨줄데이터
        List<Users> roomUserList = chatService.findUserByRoomId(chatroomId.getChatroomId());
        //JSONArray jsonArray = new JSONArray();
        model.addAttribute("roomUserList", JSONArray.fromObject(roomUserList));
        
        // 떠난 유저 정보 >> 이거말고 users가 필요할것같다
        List<ChatroomMembers> leaveUser = chatService.findLeaveMember(roomId);
        model.addAttribute("leaveUser", JSONArray.fromObject(leaveUser));
        
        // user list 검색할때 사용
        List<Users> userList = userService.searchUser(userId);
		model.addAttribute("userList", JSONArray.fromObject(userList));
    }
    
    // room에서 최신화할때 사용함
    @GetMapping("/ajaxInfo")
    @ResponseBody
    public List<MessageDto> ajaxInfo(int roomId, Model model, HttpSession session){
        int userId = (Integer) session.getAttribute("userId");
        ChatroomMembers chatroomId = chatService.findRoomById(roomId, userId); // roomId랑 userId로 채팅방 찾기
        model.addAttribute("room", chatroomId);
        
        // 채팅방 소속된 유저리스트 채팅방으로 넘겨줄데이터
        List<Users> userList = chatService.findUserByRoomId(chatroomId.getChatroomId());
        //JSONArray jsonArray = new JSONArray();
        model.addAttribute("roomUserList", JSONArray.fromObject(userList));

        // 이전 채팅 이력
        List<MessageDto> preMsgList = messagesService.preMsg(chatroomId, userList);
        model.addAttribute("preMsg", JSONArray.fromObject(preMsgList));
        System.out.println(preMsgList.get(0));
        // 마지막 읽은 시간 갱신
        chatService.lastReadAtUpdate(roomId, (Integer) session.getAttribute("userId"));
        
        return preMsgList;
    }
    
    // 채팅방 마지막사용시간 최신화
    @GetMapping("/lastRead")
    public void lastReadAtUpdate (int roomId, HttpSession session){
    	chatService.lastReadAtUpdate(roomId, (Integer) session.getAttribute("userId"));
    }
    
    
    // 채팅방 목록 최신화
    @GetMapping("/listUpdate")
    @ResponseBody
    public List<ChatroomDto> chatroomUpdate(HttpSession session){
    	List<ChatroomDto> chatroomList = chatService.findAllRoomsByUserId((Integer)session.getAttribute("userId"));
    	
    	return chatroomList;
    }
    
    // 채팅방 제목 수정
    @PostMapping("/roomName")
    public String roomNameUpdate(@RequestBody ChatroomMembers chatroomMembers){
    	chatService.roomNameUpdate(chatroomMembers);
    	return "redirect:/chat/rooms";
    }
    
    // 방 나가기
    @PostMapping("/leave")
    public String chatroomLeave(@RequestBody ChatroomMembers chatroom){
        log.info("RoomController : deleteRoom(), roomId : " + chatroom);
        chatService.chatroomLeave(chatroom);

        return "redirect:/chat/rooms";
    }
    
    // 채팅방 구분없이 안읽은 메시지 갯수 가져오기
    @GetMapping("/alarm")
    @ResponseBody
    public int MsgAlarm(HttpSession session){
    	int alarm = messagesService.msgAlarm((Integer)session.getAttribute("userId"));
    	System.out.println("alarm :  " + alarm);
    	return alarm;
    }
    
    // room 에서 유저 검색
    @PostMapping("/search")
    @ResponseBody
    public List<Users> searchUser(HttpSession session) {
    	List<Users> searchList = userService.searchUser((Integer)session.getAttribute("userId"));
    	return searchList;
    }
    
    
    // 채팅방 삭제 - 모든유저가 leave 상태인 채팅룸 id 기준으로 삭제
//    @PostMapping("/deleteRoom")
//    public String deleteRoom(){
//        int res = chatService.deleteRoom();
//        System.out.println(res);
//        return "redirect:/chat/rooms";
//    }
    
    
    
    
    
}
