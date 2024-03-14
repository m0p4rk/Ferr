package com.warr.ferr.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.warr.ferr.model.Users;

@Mapper
public interface UserMapper {

    public Users loginUser(String email);

    public int insertUser(Users user);
    
    public int kakaoUsers(Users user);

	public void updateUser(Users existingUser);
	
	Integer findUserIdByEmail(String email);
}
