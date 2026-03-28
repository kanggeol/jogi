package com.dailystudy.jogi_golf.service;

import com.dailystudy.jogi_golf.domain.Game;
import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.Player;
import com.dailystudy.jogi_golf.domain.PlayerTotal;
import com.dailystudy.jogi_golf.mapper.GameResultMapper;
import com.dailystudy.jogi_golf.mapper.PlayerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class GameService {

    @Autowired
    private GameResultMapper gameResultMapper;
    @Autowired
    private PlayerMapper playerMapper;

    public List<GameResult> calculateGameResults(List<Player> players, int gameFee) {
        // 원래 타수 저장 및 실제 타수 계산
        for (Player player : players) {
            player.setTodayScore(player.getOriginalScore() - player.getHandicap()); // 핸디를 뺀 타수로 계산
        }

        // 순위 계산 (핸디 적용된 타수 기준 오름차순 정렬)
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
            result.setResultId(players.get(i).getResultId());
            result.setOriginalScore(players.get(i).getOriginalScore()); // 원래 타수 저장
            result.setTodayScore(players.get(i).getTodayScore());  // 핸디가 적용된 타수 저장
            result.setHandicap(players.get(i).getHandicap()); // 핸디 저장
            result.setCalculatedAmount(amount);
            results.add(result);
        }

        // 금액 기준 정렬 (내림차순)
        results.sort(Comparator.comparingInt(GameResult::getCalculatedAmount).reversed());

        // 동일한 금액에 대해 같은 순위 부여
        int rank = 1;
        for (int i = 0; i < results.size(); i++) {
            if (i > 0 && results.get(i).getCalculatedAmount() == results.get(i - 1).getCalculatedAmount()) {
                results.get(i).setRank(results.get(i - 1).getRank()); // 같은 금액이면 동일 순위
            } else {
                results.get(i).setRank(rank); // 새로운 순위 부여
            }
            rank++;
        }

        return results;
    }

    public void saveGame(Map<String, Object> gameResult) {
        gameResultMapper.insertGame(gameResult);
    }

    public void updateGameResult(GameResult gameResult) {
        gameResultMapper.updateGameResult(gameResult);
    }

    public int saveGameId(String gameDate,Integer gameFee) {
        Game game = new Game();
        game.setGameDate(gameDate);
        game.setGameFee(gameFee);
        gameResultMapper.insertGameId(game);
        return game.getGameId();
    }

    public List<GameResult> getGameResultsByDate(String gameDate) {
        return gameResultMapper.selectGameResultsByDate(gameDate);
    }

    public List<GameResult> getGameResultsByGameId(int gameId) {
        return gameResultMapper.selectGameResultsByGameId(gameId);
    }

    public List<PlayerTotal> getPlayerTotals(String year) {
        if ("thisYear".equals(year)) {
            year = String.valueOf(LocalDate.now().getYear());
        }
        return gameResultMapper.selectPlayerTotals(year);
    }

    public void deleteGameResult(String resultId) {
        gameResultMapper.deleteGameResult(resultId);
    }

    public List<String> getAllSavedDates() {
        return gameResultMapper.findAllSavedDates();
    }

    public List<String> getSavedDatesByYear(String year) {
        if ("thisYear".equals(year)) {
            year = String.valueOf(LocalDate.now().getYear());
        }
        return gameResultMapper.findSavedDatesByYear(year);
    }

    public List<String> getAllYears() {
        return gameResultMapper.findAllYears();
    }

    public boolean deleteSelectedGamePlayers(List<Long> resultIds) {
        try {
            int deletedRows = gameResultMapper.deleteSelectedGamePlayers(resultIds);
            return deletedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getGameFee(int gameId) {
        return gameResultMapper.getGameFee(gameId);
    }

    public Integer getGameIdByDate(String gameDate) {
        return gameResultMapper.getGameIdByDate(gameDate);
    }

    public void recalculateGameResults(int gameId) {
        List<GameResult> remaining = gameResultMapper.selectGameResultsByGameId(gameId);
        if (remaining.isEmpty()) return;

        int gameFee = getGameFee(gameId);

        // GameResult → Player 변환
        List<Player> players = remaining.stream().map(gr -> {
            Player p = new Player();
            p.setResultId(gr.getResultId());
            p.setPlayerName(gr.getPlayerName());
            p.setOriginalScore(gr.getOriginalScore());
            p.setHandicap(gr.getHandicap());
            return p;
        }).collect(Collectors.toList());

        // 기존 calculateGameResults() 재사용
        List<GameResult> recalculated = calculateGameResults(players, gameFee);

        // DB 업데이트
        for (GameResult result : recalculated) {
            updateGameResult(result);
        }
    }

    public void deleteGame(int gameId) {
        // 해당 게임의 모든 결과 삭제
        gameResultMapper.deleteGameResultsByGameId(gameId);
        // 게임 자체 삭제
        gameResultMapper.deleteGameById(gameId);
    }

    public List<Integer> getGameIdsByDate(String gameDate) {
        return gameResultMapper.findGameIdsByDate(gameDate);
    }

    public boolean isGameExists(int gameId) {
        return gameResultMapper.isGameExists(gameId);
    }
}
