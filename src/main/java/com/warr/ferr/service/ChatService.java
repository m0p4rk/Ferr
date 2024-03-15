package com.warr.ferr.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import com.warr.ferr.dto.ChatroomDto;
import com.warr.ferr.dto.UserDto;
import com.warr.ferr.mapper.ChatMapper;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Chatrooms;

import jakarta.servlet.http.HttpSession;

@Service
public class ChatService {

	@Autowired
    ChatMapper chatMapper;

    
    // 세션id가 참여중인 모든 채팅방 출력
    public List<ChatroomMembers> findAllRoomsByUserId(int userId){
    	
    	List<ChatroomMembers> roomList = chatMapper.findAllRoomsByUserId(userId);
        // List 역순 정렬(최신 생성된 채팅방 생성 순서로 변경)
        Collections.reverse(roomList);

        return roomList;
    }

    // 특정 채팅방 출력
    public ChatroomMembers findRoomById(int id, int userId){
    	ChatroomMembers chatroom = chatMapper.findRoomById(id, userId);
    	
    	return chatroom;
    }
    
    // 채팅방 생성시 중복검사
    public Map<Integer, List<Integer>> groupByChatroomId(List<ChatroomMembers> list, List<Integer> userIdList) {
        Map<Integer, List<Integer>> groupedMap = new HashMap<>();

        // 각 채팅방 별로 userIdList에 속하는 사용자 아이디들을 모은 후, 그룹화
        for (ChatroomMembers member : list) {
            int chatroomId = member.getChatroomId();
            int userId = member.getUserId();

            // 맵에 해당 채팅방이 없으면 새로운 리스트를 생성하여 추가
            groupedMap.putIfAbsent(chatroomId, new ArrayList<>());
            List<Integer> usersInChatroom = groupedMap.get(chatroomId);
            usersInChatroom.add(userId);
        }

        // 각 채팅방의 유저 리스트를 출력하면서 userIdList와 비교
        Set<Integer> keys = groupedMap.keySet();
        for (Integer key : keys) {
            List<Integer> usersInChatroom = groupedMap.get(key);

            // 두 리스트가 동일한지 확인
            boolean isEqual = usersInChatroom.containsAll(userIdList) 
            					&& userIdList.containsAll(usersInChatroom);

            System.out.println("Chatroom " + key + ": Lists are equal: " + isEqual);
        }

        return groupedMap;
    }

 // 채팅방 생성
    public boolean createChatRoom(@RequestBody List<UserDto> userList, HttpSession session) {
        boolean result = false;
        int res = 0;
        int resId = 0;

        List<Integer> userIdList = new ArrayList<>();
        List<ChatroomMembers> chatroomMembers = new ArrayList<>();

        String chatroomName = "";
        Chatrooms name = new Chatrooms(); // 객체 생성

        name.setName(UUID.randomUUID().toString());

        int userId = (Integer) session.getAttribute("userId");
        userIdList.add(userId); // 선택한 유저목록 + 세션ID
        chatroomName = (String) session.getAttribute("nickname");
        
        	
        // 유저리스트 by userId
        for (int i = 0; i < userList.size(); i++) {
            userIdList.add(userList.get(i).getUserId());
        }
        // 중복
        List<ChatroomMembers> list = chatMapper.findRoomByUserIdByChatroomId(userId); // user가 참여하고있는 채팅방 검색
        // 그룹화+중복검증 메소드
        Map<Integer, List<Integer>> groupedMap = groupByChatroomId(list, userIdList);
        System.out.println("group : " + groupedMap); // group : {32=[5, 6, 7], 26=[5, 6, 7], 27=[5, 7, 8], 29=[5, 6], 30=[5, 6, 8]}
        System.out.println("userIdList : " + userIdList);

        // 채팅방 기본 제목 = 참여자(본인포함) nickname 나열
        for (int i = 0; i < userList.size(); i++) {
                chatroomName += ", " + userList.get(i).getNickname();
        }

        resId = chatMapper.createRoomId(name); // chatroomId 생성
 
        if (resId != 0) {
            List<Chatrooms> chatroomList = chatMapper.findAllRooms();
            int chatroomId = 0;
            for (int i = 0; i < chatroomList.size(); i++) {
                if (chatroomList.get(i).getName().equals(name.getName())) {
                    chatroomId = chatroomList.get(i).getChatroomId();
                }
            }

            ChatroomMembers members = new ChatroomMembers(); // ChatroomMembers 객체 생성
            members.setChatroomName(chatroomName); // 방제목
            members.setChatroomId(chatroomId); // 방id

            for (int i = 0; i < userIdList.size(); i++) {
                chatroomMembers.add(ChatroomMembers.builder()
                        .chatroomId(chatroomId)
                        .chatroomName(chatroomName)
                        .userId(userIdList.get(i))
                        .build());
            }

            res = chatMapper.createRoom(chatroomMembers);
            if (res != 0) {
                result = true;
            }
        }
        return result;
    }

    // 채팅방 삭제
	public boolean deleteRoom(int roomId) {
		boolean result = false;
		int res = chatMapper.deleteRoom(roomId);
		if(res == 1) {
			result = true;
		}
		return result;
		
	}

	public boolean roomNameUpdate(ChatroomDto chatroom, HttpSession session) {
		int res;
		boolean result = false;
		
		ChatroomMembers roomMembers = ChatroomMembers.builder()
													.chatroomId(chatroom.getChatroomId())
													.chatroomName(chatroom.getName())
													.userId((Integer) session.getAttribute("userId"))
													.build();
		res = chatMapper.roomNameUpdate(roomMembers);
		if(res != 0) {
			result = true;
		}
		
		return result;
	}
	
	
}
