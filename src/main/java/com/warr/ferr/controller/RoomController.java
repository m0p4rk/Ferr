package com.warr.ferr.controller;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.warr.ferr.dto.ChatroomDto;
import com.warr.ferr.dto.UserDto;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Users;
import com.warr.ferr.service.ChatService;
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

    // 채팅방 목록 조회
    @GetMapping(value = "/rooms")
    public String getChatRooms(Model model, HttpSession session){
    	log.info("RoomController : getChatRooms()");
    	int userId = 0;
    	
		userId = (int) session.getAttribute("userId");
		model.addAttribute("userId", userId);
		model.addAttribute("rooms", chatService.findAllRoomsByUserId(userId));
		System.out.println(model.getAttribute("rooms"));
        
        // user list
        List<Users> userList = userService.findAllUser(session.getAttribute("userId"));
		JSONArray jsonArray = new JSONArray();
		model.addAttribute("userList", jsonArray.fromObject(userList));
	
        return "chat/rooms";
    }

    // 채팅방 개설
    @PostMapping("/room")
    public String createChatRoom(@RequestBody List<UserDto> userList, Model model, HttpSession session) {
        log.info("RoomController : createChatRoom()");
        model.addAttribute("roomName", chatService.createChatRoom(userList, session));
       
        return "redirect:/chat/rooms";
    }

    // 채팅방 조회-상세보기
    @GetMapping("/room")
    public void getChatRoom(int roomId, Model model, HttpSession session){
        log.info("RoomController : getChatRoom(), chatroomId : " + roomId);
        model.addAttribute("room", chatService.findRoomById(roomId, (Integer) session.getAttribute("userId")));
        System.out.println("asdsads" + chatService.findRoomById(roomId, (Integer) session.getAttribute("userId")));
    }
    
    // 채팅방 제목 수정
    @PostMapping("/roomName")
    public String roomNameUpdate(@RequestBody ChatroomDto chatroom, HttpSession session){
    	boolean result = chatService.roomNameUpdate(chatroom, session);
    	System.out.println(result);
    	return "redirect:/chat/rooms";
    }
    
    
    // 채팅방 삭제
    @PostMapping("/deleteRoom")
    public String deleteRoom(@RequestBody ChatroomDto chatroom, HttpSession sessionID){
        log.info("RoomController : deleteRoom(), roomId : " + chatroom);
        System.out.println("세션 ID : " + sessionID.getAttribute("userId"));
        System.out.println("chatroom : " + chatroom);
        boolean result = chatService.deleteRoom(chatroom.getChatroomId());
        System.out.println(result);
        return "redirect:/chat/rooms";
    }
    
}
