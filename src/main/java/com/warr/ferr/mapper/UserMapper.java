package com.warr.ferr.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.warr.ferr.model.Users;

@Mapper
public interface UserMapper {
	public int kakaoUsers(Users user);
}
