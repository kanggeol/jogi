package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.Player;
import com.dailystudy.jogi_golf.domain.PlayerTotal;
import com.dailystudy.jogi_golf.service.GameService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
@Controller
public class GameController {
    private final GameService gameService;

    public GameController(GameService gameService) {
        this.gameService = gameService;
    }

    @GetMapping("/")
    public String index(Model model) {
        List<PlayerTotal> playerTotals = gameService.getPlayerTotals();
        model.addAttribute("playerTotals", playerTotals);
        return "index";
    }

    @GetMapping("/gameForm")
    public String showGameForm(Model model) {
        // 현재 날짜를 yyyy-MM-dd 형식으로 포맷
        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String formattedDate = today.format(formatter);

        model.addAttribute("today", formattedDate);
        return "gameForm";
    }

    @PostMapping("/calculate")
    public String calculate(
            @RequestParam("gameFee") int gameFee,
            @RequestParam("names") List<String> names,
            @RequestParam("todayScores") List<Integer> todayScores,
            @RequestParam("handicaps") List<Integer> handicaps,
            @RequestParam("gameDate") String gameDate,
            Model model) {

        List<Player> players = new ArrayList<>();
        for (int i = 0; i < names.size(); i++) {
            Player player = new Player();
            player.setPlayerName(names.get(i));
            player.setTodayScore(todayScores.get(i));
            player.setHandicap(handicaps.get(i));
            players.add(player);
        }

        // 게임 결과 계산
        List<GameResult> results = gameService.calculateGameResults(players, gameFee);
        // 결과 저장
        int gameId = gameService.saveGameId(gameDate);
        for (GameResult result : results) {
            result.setGameId(gameId);
            gameService.saveGameResult(result);
        }

        model.addAttribute("results", results);
        return "gameResult";
    }

    @GetMapping("/results")
    public String getResultsByDate(@RequestParam("date") String date, Model model) {
        List<GameResult> results = gameService.getGameResultsByDate(date);
        System.out.println("======results "+results);
        model.addAttribute("results", results);
        model.addAttribute("gameDate", date);
        model.addAttribute("showDeleteButton", true);
        return "gameResult";
    }

    @PostMapping("/deleteGameResult")
    public String deleteGameResult(@RequestParam("resultId") String resultId, @RequestParam("date") String date) {
        gameService.deleteGameResult(resultId);
        return "redirect:/results?date="+date;
    }

    @GetMapping("/dateList")
    public String showDateList(Model model) {
        List<String> dates = gameService.getAllSavedDates(); // DB에서 저장된 날짜 목록을 가져오는 메소드
        model.addAttribute("dates", dates);
        return "dateList";
    }
}
