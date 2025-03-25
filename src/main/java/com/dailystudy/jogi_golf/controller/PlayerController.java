package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.domain.GameResult;
import com.dailystudy.jogi_golf.domain.Player;
import com.dailystudy.jogi_golf.dto.CalculationRequest;
import com.dailystudy.jogi_golf.mapper.PlayerMapper;
import com.dailystudy.jogi_golf.service.GameService;
import com.dailystudy.jogi_golf.service.PlayerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RestController
public class PlayerController {

    @Autowired
    private GameService gameService;
    @Autowired
    private PlayerService playerService;

    @Autowired
    private PlayerMapper playerMapper;

//    @GetMapping("/search-player")
//    @ResponseBody
//    public ResponseEntity<Map<String, Object>> searchPlayer(@RequestParam String playerName) {
//        Map<String, Object> response = new HashMap<>();
//        Optional<Player> player = playerService.findByName(playerName);
//
//        if (player.isPresent()) {
//            response.put("exists", true);  // 플레이어가 존재하면
//            response.put("handicap", player.get().getHandicap());  // 핸디캡 반환
//            response.put("name", player.get().getPlayerName());  // 플레이어 이름 반환
//        } else {
//            response.put("exists", false);  // 플레이어가 존재하지 않으면
//            response.put("handicap", 0);  // 기본 핸디캡 0 반환
//        }
//        return ResponseEntity.ok(response);  // 응답 반환
//    }

    @GetMapping("/search-player-list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> searchPlayerList(@RequestParam String playerName) {
        Map<String, Object> response = new HashMap<>();
        List<Player> players = playerService.findPlayersByName(playerName);

        List<Map<String, Object>> playerList = players.stream()
            .map(player -> {
                Map<String, Object> map = new HashMap<>();
                map.put("name", player.getPlayerName());
                map.put("handicap", player.getHandicap());
                return map;
            })
            .collect(Collectors.toList());

        response.put("players", playerList);
        return ResponseEntity.ok(response);
    }

//    @GetMapping("/player-handicap")
//    public ResponseEntity<Map<String, Object>> getPlayerHandicap(@RequestParam("playerName") String playerName) {
//        Map<String, Object> response = new HashMap<>();
//        gameService.ensurePlayerExists(playerName); // Ensure player exists
//        int handicap = gameService.getPlayerHandicap(playerName);
//        response.put("exists", true); // Assumes player exists
//        response.put("handicap", handicap);
//        return ResponseEntity.ok(response);
//    }

//    @PostMapping("/update-handicap")
//    @ResponseBody
//    public Map<String, Object> updateHandicap(@RequestParam String playerName, @RequestParam int handicap) {
//        Map<String, Object> response = new HashMap<>();
//
//        try {
//            playerMapper.updateHandicap(playerName, handicap);
//            response.put("success", true);
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.put("success", false);
//        }
//
//        return response;
//    }

    @PostMapping("/calculate")
    public ResponseEntity<Map<String, Object>> calculate(@RequestBody CalculationRequest request) {
        System.out.println("=======request "+request);
        List<Player> players = new ArrayList<>();
        for (int i = 0; i < request.getNames().size(); i++) {
            Player player = new Player();
            player.setPlayerName(request.getNames().get(i));
            player.setTodayScore(request.getTodayScores().get(i));
            player.setHandicap(request.getHandicaps().get(i));
            players.add(player);
        }

        // 게임 결과 계산
        int gameFee = 2000;
        List<GameResult> results = gameService.calculateGameResults(players, gameFee);

        // 핸디캡 조정 및 업데이트
        for (int i = 0; i < results.size(); i++) {
            GameResult result = results.get(i);
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

            // 결과 수정
            result.setResultId(request.getResultId().get(i)); // 각 결과에 맞는 resultId 설정
            gameService.updateGameResult(result);
        }

        // Prepare the response
        Map<String, Object> response = new HashMap<>();
        response.put("results", results);
        response.put("gameDate", request.getGameDate());

        return ResponseEntity.ok(response);
    }

}
