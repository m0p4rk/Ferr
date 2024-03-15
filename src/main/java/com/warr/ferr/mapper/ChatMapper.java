package com.warr.ferr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Chatrooms;

@Mapper
public interface ChatMapper {

	// 모든 채팅방 리스트. 채팅방 생성시 사용
	List<Chatrooms> findAllRooms();

	// uesr와 관련있는 채팅방 리스트
	List<ChatroomMembers> findAllRoomsByUserId(int userId);

	// 채팅방 들어가기
	ChatroomMembers findRoomById(int chatroomId, int userId);

	// 방 생성
	int createRoom(@Param("chatroomMembers") List<ChatroomMembers> chatroomMembers);

	// chatroomId 생성용 
	int createRoomId(Chatrooms name);

	// 방 제목 수정
	int roomNameUpdate(ChatroomMembers roomMembers);

	// 방 삭제
	int deleteRoom(int roomId);

	List<ChatroomMembers> findRoomByUserIdByChatroomId(int userId);





}
