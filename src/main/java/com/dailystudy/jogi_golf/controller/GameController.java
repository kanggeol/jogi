package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.Player;
import com.dailystudy.jogi_golf.domain.PlayerTotal;
import com.dailystudy.jogi_golf.service.GameService;
import com.dailystudy.jogi_golf.service.PlayerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
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

    @PostMapping("/save")
    public String save(
            @RequestParam("gameFee") int gameFee,
            @RequestParam("names") List<String> names,
            @RequestParam("handicaps") List<Integer> handicaps,
            @RequestParam("gameDate") String gameDate,
            Model model) {

        List<Player> players = new ArrayList<>();
        for (int i = 0; i < names.size(); i++) {
            Player player = new Player();
            player.setPlayerName(names.get(i));
            player.setHandicap(handicaps.get(i));
            players.add(player);
        }

        // 게임 저장
        int gameId = gameService.saveGameId(gameDate,gameFee);
        Map<String, Object> map = new HashMap<>();
        for (Player player : players) {
            map.put("gameId",gameId);
            map.put("playerName",player.getPlayerName());
            map.put("handicap", player.getHandicap());
            gameService.saveGame(map);
        }
        model.addAttribute("gameDate", gameDate);
        return "redirect:/results?date=" + gameDate;
    }

    @GetMapping("/results")
    public String getResultsByDate(@RequestParam("date") String date, Model model) {
        List<GameResult> results = gameService.getGameResultsByDate(date);

        model.addAttribute("results", results);
        model.addAttribute("gameDate", date);

        boolean deleteButton;

        if (results != null && !results.isEmpty() && results.get(0).getRank() == 0) {
            deleteButton = false;
        } else {
            deleteButton = true;
        }

        model.addAttribute("showDeleteButton", deleteButton);
        return "gameResult";
    }

    @PostMapping("/deleteGameResult")
    public String deleteGameResult(@RequestParam("resultId") String resultId, @RequestParam("date") String date) {
        gameService.deleteGameResult(resultId);
        return "redirect:/results?date=" + date;
    }

    @PostMapping("/deleteSelectedGamePlayers")
    public ResponseEntity<?> deleteSelectedGamePlayers(@RequestBody Map<String, List<Long>> request) {
        List<Long> resultIds = request.get("resultIds");

        if (resultIds == null || resultIds.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "삭제할 플레이어 ID가 없습니다."));
        }

        boolean isDeleted = gameService.deleteSelectedGamePlayers(resultIds);

        if (isDeleted) {
            return ResponseEntity.ok(Map.of("success", true));
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", "삭제 중 오류가 발생했습니다."));
        }
    }

    @GetMapping("/dateList")
    public String showDateList(Model model) {
        List<String> dates = gameService.getAllSavedDates();
        model.addAttribute("dates", dates);
        return "dateList";
    }
}
