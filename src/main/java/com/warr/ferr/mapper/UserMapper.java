package com.warr.ferr.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.warr.ferr.model.Users;

@Mapper
public interface UserMapper {

    public Users loginUser(Map<String, String> map);

    public int insertUser(Users user);
}
