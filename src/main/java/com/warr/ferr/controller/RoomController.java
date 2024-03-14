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
    public String getChatRooms(Model model){

        log.info("RoomController : getChatRooms()");
        model.addAttribute("rooms", chatService.findAllRooms());
        
        List<Users> userList = userService.findAllUser();
        
		JSONArray jsonArray = new JSONArray();
		model.addAttribute("json", jsonArray.fromObject(userList));
	
        return "chat/rooms";
    }

    // 채팅방 개설
    @PostMapping("/room")
    public String createChatRoom(@RequestBody List<String> name, Model model) {
        log.info("RoomController : createChatRoom()");
        model.addAttribute("roomName", chatService.createChatRoom(name));
       
        return "redirect:/chat/rooms";
    }

    // 채팅방 조회-상세보기
    @GetMapping("/room")
    public void getChatRoom(String roomId, Model model){
        log.info("RoomController : getChatRoom(), chatroomId : " + roomId);
        model.addAttribute("room", chatService.findRoomById(roomId));
    }
    
    // 채팅방 제목 수정
    @PostMapping("/roomName")
    public String roomNameUpdate(@RequestBody ChatroomDto chatroom){
    	boolean result = chatService.roomNameUpdate(chatroom);
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
