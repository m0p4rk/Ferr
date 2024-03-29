package com.warr.ferr.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.warr.ferr.dto.MessageDto;
import com.warr.ferr.mapper.ChatMapper;
import com.warr.ferr.mapper.MessagesMapper;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Messages;
import com.warr.ferr.model.Messages.MessageType;
import com.warr.ferr.model.Users;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MessagesService {
	
	private final MessagesMapper messagesMapper;
	private final ChatMapper chatMapper;

	// 메시지 보내기
	public MessageDto sendMessage(Messages messages, String nickname) {
		int res = 0;
		res = messagesMapper.sendMessage(messages); // 메세지 db에 저장
		MessageDto dtoMsg = new MessageDto();
		if(res != 0) {
			if(messages.getMessageType() == MessageType.MESSAGE) {
				messages = messagesMapper.findMessage(); // 저장한 메세지 다시 가져옴
				
				dtoMsg = MessageDto.builder()
										.chatroomId(messages.getChatroomId())
										.messageId(messages.getMessageId())
										.senderId(messages.getSenderId())
										.content(messages.getContent())
										.sentAt(messages.getSentAt())
										.nickname(nickname)
										.count(messages.getCount())
										.build();
			} else if(messages.getMessageType() == MessageType.SYSTEM) {
				messages = messagesMapper.findMessage(); // 저장한 메세지 다시 가져옴
				
				dtoMsg = MessageDto.builder()
										.chatroomId(messages.getChatroomId())
										.messageId(messages.getMessageId())
										.senderId(messages.getSenderId())
										.content(messages.getContent())
										.sentAt(messages.getSentAt())
										.messageType(MessageDto.MessageType.SYSTEM)
										.nickname(nickname)
										.count(messages.getCount())
										.build();
			}
		} else {
			// 에러처리
		}
		return dtoMsg;
	}

    // 이전 채팅 이력 + 닉네임 출력
  public List<MessageDto> preMsg(ChatroomMembers chatroom, List<Users> userList) {
	  readMsgCount(chatroom); // 안읽은사람 수 최신화
      List<Messages> preMsgList = messagesMapper.preMsg(chatroom.getChatroomId());
      List<MessageDto> addNickname = new ArrayList<>();
      MessageDto dto = new MessageDto();
      for (int i = 0; i < preMsgList.size(); i++) {
    	  for (int j = 0; j < userList.size(); j++) {
			if(userList.get(j).getUserId() == preMsgList.get(i).getSenderId()) {
				if(preMsgList.get(i).getMessageType() == MessageType.SYSTEM) {
					dto = MessageDto.builder()
				    		  .chatroomId(preMsgList.get(i).getChatroomId())
				    		  .messageId(preMsgList.get(i).getMessageId())
				    		  .senderId(preMsgList.get(i).getSenderId())
				    		  .content(preMsgList.get(i).getContent())
				    		  .sentAt(preMsgList.get(i).getSentAt())
				    		  .nickname(userList.get(j).getNickname())
				    		  .messageType(MessageDto.MessageType.SYSTEM)
				    		  .count(preMsgList.get(i).getCount())
				    		  .build();
				} else {
					dto = MessageDto.builder()
							.chatroomId(preMsgList.get(i).getChatroomId())
							.messageId(preMsgList.get(i).getMessageId())
							.senderId(preMsgList.get(i).getSenderId())
							.content(preMsgList.get(i).getContent())
							.sentAt(preMsgList.get(i).getSentAt())
							.nickname(userList.get(j).getNickname())
							.messageType(MessageDto.MessageType.MESSAGE)
							.count(preMsgList.get(i).getCount())
							.build();
				}
    		  addNickname.add(dto);  
			}
    	  }
      }
      return addNickname;
  }
	
	// 메세지 안읽은사람 수 최신화
	public boolean readMsgCount(ChatroomMembers chatroom) {
		int res = 0;
		boolean result = false;
		res = messagesMapper.readMsgCount(chatroom);
		if(res != 0) {
			result = true;
			System.out.println("왜이래");
		}
		return result;
	}

	// 채팅방 구분없이 안읽은 메시지 갯수 가져오기
	public int msgAlarm(Integer userId) {
		List<ChatroomMembers> roomList = chatMapper.findAllRoomsByUserId(userId);
		int result = 0;
		for (int i = 0; i < roomList.size(); i++) {
			int receiveCount = messagesMapper.receiveMsgCount(roomList.get(i)); // 안읽은 메시지 갯수
			result += receiveCount;
		}
		return result;
	}
	
}
