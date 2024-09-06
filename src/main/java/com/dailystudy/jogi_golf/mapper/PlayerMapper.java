package com.dailystudy.jogi_golf.mapper;

import com.dailystudy.jogi_golf.domain.Player;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PlayerMapper {
    void insertPlayer(Player player);
    List<Player> getPlayersByGameId(int gameId);
    void updatePlayer(Player player);
    Player getPlayerByName(String playerName);
}
