package com.dailystudy.jogi_golf.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class PlayerTotal {
    private String playerName;
    private Integer totalAmount;
    private int participationCount;
}
