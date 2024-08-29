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
      <th>타수</th>
      <th>핸디</th>
      <th>금액</th>
      <c:if test="${showDeleteButton}">
        <th>삭제</th>
      </c:if>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="result" items="${results}" varStatus="status">
      <tr>
        <td>${status.index + 1}</td>
        <td>${result.playerName}</td>
        <td>${result.originalScore}</td>
        <td>${result.handicap}</td>
        <td>${result.calculatedAmount}원</td>
        <c:if test="${showDeleteButton}">
          <td>
            <form action="/deleteGameResult" method="post" style="display:inline;">
              <input type="hidden" name="resultId" value="${result.resultId}">
              <input type="hidden" name="date" value="${gameDate}">
              <button type="submit" class="btn btn-danger btn-sm">삭제</button>
            </form>
          </td>
        </c:if>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  <a href="/" class="btn btn-primary mt-3">총금액 확인</a>
</div>
</body>
</html>
