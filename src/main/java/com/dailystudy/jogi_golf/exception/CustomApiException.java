package com.dailystudy.jogi_golf.exception;

public class CustomApiException extends RuntimeException {
    private static final long serialVersionUID = -2600527452857965211L;


    public CustomApiException(String message) {
        super(message);
    }

}
