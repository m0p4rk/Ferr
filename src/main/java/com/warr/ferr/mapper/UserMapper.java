package com.warr.ferr.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.warr.ferr.dto.UserDto;

@Mapper
public interface UserMapper {

    public UserDto loginUser(Map<String, String> map);

    public int insertUser(UserDto userDto);
}
