package com.warr.ferr.model;

import java.sql.Timestamp;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.Builder.Default;

@Getter
@Setter
@NoArgsConstructor
@ToString
@Builder
public class ChatroomMembers {
	private int chatroomId;
	private int userId;
	private String chatroomName;
	@Default private Status status = Status.JOIN;
	private Timestamp lastReadAt;
	
	public enum Status{
		JOIN,
		LEAVE
	}
	@Builder
	public ChatroomMembers(int chatroomId, int userId, String chatroomName, Status status, Timestamp lastReadAt) {
		super();
		this.chatroomId = chatroomId;
		this.userId = userId;
		this.chatroomName = chatroomName;
		this.status = status;
		this.lastReadAt = lastReadAt;
	}
}
