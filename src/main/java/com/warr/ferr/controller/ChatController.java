package com.warr.ferr.controller;

import java.util.List;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import com.warr.ferr.model.Messages;
import com.warr.ferr.model.Users;
import com.warr.ferr.service.MessagesService;
import com.warr.ferr.service.UserService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor //생성자를 자동으로 생성해줌
public class ChatController {

    private final SimpMessagingTemplate template; //특정 Broker로 메세지를 전달
    private final MessagesService messagesService;
    private final UserService userService;
    
    // /pub/chat/enter
    @MessageMapping(value = "/chat/enter")
    public void enterChatRoom(Messages messages){
    	log.info("StompChatController : enterChatRoom()");
    	
    	// chatroomId, senderId, messageId, content, messageType, sentAt
    	Users user = userService.findUserById(messages.getSenderId());
    	messages.setContent(user.getNickname() + "님이 채팅방에 참여하였습니다.");
    	Messages msg = messagesService.sendMessage(messages);
		template.convertAndSend("/sub/chat/room/" + messages.getChatroomId(), msg);
    }

    @MessageMapping(value = "/chat/message")
    public void messageChatRoom(Messages messages){
    	log.info("StompChatController : messageChatRoom()");
        
    	Users user = userService.findUserById(messages.getSenderId()); // 테스트용
    	Messages msg = messagesService.sendMessage(messages);
		template.convertAndSend("/sub/chat/room/" + messages.getChatroomId(), msg);
    }
    
//    @PostMapping(value = "/chat/preChat")
//    public List<Messages> preChat(ChatroomMembers member) {
//    	System.out.println(member);
//    	System.out.println(member.getUserId());
//    	System.out.println(member.getChatroomId());
//    	
//    	return null;
//    }
 // 이전 채팅 이력
//    List<Messages> preMsgList = messagesService.preMsg(chatroom);
//	for(Messages msg : preMsgList) {
//    	template.convertAndSend("/sub/chat/room/" + roomId, msg);
//    }
    
}
