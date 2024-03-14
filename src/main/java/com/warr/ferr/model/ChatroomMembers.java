package com.warr.ferr.model;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
@Builder
public class ChatroomMembers {
	private int chatroomId;
	private String name;
//	private int userId;
//	private int id;
//	private String roomName;
//	private Status status;
//	private Timestamp lastReadAt;
//	
//	public enum Status{
//		JOIN,
//		LEAVE
//	}
//	@Builder
//	public ChatroomMembers(int chatroomId, int userId, int id, String roomName, Status status, Timestamp lastReadAt) {
//		super();
//		this.chatroomId = chatroomId;
//		this.userId = userId;
//		this.id = id;
//		this.roomName = roomName;
//		this.status = status;
//		this.lastReadAt = lastReadAt;
//	}
	@Builder
	public ChatroomMembers(int chatroomId, String name) {
		super();
		this.chatroomId = chatroomId;
		this.name = name;
}
	
	
	
}
