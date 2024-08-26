package com.dailystudy.jogi_golf.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class GameResult {
    private String gameDate;
    private String playerName;
    private int rank;
    private int calculatedAmount;
}
