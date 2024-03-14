package com.warr.ferr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Chatrooms;

@Mapper
public interface ChatMapper {

	List<Chatrooms> findAllRooms();

	Chatrooms findRoomById(String id);

	void createRoom(Chatrooms room);

	int deleteRoom(int roomId);

	int roomNameUpdate(ChatroomMembers roomMembers);


}
