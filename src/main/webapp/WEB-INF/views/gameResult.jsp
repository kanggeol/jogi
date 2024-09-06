<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
  <title>결과 보기</title>
</head>
<body>
<h1>게임 결과</h1>
<table border="1">
  <tr>
    <th>순위</th>
    <th>이름</th>
    <th>오늘의 타수</th>
    <th>핸디</th>
    <th>금액</th>
    <th>삭제</th>
  </tr>
  <c:forEach var="result" items="${gameResults}">
    <tr>
      <td>${result.rank}</td>
      <td>${result.playerName}</td>
      <td>${result.todayScore}</td>
      <td>${result.handicap}</td>
      <td>${result.calculatedAmount}</td>
      <td><a href="DeleteResultServlet?resultId=${result.resultId}">삭제</a></td>
    </tr>
  </c:forEach>
</table>
</body>
</html>
