package com.warr.ferr.dto;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@Builder
public class ChatroomDto {
    private int chatroomId;
    private int userId;
    private String chatroomName;
    private String nickname;
    private int messageId;
    private int senderId;
    private int receiveCount;
    private int members;
    private String content;
    private Timestamp sentAt;

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


