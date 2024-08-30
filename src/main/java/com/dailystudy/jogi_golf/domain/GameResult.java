package com.dailystudy.jogi_golf.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class GameResult {
    private int gameId;
    private int resultId;
    private String playerName;
    private int originalScore;
    private int todayScore; //핸디 적용한 스코어
    private int handicap;
    private int rank;
    private int calculatedAmount;
}
