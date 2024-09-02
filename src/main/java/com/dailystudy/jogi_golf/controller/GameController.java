package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.Player;
import com.dailystudy.jogi_golf.domain.PlayerTotal;
import com.dailystudy.jogi_golf.service.GameService;
import com.dailystudy.jogi_golf.service.PlayerService;
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
    private final PlayerService playerService;

    public GameController(GameService gameService, PlayerService playerService) {
        this.gameService = gameService;
        this.playerService = playerService;
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

        // 핸디캡 조정 및 업데이트
        for (GameResult result : results) {
            int calculatedAmount = Math.abs(result.getCalculatedAmount());
            int adjustment = 0;

            if (calculatedAmount > 100000) {
                adjustment = 4;
            } else if (calculatedAmount > 50000) {
                adjustment = 3;
            } else if (calculatedAmount > 10000) {
                adjustment = 2;
            } else {
                adjustment = 0;
            }

            // 핸디캡을 조정 (양수 금액이면 핸디캡 감소, 음수 금액이면 핸디캡 증가)
            int newHandicap = result.getHandicap() + (result.getCalculatedAmount() > 0 ? -adjustment : adjustment);
            playerService.updateHandicap(result.getPlayerName(), newHandicap);
        }

        // 결과 저장
        int gameId = gameService.saveGameId(gameDate);
        for (GameResult result : results) {
            result.setGameId(gameId);
            gameService.saveGameResult(result);
        }

        model.addAttribute("results", results);
        model.addAttribute("gameDate", gameDate);
        return "gameResult";
    }

    @GetMapping("/results")
    public String getResultsByDate(@RequestParam("date") String date, Model model) {
        List<GameResult> results = gameService.getGameResultsByDate(date);
        model.addAttribute("results", results);
        model.addAttribute("gameDate", date);
        model.addAttribute("showDeleteButton", true);
        return "gameResult";
    }

    @PostMapping("/deleteGameResult")
    public String deleteGameResult(@RequestParam("resultId") String resultId, @RequestParam("date") String date) {
        gameService.deleteGameResult(resultId);
        return "redirect:/results?date=" + date;
    }

    @GetMapping("/dateList")
    public String showDateList(Model model) {
        List<String> dates = gameService.getAllSavedDates();
        model.addAttribute("dates", dates);
        return "dateList";
    }
}
