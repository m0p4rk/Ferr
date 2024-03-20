package com.warr.ferr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.warr.ferr.model.Messages;

@Mapper
public interface MessagesMapper {

	public int sendMessage(Messages messages);

	public Messages findMessage();

	public List<Messages> preMsg(int chatroomId);

}
