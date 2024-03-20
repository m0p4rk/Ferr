package com.warr.ferr.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.warr.ferr.dto.ChatroomDto;
import com.warr.ferr.dto.UserDto;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Messages;
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

    // 채팅방 목록 조회
    @GetMapping(value = "/rooms")
    public String getChatRooms(Model model, HttpSession session){
    	log.info("RoomController : getChatRooms()");
    	int userId = 0;
    	
		userId = (int) session.getAttribute("userId");
		model.addAttribute("userId", userId);
		model.addAttribute("rooms", chatService.findAllRoomsByUserId(userId));
        
        // user list
        List<Users> userList = userService.findAllUser(session.getAttribute("userId"));
		JSONArray jsonArray = new JSONArray();
		model.addAttribute("userList", jsonArray.fromObject(userList));
	
        return "chat/rooms";
    }

//    // 채팅방개설시 중복검사
    @PostMapping("/duple")
    public String duplicationCheck(@RequestBody List<UserDto> userList, Model model, HttpSession session) {
    	Users user = userService.findUserById((Integer) session.getAttribute("userId"));
    	
    	return "redirect:/chat/rooms";
    }
    
    // 채팅방 개설
    @PostMapping("/room")
    public String createChatRoom(@RequestBody List<UserDto> userList, Model model, HttpSession session) {
        log.info("RoomController : createChatRoom()");
        Users user = userService.findUserById((Integer) session.getAttribute("userId"));
        model.addAttribute("roomName", chatService.createChatRoom(userList, user));
       
        return "redirect:/chat/rooms";
    }

    // 채팅방 조회-상세보기
    @GetMapping("/room")
    public void getChatRoom(int roomId, Model model, HttpSession session){
        log.info("RoomController : getChatRoom(), chatroomId : " + roomId);
        // 입장하는 채팅방 정보
        int userId = (Integer) session.getAttribute("userId");
        ChatroomMembers chatroomId = chatService.findRoomById(roomId, userId);
        model.addAttribute("room", chatroomId);
        
        // 채팅방 소속된 유저리스트 
//        List<Users> userList = userService.findUserByRoomId(chatroomId.getChatroomId());
//        model.addAttribute("userList", userList);

        // 이전 채팅 이력
        List<Messages> preMsgList = messagesService.preMsg(chatroomId);
        model.addAttribute("preMsg", preMsgList);

        
    }
    
    // 채팅방 제목 수정
    @PostMapping("/roomName")
    public String roomNameUpdate(@RequestBody ChatroomDto chatroomDto){
    	boolean result = chatService.roomNameUpdate(chatroomDto);
    	return "redirect:/chat/rooms";
    }
    
    // 방 나가기
    @PostMapping("/leave")
    public String chatroomLeave(@RequestBody ChatroomDto chatroomDto){
        log.info("RoomController : deleteRoom(), roomId : " + chatroomDto);
        System.out.println("chatroomDto : " + chatroomDto.getChatroomId());
        System.out.println("chatroomDto : " + chatroomDto.getUserId());
        boolean result = chatService.chatroomLeave(chatroomDto);

        return "redirect:/chat/rooms";
    }
    
    // 채팅방 삭제 - 모든유저가 leave 상태인 채팅룸 id 기준으로 삭제
//    @PostMapping("/deleteRoom")
//    public String deleteRoom(){
//        int res = chatService.deleteRoom();
//        System.out.println(res);
//        return "redirect:/chat/rooms";
//    }
    
    
    
    
    
}
