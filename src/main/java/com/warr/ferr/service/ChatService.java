package com.warr.ferr.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import com.warr.ferr.dto.ChatroomDto;
import com.warr.ferr.dto.UserDto;
import com.warr.ferr.mapper.ChatMapper;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Chatrooms;
import com.warr.ferr.model.Users;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatMapper chatMapper;

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
    
    // 채팅방 생성시 중복검사복사
    public Map<Integer, List<Integer>> duplicationCheck(List<ChatroomMembers> list, List<Integer> userIdList) {
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
    public boolean createChatRoom(@RequestBody List<UserDto> userList, Users user) {
        boolean result = false;
        int res = 0;
        int resId = 0;

        UserDto userDto = UserDto.builder()
        							.userId(user.getUserId())
        							.nickname(user.getNickname())
        							.build();
        userList.add(userDto); // 사용자 포함 유저 리스트 (userId, nickname)
        
        
        
        Chatrooms name = new Chatrooms(); // 객체 생성
        name.setName(UUID.randomUUID().toString());
        resId = chatMapper.createRoomId(name); // chatroomId 생성

        // 중복 채팅방 검증
//        List<ChatroomMembers> list = chatMapper.findRoomByUserIdByChatroomId(userId); // user가 참여하고있는 채팅방 검색
//        // 그룹화+중복검증 메소드
//        Map<Integer, List<Integer>> groupedMap = duplicationCheck(list, userIdList);
//        System.out.println("group : " + groupedMap); // group : {32=[5, 6, 7], 26=[5, 6, 7], 27=[5, 7, 8], 29=[5, 6], 30=[5, 6, 8]}
//        System.out.println("userIdList : " + userIdList);

        
        if (resId != 0) {
        	String groupName = "";
        	String allName = "";
        	int chatroomId = 0;
        	List<ChatroomMembers> chatroomMembers = new ArrayList<>();
            List<Chatrooms> chatroomList = chatMapper.findAllRooms();
            
            // roomId 생성시 AI 설정빼버리고 uuid를 roomid에 직접넣어주면
            // 해당 for문 생략가능, chatroomName 칼럼도 삭제가능
            for (int i = chatroomList.size()-1; i >= 0;  i--) {
                if (chatroomList.get(i).getName().equals(name.getName())) {
                    chatroomId = chatroomList.get(i).getChatroomId();
                    break;
                }
            }
            
            // 채팅 기본 제목 = 참여자(본인제외) nickname 나열
            for (int i = 0; i < userList.size(); i++) {
            	if(i == 0) {
            		allName = userList.get(i).getNickname();
            	}else {
            		allName += ", " + userList.get(i).getNickname();
            	}
            }
            for (int i = 0; i < userList.size(); i++) {
            	if(i == 0) {
            		groupName = allName.replace(userList.get(i).getNickname() + ", ", "");
            	}else {
            		groupName = allName.replace(", " + userList.get(i).getNickname(), "");
            	}
            	
                chatroomMembers.add(ChatroomMembers.builder()
                        .chatroomId(chatroomId)
                        .chatroomName(groupName)
                        .userId(userList.get(i).getUserId())
                        .build());
            }

            res = chatMapper.createRoom(chatroomMembers);
            if (res != 0) {
                result = true;
            }
        }
        return result;
    }

    // 채팅방 제목 수정
    public boolean roomNameUpdate(ChatroomDto chatroomDto) {
    	int res;
    	boolean result = false;
    	
    	ChatroomMembers roomMembers = ChatroomMembers.builder()
    			.chatroomId(chatroomDto.getChatroomId())
    			.chatroomName(chatroomDto.getChatroomName())
    			.userId(chatroomDto.getUserId())
    			.build();
		res = chatMapper.roomNameUpdate(roomMembers);
		if(res != 0) {
			result = true;
		}
    	
    	return result;
    }

    // 방 떠나기
	public boolean chatroomLeave(ChatroomDto chatroomDto) {
		boolean result = false;
		int res = 0;
		
		res = chatMapper.chatroomLeave(chatroomDto);
		if(res != 0) {
			result = true;
		}
		return result;
	}
    
    
    
    // 채팅방 삭제 - 모든유저가 leave 상태인 채팅룸 id 기준으로 삭제
//	public int deleteRoom() {
//		List<Chatrooms> chatroomIdList = chatMapper.findAllRooms(); // 모든 채팅룸id 가져오기
//		List<Integer> idList = new ArrayList<>();
//		for (int i = 0; i < idList.size(); i++) {
//			idList.add(chatroomIdList.get(i).getChatroomId());
//		}
//		
//		int res = 0;
////		res = chatMapper.deleteRoomUser(chatList);
//		chatMapper.deleteRoom(idList);
//		return res;
//	}

	
	
}
