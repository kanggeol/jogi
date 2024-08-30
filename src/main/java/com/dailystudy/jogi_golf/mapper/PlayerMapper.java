package com.dailystudy.jogi_golf.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PlayerMapper {
    Integer getHandicapByPlayerName(@Param("playerName") String playerName);

    void updateHandicap(@Param("playerName") String playerName, @Param("adjustment") int adjustment);

    // 새로운 플레이어를 추가하는 메서드
    void insertPlayer(@Param("playerName") String playerName, @Param("handicap") int handicap);
}
