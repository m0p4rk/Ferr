package com.warr.ferr.model;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Chatrooms implements Serializable {
	private static final long serialVersionUID = 1L;
	private int chatroomId;
	private String name;
	private int eventId;
	
}
//import java.util.List;
//import jakarta.servlet.http.HttpSession;
//import lombok.AllArgsConstructor;
//import lombok.Getter;
//import lombok.NoArgsConstructor;
//import lombok.Setter;
//import lombok.ToString;
//
//@Getter
//@Setter
//@AllArgsConstructor
//@NoArgsConstructor
//@ToString
//public class Chatrooms {
//	private int id;
//	private int chatroomId;
//	private int userId;
//	private String name;
//	private Status status = Status.JOIN;
//	
//	
////	private List<String> nickname;
////	private HttpSession session;
//	
////	private Timestamp lastReadAt;
//	
//	public enum Status{
//		JOIN,
//		LEAVE
//	}
//}
