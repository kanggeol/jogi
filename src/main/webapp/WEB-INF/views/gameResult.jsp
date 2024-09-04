<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <title>게임 결과</title>
</head>
<body>
<div class="container">
  <h1>게임 결과</h1>
  <p><strong>날짜:</strong> ${gameDate}</p>
  <form action="/calculate" method="post">
    <input type="hidden" name="gameId" value="${gameId}">
    <table class="table table-bordered">
      <thead>
      <tr>
        <th>이름</th>
        <th>오늘의 타수</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="player" items="${players}">
        <tr>
          <td>${player.playerName}</td>
          <td>
            <input type="hidden" name="names" value="${player.playerName}">
            <input type="number" name="todayScores" class="form-control" required>
            <input type="hidden" name="handicaps" value="${player.handicap}">
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
    <button type="submit" class="btn btn-primary">결과 계산하기</button>
  </form>
</div>
</body>
</html>
