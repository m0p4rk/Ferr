package com.warr.ferr.model;

import java.util.HashSet;
import java.util.Set;

import org.springframework.web.socket.WebSocketSession;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Chatrooms {
	public int chatroomId; // ai nn
	public String name; // nn
	private Set<WebSocketSession> sessions = new HashSet<>();
	
	public static Chatrooms create(String name){
        Chatrooms room = new Chatrooms();

//        room.chatroomId = UUID.randomUUID().toString();
        room.name = name;
        return room;
    }
}
