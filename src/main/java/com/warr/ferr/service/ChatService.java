package com.warr.ferr.service;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.warr.ferr.dto.ChatroomDto;
import com.warr.ferr.mapper.ChatMapper;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Chatrooms;

import jakarta.annotation.PostConstruct;

@Service
public class ChatService {

	@Autowired
    ChatMapper chatMapper;

//    private Map<String, Chatrooms> chatRoomDTOMap;
//
//    @PostConstruct
//    private void init(){
//        chatRoomDTOMap = new LinkedHashMap<>();
//    }
    
    // 모든 채팅방 출력
    public List<Chatrooms> findAllRooms(){
    	
    	List<Chatrooms> result = chatMapper.findAllRooms();
//        List<Chatrooms> result = new ArrayList<>(chatRoomDTOMap.values());
        
        // List 역순 정렬(최신 생성된 채팅방 생성 순서로 변경)
        Collections.reverse(result);

        return result;
    }

    // 특정 채팅방 출력
    public Chatrooms findRoomById(String id){
    	
//        return chatRoomDTOMap.get(id);
    	return chatMapper.findRoomById(id);
    }

    // 채팅방 생성
    public Chatrooms createChatRoom(List<String> name){
    	String str = "";
    	for(int i = 0; i < name.size(); i++) {
    		if(i == 0) {
    			str += name.get(i);
    		} else {
    			str += ", " + name.get(i);
    		}
    		
    	}
    	Chatrooms room = Chatrooms.create(str);
        chatMapper.createRoom(room);
//        chatRoomDTOMap.put(room.getChatroomId(), room); // roomId + ChatRoomDTO

        return room;
    }

    // 채팅방 삭제
	public boolean deleteRoom(int roomId) {
		boolean result = false;
		int res = chatMapper.deleteRoom(roomId);
		System.out.println("res = " + res);
		if(res == 1) {
			result = true;
		}
		return result;
		
	}

	public boolean roomNameUpdate(ChatroomDto chatroom) {
		int res;
		boolean result = false;
		
		ChatroomMembers roomMembers = ChatroomMembers.builder()
													.chatroomId(chatroom.getChatroomId())
													.name(chatroom.getRoomName())
													.build();
		System.out.println(roomMembers.getChatroomId());
		res = chatMapper.roomNameUpdate(roomMembers);
		System.out.println("res : " + res);
		if(res != 0) {
			result = true;
		}
		
		return result;
	}
}
