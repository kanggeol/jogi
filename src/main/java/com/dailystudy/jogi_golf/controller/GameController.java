package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.Player;
import com.dailystudy.jogi_golf.domain.PlayerTotal;
import com.dailystudy.jogi_golf.service.GameService;
import com.dailystudy.jogi_golf.service.PlayerService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @GetMapping("/createGame")
    public String createGame() {
        return "createGame";
    }

    @PostMapping("/saveGame")
    public String saveGame(@RequestParam("gameDate") String gameDate,
                           @RequestParam("gameFee") int gameFee, Model model) {
        int gameId = gameService.createGame(gameDate, gameFee);
        model.addAttribute("gameId", gameId);
        return "redirect:/gameForm?gameId=" + gameId;
    }

    @PostMapping("/savePlayers")
    public String savePlayers(@RequestParam("gameId") int gameId,
                              @RequestParam("playerNames") List<String> playerNames,
                              @RequestParam("handicaps") List<Integer> handicaps) {
        System.out.println("=======gameId "+gameId);
        playerService.savePlayers(gameId, playerNames, handicaps);
        return "redirect:/gameResult?gameId=" + gameId;
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

    @GetMapping("/player-handicap")
    public ResponseEntity<Map<String, Object>> getPlayerHandicap(@RequestParam("playerName") String playerName) {
        Map<String, Object> response = new HashMap<>();
        gameService.ensurePlayerExists(playerName); // Ensure player exists
        int handicap = gameService.getPlayerHandicap(playerName);
        response.put("exists", true); // Assumes player exists
        response.put("handicap", handicap);
        return ResponseEntity.ok(response);
    }

//    @PostMapping("/saveGame")
//    public String saveGame(
//            @RequestParam("gameFee") int gameFee,
//            @RequestParam("names") List<String> names,
//            @RequestParam("handicaps") List<Integer> handicaps,
//            @RequestParam("gameDate") String gameDate,
//            Model model) {
//
//        List<GameResult> results = new ArrayList<>();
//        int gameId = gameService.saveGameId(gameDate);
//
//        for (int i = 0; i < names.size(); i++) {
//            GameResult result = new GameResult();
//            result.setGameId(gameId);
//            result.setPlayerName(names.get(i));
//            result.setHandicap(handicaps.get(i));
//            result.setOriginalScore(0); // Assuming default as 0 if not provided
//            result.setTodayScore(0); // Assuming default as 0 if not provided
//            result.setRank(0); // Assuming default as 0 if not provided
//            result.setCalculatedAmount(0); // Assuming default as 0 if not provided
//            results.add(result);
//        }
//
//        // 게임 결과 저장
//        for (GameResult result : results) {
//            gameService.saveGameResult(result);
//        }
//
//        model.addAttribute("gameId", gameId);
//        model.addAttribute("gameDate", gameDate);
//        return "gameResult";
//    }

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
