<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <title>게임 선택</title>
</head>
<body>
<div class="app-bar">게임 선택</div>

<div class="container">
  <div class="app-card">
    <h5 class="text-center mb-4">${date} - 게임 목록</h5>
    <c:choose>
      <c:when test="${empty games}">
        <p class="text-center">이 날짜의 게임이 없습니다.</p>
      </c:when>
      <c:otherwise>
        <table class="table table-bordered result-table games-table">
          <thead>
          <tr>
            <th class="games-col-num">게임 번호</th>
            <th class="games-col-player">참가자</th>
            <th class="games-col-status">상태</th>
            <th class="games-col-action">선택</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="game" items="${games}" varStatus="status">
            <tr>
              <td class="games-col-num games-cell-content">${status.index + 1}</td>
              <td class="games-col-player games-cell-content">${game.playerCount}명</td>
              <td class="games-col-status games-cell-content">
                <c:choose>
                  <c:when test="${game.hasResults}">
                    <span class="badge badge-success">계산 완료</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-info">계산 대기</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="games-col-action games-cell-content">
                <a href="/results?gameId=${game.gameId}" class="btn btn-games-action">조회</a>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </div>

  <div class="btn-area">
    <a href="/dateList" class="btn btn-secondary btn-action">연도 다시 선택</a>
    <a href="/" class="btn btn-primary btn-action">홈으로</a>
  </div>
</div>
</body>
</html>
