package com.dailystudy.jogi_golf.controller;

import com.dailystudy.jogi_golf.domain.Player;
import com.dailystudy.jogi_golf.service.PlayerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class PlayerController {

    @Autowired
    private PlayerService playerService;

    @PostMapping("/savePlayers")
    public String savePlayers(@RequestParam("gameId") int gameId,
                              @RequestParam("playerNames") List<String> playerNames,
                              @RequestParam("handicaps") List<Integer> handicaps) {
        playerService.savePlayers(gameId, playerNames, handicaps);
        return "redirect:/gameResult?gameId=" + gameId;
    }

    @GetMapping("/gameForm")
    public String gameForm(int gameId, Model model) {
        List<Player> players = playerService.getPlayersByGameId(gameId);
        model.addAttribute("players", players);
        return "gameForm";
    }

    @PostMapping("/updatePlayer")
    public String updatePlayer(Player player) {
        playerService.updatePlayer(player);
        return "redirect:/gameResult?gameId=" + player.getGameId();
    }
}