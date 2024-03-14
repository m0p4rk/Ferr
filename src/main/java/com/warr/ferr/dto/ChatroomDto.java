package com.warr.ferr.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class ChatroomDto {
	private int chatroomId;
	private String userId;
	private int id;
	private String roomName;
//	private Status status;
//	private Timestamp lastReadAt;
	
	public enum Status{
		JOIN,
		LEAVE
	}
}
