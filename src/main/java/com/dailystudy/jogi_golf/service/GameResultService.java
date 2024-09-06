package com.dailystudy.jogi_golf.service;

import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.mapper.GameResultMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GameResultService {
    @Autowired
    private GameResultMapper gameResultMapper;

    public void saveGameResult(GameResult gameResult) {
        gameResultMapper.insertGameResult(gameResult);
    }

    public List<GameResult> getGameResultsByGameId(int gameId) {
        return gameResultMapper.getGameResultsByGameId(gameId);
    }

    public void updateGameResult(GameResult gameResult) {
        gameResultMapper.updateGameResult(gameResult);
    }
}