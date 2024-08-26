package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.Player;
import com.dailystudy.jogi_golf.service.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
@Controller
public class GameController {
    private final GameService gameService;

    public GameController(GameService gameService) {
        this.gameService = gameService;
    }

    @GetMapping("/")
    public String showGameForm() {
        return "gameForm";
    }

    @PostMapping("/calculate")
    public String calculate(
            @RequestParam("gameFee") int gameFee,
            @RequestParam("names") List<String> names,
            @RequestParam("todayScores") List<Integer> todayScores,
            @RequestParam("handicaps") List<Integer> handicaps,
            Model model) {

        List<Player> players = new ArrayList<>();
        for (int i = 0; i < names.size(); i++) {
            Player player = new Player();
            player.setName(names.get(i));
            player.setTodayScore(todayScores.get(i));
            player.setHandicap(handicaps.get(i));
            players.add(player);
        }

        List<GameResult> results = gameService.calculateGameResults(players, gameFee);
        model.addAttribute("results", results);

        return "gameResult";
    }

    // 날짜로 조회하는 메서드 (예시)
    @GetMapping("/results")
    public String getResultsByDate(@RequestParam("date") String date, Model model) {
        // 특정 날짜의 결과를 조회 (실제 구현에서는 DB 조회)
        List<GameResult> results = new ArrayList<>();
        // 결과를 예시로 추가
        results.add(new GameResult("권용석", 1, 8000));
        results.add(new GameResult("박준영", 2, -8000));

        model.addAttribute("results", results);
        model.addAttribute("gameDate", date);
        return "gameResult";
    }
}
