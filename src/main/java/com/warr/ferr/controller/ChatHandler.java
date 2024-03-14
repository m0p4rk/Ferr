package com.warr.ferr.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor // 생성자 자동 생성해줌
public class ChatHandler extends TextWebSocketHandler  {
	
	public static final String DEFAULT_PATH = "/topic/public/";
	
	// WebSocketSession : WebSocket 통신으로 연결 후 상태를 유지하는 객체
    private static List<WebSocketSession> webSocketSessionList = new ArrayList<>();

    @Override
    protected void handleTextMessage(WebSocketSession webSocketSession, TextMessage message) throws Exception {
        String payload = message.getPayload();
        
        log.info("payload : " + payload);

        for(WebSocketSession wsSession: webSocketSessionList) {
        	wsSession.sendMessage(message);
        }
    }

    // Client가 서버에 연결 후 실행되는 메소드 
    @Override
    public void afterConnectionEstablished(WebSocketSession webSocketSession) throws Exception {

    	webSocketSessionList.add(webSocketSession);
        log.info(webSocketSession + " 클라이언트 접속");
    }

    // Client가 서버와 연결 종료후 실행되는 메소드
    @Override
    public void afterConnectionClosed(WebSocketSession webSocketSession, CloseStatus status) throws Exception {

        log.info(webSocketSession + " 클라이언트 접속 해제");
        webSocketSessionList.remove(webSocketSession);
    }
}
