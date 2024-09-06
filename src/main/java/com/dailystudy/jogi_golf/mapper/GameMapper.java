package com.dailystudy.jogi_golf.mapper;

import com.dailystudy.jogi_golf.domain.Game;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface GameMapper {
    void insertGame(Game game);
    List<Game> getAllGames();
    Game getGameById(int gameId);
}
