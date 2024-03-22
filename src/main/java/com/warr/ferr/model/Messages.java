package com.warr.ferr.model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.Instant;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
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
//		this.sentAt = sentAt;
		this.sentAt = sentAt != null ? sentAt : Timestamp.from(Instant.now());
    }

    // sentAt 필드의 값을 초까지만 표기하는 문자열로 변환
    public String getSentAtAsString() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(this.sentAt);
    }
}