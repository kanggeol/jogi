package com.dailystudy.jogi_golf.exception;

import com.dailystudy.jogi_golf.dto.CMResponse;
import com.dailystudy.jogi_golf.util.Script;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;

@RestController
@ControllerAdvice
public class ControllerExceptionHandler {
    @ExceptionHandler(CustomValidationException.class)
    public String validationException(CustomValidationException e) {
        if (e.getErrorMap() == null) {
            return Script.back(e.getMessage());
        } else {
            return Script.back(e.getErrorMap().toString());
        }
    }

    @ExceptionHandler(CustomException.class)
    public String Exception(CustomException e) {
        return Script.back(e.getMessage());
    }

    @ExceptionHandler(CustomValidationApiException.class)
    public ResponseEntity<CMResponse<?>> validationException(CustomValidationApiException e) {
        return new ResponseEntity<>(new CMResponse<>(-1, e.getMessage(), e.getErrorMap()), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(CustomApiException.class)
    public ResponseEntity<CMResponse<?>> apiException(CustomApiException e) {
        return new ResponseEntity<>(new CMResponse<>(-1, e.getMessage(), null), HttpStatus.BAD_REQUEST);
    }
}
