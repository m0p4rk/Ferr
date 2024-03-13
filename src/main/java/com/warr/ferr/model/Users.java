package com.warr.ferr.model;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class Users {
	private int userId;
	private String kakaoId;
	private String email;
	private String password;
	private String nickname;
	private String profileImageUrl;
	private Role role;
	private String realName;
	private AccountStatus accountStatus;
	private Timestamp createdAt;

	public enum Role {
		USER, ADMIN
	}

	public enum AccountStatus {
		ACTIVE, DEACTIVATION_PENDING, DEACTIVATED
	}

}
