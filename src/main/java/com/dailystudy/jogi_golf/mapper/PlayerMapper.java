package com.dailystudy.jogi_golf.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PlayerMapper {
    Integer getHandicapByPlayerName(@Param("playerName") String playerName);
    void updateHandicap(@Param("playerName") String playerName, @Param("handicap") int handicap);
    void insertPlayer(@Param("playerName") String playerName, @Param("handicap") int handicap);
}
