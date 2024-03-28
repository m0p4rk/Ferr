package com.warr.ferr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Messages;

@Mapper
public interface MessagesMapper {

	public int sendMessage(Messages messages);

	public Messages findMessage();

	public List<Messages> preMsg(int chatroomId);

	// 이전 메시지 조회
	public List<Messages> findPreMsgByRoomId(List<Integer> chatroomId);

	// 모든 메시지 가져오기
	public List<Messages> findAllMessage();

	public int readMsgCount(ChatroomMembers chatroom);

	// 안읽은메시지 몇개인지
	public int receiveMsgCount(ChatroomMembers chatroomMembers);
	
	// 마지막 메시지 확인
	public Messages findLastMsg(ChatroomMembers chatroomMembers);

	// 채팅방 구분없이 안읽은 메시지 갯수 가져오기
	public int msgAlarm(Integer userId);

}
