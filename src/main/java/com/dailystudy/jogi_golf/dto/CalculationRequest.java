package com.dailystudy.jogi_golf.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
@AllArgsConstructor
@NoArgsConstructor
@Data
public class CalculationRequest {
    private int gameId;
    private List<Integer> resultId;
    private List<String> names;
    private List<Integer> originalScore;
    private List<Integer> handicaps;
    private String gameDate;
}
