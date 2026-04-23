package com.dailystudy.jogi_golf.mapper;

import com.dailystudy.jogi_golf.domain.Game;
import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.PlayerTotal;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface GameResultMapper {
    int insertGameId(Game game);
    void insertGame(Map map);
    void updateGameResult(GameResult gameResult);

    List<GameResult> selectGameResultsByDate(@Param("gameDate") String gameDate);

    List<PlayerTotal> selectPlayerTotals(@Param("year") String year);

    void deleteGameResult(@Param("resultId") String resultId);

    List<String> findAllSavedDates();

    List<String> findSavedDatesByYear(@Param("year") String year);

    List<String> findAllYears();

    int deleteSelectedGamePlayers(@Param("resultIds") List<Long> resultIds);

    int getGameFee(@Param("gameId") int gameId);

    List<GameResult> selectGameResultsByGameId(@Param("gameId") int gameId);

    Integer getGameIdByDate(@Param("gameDate") String gameDate);

    int deleteGameResultsByGameId(@Param("gameId") int gameId);

    int deleteGameById(@Param("gameId") int gameId);

    List<Integer> findGameIdsByDate(@Param("gameDate") String gameDate);

    boolean isGameExists(@Param("gameId") int gameId);

    String getGameDateByGameId(@Param("gameId") int gameId);
}
