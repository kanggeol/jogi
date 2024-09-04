package com.dailystudy.jogi_golf.mapper;

import com.dailystudy.jogi_golf.domain.Game;
import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.Player;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface GameMapper {

//    @Insert("INSERT INTO games (game_date, game_fee) VALUES (#{gameDate}, #{gameFee})")
//    @Options(useGeneratedKeys = true, keyProperty = "gameId")
    void insertGame(Game game);

    @Insert("INSERT INTO players (game_id, player_name, handicap) VALUES (#{gameId}, #{playerName}, #{handicap})")
    void insertPlayer(Player player);

    @Select("SELECT * FROM players WHERE game_id = #{gameId}")
    List<Player> selectPlayersByGameId(int gameId);

    @Select("SELECT game_date FROM games WHERE game_id = #{gameId}")
    String selectGameDateById(int gameId);

    @Select("SELECT game_fee FROM games WHERE game_id = #{gameId}")
    int selectGameFeeById(int gameId);

    @Insert("INSERT INTO game_results (game_id, result_data) VALUES (#{gameId}, #{result})")
    void insertGameResult(@Param("gameId") int gameId, @Param("result") GameResult result);

    @Select("SELECT game_date FROM games")
    List<String> selectAllGameDates();

    @Select("SELECT * FROM game_results WHERE game_id = (SELECT game_id FROM games WHERE game_date = #{date})")
    GameResult selectResultByDate(String date);
}
