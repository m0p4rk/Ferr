package com.warr.ferr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.warr.ferr.model.Users;

@Mapper
public interface UserMapper {

    public Users loginUser(String email);

    public int insertUser(Users user);
    
    public int kakaoUsers(Users user);

	public void updateUser(Users existingUser);
	
	Integer findUserIdByEmail(String email);
	
	// 채팅에서 임시로 사용중
	List<Users> findAllUser();
}
