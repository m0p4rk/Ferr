package com.warr.ferr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Chatrooms;

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

	// 채팅에 멤버 추가할때 떠난유저인지 확인하고 다시 JOIN상태로 바꿀때
	public void reJoinMember(ChatroomMembers chatroom);

	// 채팅에 멤버 초대(추가)
	public void addChatMember(ChatroomMembers chatroom);


}
