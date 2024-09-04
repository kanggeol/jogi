package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.mapper.PlayerMapper;
import com.dailystudy.jogi_golf.service.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
public class GameApiController {

    @Autowired
    private GameService gameService;

    @Autowired
    private PlayerMapper playerMapper;



    @PostMapping("/update-handicap")
    @ResponseBody
    public Map<String, Object> updateHandicap(@RequestParam String playerName, @RequestParam int handicap) {
        Map<String, Object> response = new HashMap<>();

        try {
            playerMapper.updateHandicap(playerName, handicap);
            response.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
        }

        return response;
    }

}
