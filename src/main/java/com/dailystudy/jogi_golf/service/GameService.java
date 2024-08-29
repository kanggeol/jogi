package com.dailystudy.jogi_golf.service;

import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.Player;
import com.dailystudy.jogi_golf.domain.PlayerTotal;
import com.dailystudy.jogi_golf.mapper.GameResultMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
public class GameService {

    @Autowired
    private GameResultMapper gameResultMapper;

    public List<GameResult> calculateGameResults(List<Player> players, int gameFee) {
        // 원래 타수 저장 및 실제 타수 계산
        for (Player player : players) {
            player.setOriginalScore(player.getTodayScore());  // 원래 타수를 저장
            player.setTodayScore(player.getTodayScore() - player.getHandicap()); // 핸디를 뺀 타수로 계산
        }

        // 순위 계산
        players.sort(Comparator.comparingInt(Player::getTodayScore));

        // 금액 계산
        List<GameResult> results = new ArrayList<>();
        for (int i = 0; i < players.size(); i++) {
            int amount = 0;
            for (int j = 0; j < players.size(); j++) {
                if (i == j) continue;
                int difference = players.get(j).getTodayScore() - players.get(i).getTodayScore();
                amount += difference * gameFee;
            }
            GameResult result = new GameResult();
            result.setPlayerName(players.get(i).getPlayerName());
            result.setOriginalScore(players.get(i).getOriginalScore()); // 원래 타수 저장
            result.setTodayScore(players.get(i).getTodayScore());  // 핸디가 적용된 타수 저장
            result.setHandicap(players.get(i).getHandicap()); // 핸디 저장
            result.setRank(i + 1);
            result.setCalculatedAmount(amount);
            results.add(result);
        }
        return results;
    }


    public void saveGameResult(GameResult gameResult) {
        gameResultMapper.insertGameResult(gameResult);
    }

    public List<GameResult> getGameResultsByDate(String gameDate) {
        return gameResultMapper.selectGameResultsByDate(gameDate);
    }

    public List<PlayerTotal> getPlayerTotals() {
        return gameResultMapper.selectPlayerTotals();
    }

    public void deleteGameResult(String resultId) {
        gameResultMapper.deleteGameResult(resultId);
    }
}
