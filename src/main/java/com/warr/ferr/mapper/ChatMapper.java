package com.warr.ferr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.warr.ferr.dto.ChatroomDto;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Chatrooms;
import com.warr.ferr.model.Users;

@Mapper
public interface ChatMapper {

	// 모든 채팅방 리스트. 채팅방 생성시 사용
	public List<Chatrooms> findAllRooms();

	// uesr와 관련있는 채팅방 리스트
	public List<ChatroomMembers> findAllRoomsByUserId(int userId);

	// 채팅방 들어가기
	public ChatroomMembers findRoomById(int chatroomId, int userId);

	// 방 생성
	public int createRoom(@Param("chatroomMembers") List<ChatroomMembers> chatroomMembers);

	// chatroomId 생성용 
	public int createRoomId(Chatrooms name);

	// 방 제목 수정
	public int roomNameUpdate(ChatroomMembers roomMembers);

	// 모든유저가 leave 상태 채팅룸 삭제
//	public void deleteRoom(List<Integer> chatroomIdList);  
	// 방 삭제 : 모든유저가 leave 상태인 채팅룸 id 기준으로 삭제
//	public int deleteRoomUser(List<Chatrooms> chatroomList);

	// 사용자가 참여중인 룸 찾기
	public List<ChatroomMembers> findRoomByUserIdByChatroomId(int userId);
	
	// 채팅방 떠나기
	public int chatroomLeave(ChatroomMembers chatroom);

	// 채팅방에 소속된 유저 탐색
	public List<ChatroomMembers> findUserByRoomId(int chatroomId);

	public int lastReadAtUpdate(ChatroomMembers member);

	// 룸에서 떠난 유저 찾기
	public List<ChatroomMembers> findLeaveMember(int chatroomId);


}
