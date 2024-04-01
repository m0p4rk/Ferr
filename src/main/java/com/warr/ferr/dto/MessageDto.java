package com.warr.ferr.dto;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonFormat;

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
public class MessageDto {
	private int messageId; // ai, pk, nn
	private int chatroomId; 
	private int senderId;
	private String content; // nn
	@Default private MessageType messageType = MessageType.MESSAGE;
	private String nickname;
	private int count;
    private Timestamp sentAt; // 현재시간
	
	public enum MessageType{ // nn
		MESSAGE,
		NOTIFICATION,
		SYSTEM
	}

	@Builder
	public MessageDto(int messageId, int chatroomId, int senderId, String content,
			Timestamp sentAt, String nickname, MessageType messageType, int count) {
		this.messageId = messageId;
		this.chatroomId = chatroomId;
		this.senderId = senderId;
		this.content = content;
		this.sentAt = sentAt != null ? sentAt : Timestamp.from(Instant.now());
		this.nickname = nickname;
		this.messageType = messageType;
		this.count = count;
    }
	
	public String getSentAtAsString() {
        SimpleDateFormat sdf = new SimpleDateFormat("MM월dd일 HH:mm");
        return sdf.format(this.sentAt);
    }

}
