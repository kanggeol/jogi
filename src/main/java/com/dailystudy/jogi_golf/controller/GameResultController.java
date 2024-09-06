package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.service.GameResultService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class GameResultController {

    @Autowired
    private GameResultService gameResultService;

    @PostMapping("/saveGameResult")
    public String saveGameResult(GameResult gameResult) {
        gameResultService.saveGameResult(gameResult);
        return "redirect:/gameResult?gameId=" + gameResult.getGameId();
    }

    @GetMapping("/gameResultForm")
    public String gameResultForm(int gameId, Model model) {
        // TODO: Get players and existing results
        return "gameResultForm";
    }
}