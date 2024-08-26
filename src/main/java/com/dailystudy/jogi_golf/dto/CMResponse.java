package com.dailystudy.jogi_golf.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class CMResponse<T> {
    private int code;
    private String message;
    private T data;
}