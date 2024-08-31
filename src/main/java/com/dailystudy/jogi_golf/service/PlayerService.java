package com.dailystudy.jogi_golf.service;

import com.dailystudy.jogi_golf.mapper.PlayerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PlayerService {

    @Autowired
    private PlayerMapper playerMapper;

    @Transactional
    public void updateHandicap(String playerName, int newHandicap) {
        Integer existingHandicap = playerMapper.getHandicapByPlayerName(playerName);
        if (existingHandicap != null) {
            playerMapper.updateHandicap(playerName, newHandicap);
        } else {
            playerMapper.insertPlayer(playerName, newHandicap);
        }
    }
}
