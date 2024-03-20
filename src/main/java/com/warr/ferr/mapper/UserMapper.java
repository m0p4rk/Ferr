package com.warr.ferr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.warr.ferr.model.UserPreferences;
import com.warr.ferr.model.Users;

@Mapper
public interface UserMapper {


	public Users loginUser(String email);

    public int insertUser(Users user);
    
    public int kakaoUsers(Users user);

	public void updateUser(Users existingUser);
	
	Integer findUserIdByEmail(String email);
	
	// 채팅에서 임시로 사용중
	public List<Users> findAllUser(Object userId);
	// 채팅에서 임시로 사용중
	public Users findUserById(int userId);
	
	List<Users> findAllUser();
	
	public int getUserByEmail(String email);
	
	UserPreferences getUserPreferences(int userId);

	public void saveUserPreferences(UserPreferences preferences);

	public void updateUserPreferences(UserPreferences preferences);

}
