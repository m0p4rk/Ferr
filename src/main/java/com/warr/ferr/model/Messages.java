package com.warr.ferr.model;

import java.sql.Timestamp;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class Messages {
	private int messageId; // ai, pk, nn
	private int chatroomId; 
	private int senderId;
	private int receiverId; 
	private String content; // nn
	private Timestamp notificationTime;
	private Timestamp sentAt; // 현재시간
	private MessageType messageType = MessageType.MESSAGE;
	
	public enum MessageType{ // nn
		MESSAGE,
		NOTIFICATION
	}

	@Builder
	public Messages(int messageId, int chatroomId, int senderId, int receiverId, String content,
			Timestamp notificationTime, Timestamp sentAt) {
		super();
		this.messageId = messageId;
		this.chatroomId = chatroomId;
		this.senderId = senderId;
		this.receiverId = receiverId;
		this.content = content;
		this.notificationTime = notificationTime;
		this.sentAt = sentAt;
	}
}