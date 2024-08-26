package com.dailystudy.jogi_golf.exception;

import java.util.Map;

public class CustomValidationApiException extends RuntimeException {

    private static final long serialVersionUID = 8323148482453705296L;
    private Map<String, String> errorMap;

    public CustomValidationApiException(String message) {
        super(message);
    }

    public CustomValidationApiException(String message, Map<String, String> errorMap) {
        super(message);
        this.errorMap = errorMap;
    }

    public Map<String, String> getErrorMap() {
        return errorMap;
    }
}