package com.dailystudy.jogi_golf.mapper;

import com.dailystudy.jogi_golf.domain.Game;
import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.PlayerTotal;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GameResultMapper {
    int insertGameId(Game game);
    void insertGameResult(GameResult gameResult);

    List<GameResult> selectGameResultsByDate(@Param("gameDate") String gameDate);

    List<PlayerTotal> selectPlayerTotals();

    void deleteGameResult(@Param("resultId") String resultId);

    List<String> findAllSavedDates();
}
