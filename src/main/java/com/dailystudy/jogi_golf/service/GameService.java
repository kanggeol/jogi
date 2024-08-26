package com.dailystudy.jogi_golf.service;

import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.Player;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
public class GameService {
    public List<GameResult> calculateGameResults(List<Player> players, int gameFee) {
        // 실제 타수 계산
        for (Player player : players) {
            player.setTodayScore(player.getTodayScore() - player.getHandicap());
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
            result.setName(players.get(i).getName());
            result.setRank(i + 1);
            result.setCalculatedAmount(amount);
            results.add(result);
        }
        return results;
    }
}
