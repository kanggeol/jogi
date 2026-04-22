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

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@Controller
public class GameController {
    private final GameService gameService;
    private final PlayerService playerService;

    public GameController(GameService gameService, PlayerService playerService) {
        this.gameService = gameService;
        this.playerService = playerService;
    }

    @GetMapping({"/", "/year"})
    public String index(@RequestParam(value = "year", required = false) String year, Model model) {
        // year 값이 null이면 올해로 설정
        if (year == null) {
            year = "thisYear";
        }

        // 필터링된 플레이어 총합 데이터를 가져옵니다.
        List<PlayerTotal> playerTotals = gameService.getPlayerTotals(year);

        // 모델에 playerTotals 데이터를 추가하여 JSP에서 사용할 수 있도록 전달합니다.
        model.addAttribute("playerTotals", playerTotals);
        model.addAttribute("selectedYear", year);  // 선택된 년도를 모델에 추가
        model.addAttribute("currentYear", LocalDate.now().getYear());  // 현재 연도 추가

        return "index";  // index.jsp로 리턴
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
            @RequestParam("gameDate") String gameDate,
            HttpServletRequest request,
            Model model) {

        // 게임 저장 (플레이어 없이도 게임 생성 가능)
        int gameId = gameService.saveGameId(gameDate, gameFee);

        // 플레이어 파라미터 가져오기
        String[] names = request.getParameterValues("names");
        String[] handicaps = request.getParameterValues("handicaps");

        // 플레이어가 있으면 저장
        if (names != null && names.length > 0) {
            for (int i = 0; i < names.length; i++) {
                String playerName = names[i].trim();
                if (!playerName.isEmpty() && i < handicaps.length) {
                    int handicap = Integer.parseInt(handicaps[i]);
                    Player player = new Player();
                    player.setPlayerName(playerName);
                    player.setHandicap(handicap);
                    playerService.updateHandicap(playerName, handicap);

                    Map<String, Object> map = new HashMap<>();
                    map.put("gameId", gameId);
                    map.put("playerName", playerName);
                    map.put("handicap", handicap);
                    gameService.saveGame(map);
                }
            }
        }

        model.addAttribute("gameDate", gameDate);
        return "redirect:/results?gameId=" + gameId;
    }

    @GetMapping("/results")
    public String getResultsByDate(
            @RequestParam(value = "gameId", required = false) Integer gameIdParam,
            @RequestParam(value = "date", required = false) String date,
            Model model) {
        List<GameResult> results;
        Integer gameId;
        String gameDate;

        // gameId 우선, 없으면 date 사용
        if (gameIdParam != null) {
            // 게임이 실제로 존재하는지 확인
            if (!gameService.isGameExists(gameIdParam)) {
                return "redirect:/";
            }
            gameId = gameIdParam;
            results = gameService.getGameResultsByGameId(gameId);
            // gameDate는 첫 번째 결과에서 가져오거나 별도의 메서드 필요
            if (results != null && !results.isEmpty()) {
                gameDate = results.get(0).getGameDate();
            } else {
                gameDate = "";
            }
        } else if (date != null) {
            results = gameService.getGameResultsByDate(date);
            gameDate = date;
            gameId = gameService.getGameIdByDate(date);
        } else {
            return "redirect:/";
        }

        model.addAttribute("results", results);
        model.addAttribute("gameDate", gameDate);
        model.addAttribute("gameId", gameId);

        boolean deleteButton;

        // results가 비어있으면 플레이어 추가 가능 (deleteButton = false)
        // results가 있으면 rank == 0인지 확인
        if (results == null || results.isEmpty()) {
            deleteButton = false;  // 플레이어 추가 폼 표시
        } else if (results.get(0).getRank() == 0) {
            deleteButton = false;  // 아직 계산 안 함, 플레이어 추가 폼 표시
        } else {
            deleteButton = true;   // 계산 완료, 삭제 버튼 표시
        }

        model.addAttribute("showDeleteButton", deleteButton);
        return "gameResult";
    }

