package com.dailystudy.jogi_golf.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class User {
    @NotBlank
    private String username; //id
    @NotBlank
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;
    private int MNumber;
    private String MId;
    private String MName;
    private String ACCode;
    private String MType;
    private String MSex;
    private String MOPosition;
    private String MMobile;
    private String MAddress;
    private LocalDate MJoinDate;
    private String duty;
    private String MTeacherType;
    private String SBName;
    private String ACName;
    private String smsDatabaseName;
    private String ACPhone;
    private String aliasName;
    private boolean useNormalMessage;
    private boolean useKakaoMessage;
    private String categoryId;
    private String website;
    private String phoneNumberForUnsubscribeSMS;
    private String academyCategoryCode;
    private String academyCategoryName;
    private String assignClassDecisionDay;
    private String academyCategoryPhone;
    private String academyCompanyId;
    private String BuildingId;
    private String photo;
    private int selectISNumber; // 선택한 반 정보
    private boolean notify; //알림
}
