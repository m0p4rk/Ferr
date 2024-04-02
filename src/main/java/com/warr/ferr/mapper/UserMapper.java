package com.warr.ferr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
	public List<Users> findAllUser();
	// 채팅에서 임시로 사용중
	public Users findUserByUserId(int userId);
	
	
	public int getUserByEmail(String email);
	
	UserPreferences getUserPreferences(int userId);

	public void saveUserPreferences(UserPreferences preferences);

	public void updateUserPreferences(UserPreferences preferences);
	
	List<Users> findByNickname(@Param("nickname") String nickname);

	// 3/31 3:25 am 추가 닉네임 출력기능
	public String findNicknameByUserId(int userId);


}
