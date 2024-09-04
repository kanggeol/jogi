package com.dailystudy.jogi_golf.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Game {
    private int gameId;
    private String gameDate;
    private int gameFee;
}
