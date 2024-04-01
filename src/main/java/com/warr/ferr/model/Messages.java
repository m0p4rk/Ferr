package com.warr.ferr.model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import com.warr.ferr.dto.MessageDto.MessageType;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.Builder.Default;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@ToString
public class Messages {
	private int messageId; // ai, pk, nn
	private int chatroomId; 
	private int senderId;
	private int receiverId; 
	private String content; // nn
	private Timestamp notificationTime;
	private Timestamp sentAt; // 현재시간
	@Default private MessageType messageType = MessageType.MESSAGE;
	private int count;
	
	
	public enum MessageType{ // nn
		MESSAGE,
		NOTIFICATION,
		SYSTEM
	}

	@Builder
	public Messages(int messageId, int chatroomId, int senderId, int receiverId, String content,
			Timestamp notificationTime, Timestamp sentAt, int count, MessageType messageType) {
		super();
		this.messageId = messageId;
		this.chatroomId = chatroomId;
		this.senderId = senderId;
		this.receiverId = receiverId;
		this.content = content;
		this.notificationTime = notificationTime;
		this.sentAt = sentAt;
		this.count = count;
		this.messageType = messageType;
    }
	
	// sentAt을 String 형태로 반환하는 메서드
    public String getFormattedSentAt() {
        if (sentAt != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("MM월 dd일 HH:mm");
            return sdf.format(sentAt);
        } else {
            return "";
        }
    }

}