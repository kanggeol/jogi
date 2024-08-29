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
  <h1>계산 결과</h1>
  <p><strong>날짜:</strong> ${gameDate}</p>
  <table class="table table-bordered">
    <thead>
    <tr>
      <th>순위</th>
      <th>이름</th>
      <th>금액</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="result" items="${results}">
      <tr>
        <td>${result.rank}</td>
        <td>${result.playerName}</td>
        <td>${result.calculatedAmount}원</td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
<%--  <a href="/gameForm" class="btn btn-primary mt-3">다시 계산하기</a>--%>
  <form action="/results" method="get" class="mt-3">
    <div class="form-group">
      <label for="date">다른 날짜 조회</label>
      <input type="date" id="date" name="date" class="form-control" required>
    </div>
    <button type="submit" class="btn btn-info">조회하기</button>
  </form>
  <a href="/" class="btn btn-primary mt-3">총금액 확인</a>
</div>
</body>
</html>
