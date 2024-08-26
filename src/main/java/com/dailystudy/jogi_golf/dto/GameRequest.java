package com.dailystudy.jogi_golf.dto;

import com.dailystudy.jogi_golf.domain.Player;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class GameRequest {
    private List<Player> players;
    private int gameFee;
}
