package com.warr.ferr.model;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Builder
public class Users {
    private int userId;
    private String kakaoId;
    private String email;
    private String password;
    private String nickname;
    private String profileImageUrl;
    @Default private Role role = Role.USER; // 기본값이 사용되도록 @Builder.Default 추가
    private String realName;
    @Default private AccountStatus accountStatus = AccountStatus.ACTIVE; // 기본값이 사용되도록 @Builder.Default 추가
    private Timestamp createdAt;

    public enum Role {
        USER, ADMIN
    }

    public enum AccountStatus {
        ACTIVE, DEACTIVATION_PENDING, DEACTIVATED
    }
}
