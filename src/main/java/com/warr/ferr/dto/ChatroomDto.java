package com.warr.ferr.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class ChatroomDto {
	public int chatroomId;
	public int userId;
	public String chatroomName;
	
}


//import java.util.HashSet;
//import java.util.Set;
//import java.util.UUID;
//
//import org.springframework.web.socket.WebSocketSession;
//
//import lombok.Getter;
//import lombok.Setter;
//import lombok.ToString;
//
//@Getter
//@Setter
//@ToString
//public class ChatroomDto {
//	public int chatroomId; // ai nn
//	public String name; // nn
////	private Set<WebSocketSession> sessions = new HashSet<>();
//	
//	public static ChatroomDto create(){
//        ChatroomDto room = new ChatroomDto();
//
//        room.name = UUID.randomUUID().toString();
//        return room;
//    }
//}


