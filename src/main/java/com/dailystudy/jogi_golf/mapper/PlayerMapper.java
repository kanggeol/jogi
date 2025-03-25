package com.dailystudy.jogi_golf.mapper;

import com.dailystudy.jogi_golf.domain.Player;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PlayerMapper {
    Integer getHandicapByPlayerName(@Param("playerName") String playerName);

    void updateHandicap(@Param("playerName") String playerName, @Param("handicap") int handicap);

    void insertPlayer(@Param("playerName") String playerName, @Param("handicap") int handicap);

    List<Player> findPlayersByName(String playerName);
}
