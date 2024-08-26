package com.dailystudy.jogi_golf.repository;

import com.dailystudy.jogi_golf.domain.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.Map;
import java.util.Optional;

@Mapper
public interface UserMapper {

    Optional<User> login(String id, String password);

    Optional<User> findById(String id);

    Optional<User> member(Map map);

    String memberBuildingPhoneNumber(int MNumber, String AcademyCategoryCode);

    int isAlram(int MNumber, int ISNumber);

}
