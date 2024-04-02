package com.warr.ferr.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.warr.ferr.dto.MessageDto;
import com.warr.ferr.model.Messages;
import com.warr.ferr.model.Users;
import com.warr.ferr.service.ChatService;
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
    private final ChatService chatService;
    
    // /pub/chat/enter
    // 채팅방 입장시 이쪽으로 요청들어옴
    @MessageMapping(value = "/chat/enter")
    public void enterChatRoom(Messages messages){
    	log.info("StompChatController : enterChatRoom()");
//    	 chatroomId, senderId, messageId, content, messageType, sentAt
    	Users user = userService.findUserById(messages.getSenderId());
//    	messages.setContent(user.getNickname() + "님이 채팅방에 참여하였습니다.");
//    	MessageDto msg = messagesService.sendMessage(messages, user.getNickname());
//    	ChatroomMembers chatroomId = chatService.findRoomById(messages.getChatroomId(), messages.getSenderId());
		// 필요한 곳에 뿌려줌
		template.convertAndSend("/sub/chat/room/" + messages.getChatroomId(), user);
		template.convertAndSend("/sub/chat/rooms/" + messages.getChatroomId(), user);
		template.convertAndSend("/sub/chat/navbar/" + messages.getChatroomId(), user);
    }

    @MessageMapping(value = "/chat/message")
    public void messageChatRoom(Messages messages){
    	log.info("StompChatController : messageChatRoom()");
    	boolean result = false;
    	Users user = userService.findUserById(messages.getSenderId());
    	
    	// 최신화 먼저 하고 이후에 메세지 보내는 방식
    	// 안그러면 순서가 뒤죽박죽이라 원하는 결과값이 안나옴
    	result = chatService.lastReadAtUpdate(messages.getChatroomId(), messages.getSenderId()); // 채팅방 마지막사용시간 갱신
    	if(result) {
    		MessageDto msg = messagesService.sendMessage(messages, user.getNickname()); // db에 메세지 저장, 다시 저장한 값 반환받음
    		template.convertAndSend("/sub/chat/room/" + messages.getChatroomId(), msg); // room으로 발송
    		template.convertAndSend("/sub/chat/rooms/" + messages.getChatroomId(), msg); // rooms로 발송
    		template.convertAndSend("/sub/chat/navbar/" + messages.getChatroomId(), msg); // navbar로 발송
    	}
    }
}
