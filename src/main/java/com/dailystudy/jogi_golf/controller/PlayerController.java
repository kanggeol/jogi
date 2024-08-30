package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.service.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class PlayerController {

    @Autowired
    private GameService gameService;

    @GetMapping("/player-handicap")
    public ResponseEntity<Map<String, Object>> getPlayerHandicap(@RequestParam("playerName") String playerName) {
        Map<String, Object> response = new HashMap<>();
        gameService.ensurePlayerExists(playerName); // Ensure player exists
        int handicap = gameService.getPlayerHandicap(playerName);
        response.put("exists", true); // Assumes player exists
        response.put("handicap", handicap);
        return ResponseEntity.ok(response);
    }
}
