package com.warr.ferr.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import com.warr.ferr.dto.ChatroomDto;
import com.warr.ferr.dto.UserDto;
import com.warr.ferr.mapper.ChatMapper;
import com.warr.ferr.mapper.MessagesMapper;
import com.warr.ferr.mapper.UserMapper;
import com.warr.ferr.model.ChatroomMembers;
import com.warr.ferr.model.Chatrooms;
import com.warr.ferr.model.Messages;
import com.warr.ferr.model.Users;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatMapper chatMapper;
    private final UserMapper userMapper;
    private final MessagesMapper messagesMapper;

    // 세션id가 참여중인 모든 채팅방 출력
    // 사용자 기준 참여중인 채팅방리스트 + 방제목 + 마지막 메시지 + 안읽은메시지 정보
    // 채팅룸에서 보여지는 대부분의 값들은 한번에 뭉쳐서 보내주려함
    public List<ChatroomDto> findAllRoomsByUserId(int userId){
    	List<ChatroomDto> chatroomDtoList = new ArrayList<>();
    	// ChatroomDto 객체 생성
    	
    	List<ChatroomMembers> roomList = chatMapper.findAllRoomsByUserId(userId); // 참여중인 채팅방 리스트
    	for (int i = 0; i < roomList.size(); i++) {
    		Messages lastMsg = messagesMapper.findLastMsg(roomList.get(i)); // 마지막 메시지
    		int receiveCount = messagesMapper.receiveMsgCount(roomList.get(i)); // 안읽은 메시지 갯수
    		Users user = userMapper.findUserByUserId(roomList.get(i).getUserId()); // 닉네임값 가져오기위해
    		List<Users> member = findUserByRoomId(roomList.get(i).getChatroomId()); // 방에속한 모든 유저
    		List<ChatroomMembers> leaveMember = findLeaveMember(roomList.get(i).getChatroomId()); // 방에서 떠난유저 
    		if(lastMsg != null) {
    			for (int j = 0; j < member.size(); j++) {
    				if(member.get(j).getUserId() == lastMsg.getSenderId()) {
    					chatroomDtoList.add(ChatroomDto.builder()
    							.userId(roomList.get(i).getUserId())
    							.chatroomId(roomList.get(i).getChatroomId())
    							.chatroomName(roomList.get(i).getChatroomName())
    							.messageId(lastMsg.getMessageId())
    							.senderId(lastMsg.getSenderId())
    							.content(lastMsg.getContent())
    							.sentAt(lastMsg.getSentAt())
    							.nickname(member.get(j).getNickname())
    							.members(member.size() - leaveMember.size())
    							.receiveCount(receiveCount)
    							.build());
    				}
				}
    		} else {
    			chatroomDtoList.add(ChatroomDto.builder()
						.userId(roomList.get(i).getUserId())
						.chatroomId(roomList.get(i).getChatroomId())
						.chatroomName(roomList.get(i).getChatroomName())
						.sentAt(roomList.get(i).getLastReadAt())
						.members(member.size() - leaveMember.size())
						.build());
    		}
    	}

    	 // chatroomDtoList를 sentAt을 기준으로 정렬
        chatroomDtoList.sort(Comparator.comparing(ChatroomDto::getSentAt).reversed());

        return chatroomDtoList;
    }

    // 특정 채팅방 출력
    public ChatroomMembers findRoomById(int id, int userId){
    	ChatroomMembers chatroom = chatMapper.findRoomById(id, userId);
    	
    	return chatroom;
    }
    
    
	// group : {32=[5, 6, 7], 26=[5, 6, 7], 27=[5, 7, 8], 29=[5, 6], 30=[5, 6, 8]}
    // 채팅방 생성시 중복검사
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
    public boolean createChatRoom(@RequestBody List<Users> userList, Users user) {
        boolean result = false;
        int res = 0;
        int resId = 0;

        userList.add(user); // 사용자 포함 유저 리스트 (userId, nickname)
        
        Chatrooms name = new Chatrooms(); // 객체 생성
        name.setName(UUID.randomUUID().toString());
        resId = chatMapper.createRoomId(name); // chatroomId 생성

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
            
            // 채팅 기본 제목 = nickname 나열
            for (int i = 0; i < userList.size(); i++) {
            	if(i == 0) {
            		allName = userList.get(i).getNickname();
            	}else {
            		allName += ", " + userList.get(i).getNickname();
            	}
            }
            // 각 유저본인의 닉네임을 제외
            for (int i = 0; i < userList.size(); i++) {
            	if(i == 0) {
            		groupName = allName.replace(userList.get(i).getNickname() + ", ", "");
            	}else {
            		groupName = allName.replace(", " + userList.get(i).getNickname(), "");
            	}
            	
            	// 각 유저별 chatroomId와 userId를 연결하고 본인의 닉네임을 제외한 제목을 기본값으로 넣어줌
            	if(groupName.length() <= 50) {
            		chatroomMembers.add(ChatroomMembers.builder()
								            				.chatroomId(chatroomId)
								            				.chatroomName(groupName)
								            				.userId(userList.get(i).getUserId())
								            				.build());
            	} else {
            		chatroomMembers.add(ChatroomMembers.builder()
								            				.chatroomId(chatroomId)
								            				.chatroomName(groupName.substring(0, 50))
								            				.userId(userList.get(i).getUserId())
								            				.build());
            	}
            }
            
            // 방 생성
            res = chatMapper.createRoom(chatroomMembers);
            if (res != 0) {
                result = true;
            }
        }
        return result;
    }

    // 채팅방 제목 수정
    public boolean roomNameUpdate(ChatroomMembers chatroomMember) {
    	int res;
    	boolean result = false;
    	if(chatroomMember.getChatroomName().length() <= 50) {
    		res = chatMapper.roomNameUpdate(chatroomMember);
    		if(res != 0) {
    			result = true;
    		}
    	} else {
    		// 50자가 초과되는경우 50자 이후는 잘라냄
    		chatroomMember.setChatroomName(chatroomMember.getChatroomName().substring(0, 50));
    		res = chatMapper.roomNameUpdate(chatroomMember);
    		if(res != 0) {
    			result = true;
    		}
    	}
    	return result;
    }

    // 방 떠나기 : 유저의 참여상태를 JOIN >> LEAVE로 변경
	public boolean chatroomLeave(ChatroomMembers chatroom) {
		boolean result = false;
		int res = 0;
		
		res = chatMapper.chatroomLeave(chatroom);
		if(res != 0) {
			result = true;
		}
		return result;
	}

	// 룸에 참여중인 유저 찾기
	public List<Users> findUserByRoomId(int chatroomId) {
		
		// room 에 참여중인 각 user정보
		List<ChatroomMembers> chatroomMembers =  chatMapper.findUserByRoomId(chatroomId);
		List<Users> users = new ArrayList<>();
		for (int i = 0; i < chatroomMembers.size(); i++) {
			users.add(userMapper.findUserByUserId(chatroomMembers.get(i).getUserId()));
		}
        return users;
    }

	// 채팅방 마지막 사용시간 최신화
	public boolean lastReadAtUpdate(int roomId, Integer userId) {
		boolean result = false;
		int res = 0;
		ChatroomMembers member = ChatroomMembers.builder().chatroomId(roomId)
														   .userId(userId)
														   .build();
		res = chatMapper.lastReadAtUpdate(member);
		if(res != 0) {
			result = true;
		}
		return result;
	}

	// 떠난 유저 찾기
	public List<ChatroomMembers> findLeaveMember(int chatroomId) {
		List<ChatroomMembers> leaveMember = chatMapper.findLeaveMember(chatroomId);
		return leaveMember;
	}

	public void inviteChat(List<Users> userList, int chatroomId) {
		List<ChatroomMembers> inviteList = new ArrayList<>();
		System.out.println("연결확인중");
		for (int i = 0; i < userList.size(); i++) {
			List<ChatroomMembers> leaveMembers =  chatMapper.findLeaveMember(chatroomId);
			if(leaveMembers.size() > 0) {
//				for (int j = 0; j < leaveMembers.size(); j++) {
//					chatMapper.reInviteUser(leaveMembers.get(i));
//				}
//			} else {
//				chatMapper.inviteChat(userList.get(i));
			}
		}
	}
	
//	public List<Users> findActiveUser(int chatroomId){
//		List<Users> userList = userMapper.findActiveUser(chatroomId);
//		
//		return null;
//	}


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
