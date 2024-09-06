package com.dailystudy.jogi_golf.mapper;

import com.dailystudy.jogi_golf.domain.GameResult;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface GameResultMapper {
    void insertGameResult(GameResult gameResult);
    List<GameResult> getGameResultsByGameId(int gameId);
    void updateGameResult(GameResult gameResult);
}
