package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.domain.Game;
import com.dailystudy.jogi_golf.service.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class GameController {

    @Autowired
    private GameService gameService;

    @GetMapping("/")
    public String index(Model model) {
        List<Game> games = gameService.getAllGames();
        model.addAttribute("games", games);
        return "index";
    }

    @GetMapping("/createGame")
    public String createGameForm(Model model) {
        return "createGame";
    }

    @PostMapping("/createGame")
    public String createGame(Game game) {
        gameService.createGame(game);
        return "redirect:/";
    }

    @GetMapping("/dateList")
    public String dateList(Model model) {
        List<Game> games = gameService.getAllGames();
        model.addAttribute("games", games);
        return "dateList";
    }

    @GetMapping("/gameResult")
    public String gameResult(int gameId, Model model) {
        Game game = gameService.getGameById(gameId);
        model.addAttribute("game", game);
        return "gameResult";
    }
}