package com.dailystudy.jogi_golf.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Player {
    private String playerName;
    private int originalScore;
    private int todayScore; //핸디 적용한 스코어
    private int handicap;
}
