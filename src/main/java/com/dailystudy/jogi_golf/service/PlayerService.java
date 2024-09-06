package com.dailystudy.jogi_golf.service;

import com.dailystudy.jogi_golf.domain.Player;
import com.dailystudy.jogi_golf.mapper.PlayerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PlayerService {
    @Autowired
    private PlayerMapper playerMapper;

    public void savePlayers(int gameId, List<String> playerNames, List<Integer> handicaps) {
        for (int i = 0; i < playerNames.size(); i++) {
            Player player = new Player();
            player.setGameId(gameId);
            player.setPlayerName(playerNames.get(i));
            player.setHandicap(handicaps.get(i));
            playerMapper.insertPlayer(player);
        }
    }

    public List<Player> getPlayersByGameId(int gameId) {
        return playerMapper.getPlayersByGameId(gameId);
    }

    public void updatePlayer(Player player) {
        playerMapper.updatePlayer(player);
    }

    public Player getPlayerByName(String playerName) {
        return playerMapper.getPlayerByName(playerName);
    }
}