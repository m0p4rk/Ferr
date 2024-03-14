package com.warr.ferr.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.warr.ferr.model.Messages;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor //생성자를 자동으로 생성해줌
public class ChatController {

    private final SimpMessagingTemplate template; //특정 Broker로 메세지를 전달
    
    // /pub/chat/enter
    @MessageMapping(value = "/chat/enter")
    public void enterChatRoom(Messages content){
    	
    	log.info("StompChatController : enterChatRoom()");
    	content.setContent(content.getSenderId() + "님이 채팅방에 참여하였습니다.");
        template.convertAndSend("/sub/chat/room/" + content.getChatroomId(), content);
    }

    @MessageMapping(value = "/chat/message")
    public void messageChatRoom(Messages content){
    	log.info("StompChatController : messageChatRoom()");
        template.convertAndSend("/sub/chat/room/" + content.getChatroomId(), content);
        
    }
}