    @PostMapping("/deleteGameResult")
    public String deleteGameResult(@RequestParam("resultId") String resultId, @RequestParam("date") String date) {
        gameService.deleteGameResult(resultId);
        return "redirect:/results?date=" + date;
    }

    @PostMapping("/addPlayer")
    public String addPlayer(
            @RequestParam("gameId") int gameId,
            @RequestParam("playerName") String playerName,
            @RequestParam("handicap") int handicap,
            @RequestParam("gameDate") String gameDate) {

        playerService.updateHandicap(playerName, handicap);
        Map<String, Object> map = new HashMap<>();
        map.put("gameId", gameId);
        map.put("playerName", playerName);
        map.put("handicap", handicap);
        gameService.saveGame(map);
        return "redirect:/results?gameId=" + gameId;
    }

    @PostMapping("/deleteSelectedGamePlayers")
    public ResponseEntity<?> deleteSelectedGamePlayers(@RequestBody Map<String, Object> request) {
        List<Object> resultIdsRaw = (List<Object>) request.get("resultIds");
        Integer gameId = null;

        Object gameIdObj = request.get("gameId");
        if (gameIdObj instanceof Integer) {
            gameId = (Integer) gameIdObj;
        } else if (gameIdObj instanceof Double) {
            gameId = ((Double) gameIdObj).intValue();
        } else if (gameIdObj instanceof String) {
            gameId = Integer.parseInt((String) gameIdObj);
        }

        if (resultIdsRaw == null || resultIdsRaw.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "삭제할 플레이어 ID가 없습니다."));
        }

        // String을 Long으로 변환
        List<Long> resultIds = new ArrayList<>();
        for (Object id : resultIdsRaw) {
            if (id instanceof String) {
                resultIds.add(Long.parseLong((String) id));
            } else if (id instanceof Number) {
                resultIds.add(((Number) id).longValue());
            }
        }

        boolean isDeleted = gameService.deleteSelectedGamePlayers(resultIds);

        if (isDeleted) {
            if (gameId != null) {
                gameService.recalculateGameResults(gameId);
            }
            return ResponseEntity.ok(Map.of("success", true));
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", "삭제 중 오류가 발생했습니다."));
        }
    }

    @GetMapping("/dateList")
    public String showYearList(Model model) {
        List<String> years = gameService.getAllYears();
        model.addAttribute("years", years);
        return "yearList";
    }

    @GetMapping("/dateListByYear")
    public String showDateListByYear(@RequestParam("year") String year, Model model) {
        List<String> dates = gameService.getSavedDatesByYear(year);
        model.addAttribute("dates", dates);
        model.addAttribute("year", year);
        return "dateList";
    }

    @GetMapping("/gamesByDate")
    public String showGamesByDate(@RequestParam("date") String date, Model model) {
        List<Integer> gameIds = gameService.getGameIdsByDate(date);

        // 각 게임의 정보를 담기 위해 Map 리스트 생성
        List<Map<String, Object>> games = new ArrayList<>();
        for (Integer gameId : gameIds) {
            List<GameResult> results = gameService.getGameResultsByGameId(gameId);
            Map<String, Object> gameInfo = new HashMap<>();
            gameInfo.put("gameId", gameId);
            gameInfo.put("date", date);
            gameInfo.put("playerCount", results.size());
            gameInfo.put("hasResults", !results.isEmpty() && results.get(0).getRank() > 0);
            games.add(gameInfo);
        }

        model.addAttribute("date", date);
        model.addAttribute("games", games);
        return "gamesByDate";
    }

    @PostMapping("/deleteGame")
    public ResponseEntity<?> deleteGame(@RequestParam("gameId") int gameId) {
        try {
            gameService.deleteGame(gameId);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", "게임 삭제 실패"));
        }
    }
}
