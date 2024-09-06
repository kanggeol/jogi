package com.dailystudy.jogi_golf.service;

import com.dailystudy.jogi_golf.domain.Game;
import com.dailystudy.jogi_golf.mapper.GameMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GameService {
    @Autowired
    private GameMapper gameMapper;

    public void createGame(Game game) {
        gameMapper.insertGame(game);
    }

    public List<Game> getAllGames() {
        return gameMapper.getAllGames();
    }

    public Game getGameById(int gameId) {
        return gameMapper.getGameById(gameId);
    }
}