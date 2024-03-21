package com.warr.ferr.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.warr.ferr.mapper.MessagesMapper;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Messages;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MessagesService {
	
	private final MessagesMapper messagesMapper;

	// 메시지 보내기
	public Messages sendMessage(Messages messages) {
		int res = 0;
		res = messagesMapper.sendMessage(messages);
		
		if(res != 0) {
			messages = messagesMapper.findMessage();
		} else {
			messages.builder().content("메세지 전송 실패").build();
		}
		
		return messages; 
	}

	// 이전 채팅 이력
	public List<Messages> preMsg(ChatroomMembers chatroom) {
		List<Messages> preMsgList = messagesMapper.preMsg(chatroom.getChatroomId());
		
//		for (int i = 0; i < preMsgList.size(); i++) {
//			preMsgList.get(i)chatroom.builder().
//		}
		
		return preMsgList;
	}
	
}
