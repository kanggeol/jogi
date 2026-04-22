# CLAUDE.md

이 파일은 Claude Code(claude.ai/code)가 이 저장소의 코드를 작업할 때 참고해야 할 가이드를 제공합니다.

---

## 프로젝트 개요

**Jogi Golf**는 골프 게임의 점수 기록 및 관리 애플리케이션입니다.
플레이어가 게임 점수를 입력하면 핸디가 적용되어 네트 점수가 계산되고, 점수 차이에 따라 수익/손실 금액이 산정됩니다. 또한 연도별 플레이어 통계를 추적하고 과거 게임 데이터를 관리합니다.

---

## 기술 스택

- **Backend**: Spring Boot 2.6.7, Java 11
- **Data Access**: MyBatis 2.2.0 + MySQL
- **View Layer**: JSP
- **Build Tool**: Gradle 8.8 (Gradle Wrapper 사용)
- **Utilities**: Lombok, log4jdbc, Jackson, Apache Commons

---

## 아키텍처

애플리케이션은 전형적인 3계층 아키텍처를 따릅니다.

### 1. Controller 계층
`src/main/java/.../controller/`

HTTP 요청을 처리하고 MVC 뷰를 관리합니다.

- `GameController`
  - 게임 생성
  - 결과 화면 표시
  - 연도별 날짜 필터링

- `PlayerController`
  - 플레이어 데이터 관리

---

### 2. Service 계층
`src/main/java/.../service/`

비즈니스 로직을 담당합니다.

- `GameService`
  - 게임 결과 계산 (핸디 적용, 순위 계산, 금액 계산)
  - 게임 데이터 저장

- `PlayerService`
  - 플레이어 핸디 업데이트 관리

---

### 3. Mapper 계층
`src/main/java/.../mapper/`  
`src/main/resources/mapper/`

MyBatis를 사용하여 데이터베이스 작업을 수행합니다.

- `GameResultMapper`
  - 게임 결과 조회/저장
  - 플레이어 누적 통계 조회
  - 날짜 이력 조회

- `PlayerMapper`
  - 플레이어 레코드 관리

---

### 4. 도메인 모델
`src/main/java/.../domain/`

- `Player`
- `Game`
- `GameResult`
- `PlayerTotal`

---

### 5. View 레이어
`src/main/webapp/WEB-INF/views/`

- `index.jsp`
- `game form`
- `game results`
- `date list`

---

## 핵심 로직

`GameService.calculateGameResults()`가 핵심 알고리즘입니다.

이 메서드는 다음을 수행합니다:

1. 핸디를 점수에 적용
2. 플레이어 순위 계산
3. 플레이어 간 점수 차이에 따른 금액 계산

---

## 설정 (Configuration)

Spring Profile을 사용합니다.

### local (개발 환경)
- MySQL: `210.122.35.31:3306`
- 설정 파일: `application-local.yml`

### prod (운영 환경)
- 설정 파일: `application-prod.yml`

---

### JSP View 설정 (`application-local.yml`)

- Prefix: `/WEB-INF/views/`
- Suffix: `.jsp`

---

### 로컬 실행 포트

- `8081`

---

### MyBatis Mapper 자동 스캔 경로

```properties
classpath:mapper/*.xml
```

---

## 자주 사용하는 명령어

### 빌드 및 패키징

```bash
./gradlew build          # 전체 빌드 (컴파일, 테스트, WAR 생성)
./gradlew bootRun        # 로컬 실행
./gradlew clean          # 빌드 산출물 삭제
```

---

### 테스트 실행

```bash
./gradlew test                       # 전체 테스트 실행
./gradlew test --tests ClassName     # 특정 테스트 클래스 실행
```

---

### Gradle 작업 확인

```bash
./gradlew tasks          # 사용 가능한 작업 목록 확인
./gradlew dependencies   # 의존성 트리 확인
```

---

## 데이터베이스 설정

- MySQL 실행 정보
  - Host: `210.122.35.31:3306`
  - User: `rlvdms`

- 애플리케이션 실행 전 스키마가 미리 생성되어 있어야 합니다.

---

## 주요 파일

- 메인 클래스  
  `src/main/java/.../JogiGolfApplication.java`

- 빌드 설정  
  `build.gradle`

- 프로파일 설정
  - `application.yml`
  - `application-local.yml`
  - `application-prod.yml`

- MyBatis 설정  
  `mybatis-config.xml`

- SQL 로깅 설정  
  `log4jdbc.log4j2.properties`

- 로그 설정  
  `logback-spring.xml`

---

## 참고 사항

- 커밋 이력은 한국어(KR 로케일) 기반입니다.
- MySQL Connector: `5.1.48` (MySQL 5.6.13과 호환)
- 데이터베이스 인코딩: `EUC-KR`
- zero date는 null로 변환 설정
- Lombok 사용
  - `@Data`
  - `@AllArgsConstructor`
  - `@NoArgsConstructor`
- WAR 파일명: `jogigolf.war` (`build.gradle`에 설정)
- SQL 로그는 log4jdbc를 통해 확인 가능
