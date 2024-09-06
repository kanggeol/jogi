<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
  <title>결과 조회하기</title>
</head>
<body>
<h1>결과 조회하기</h1>
<table border="1">
  <tr>
    <th>날짜</th>
    <th>결과</th>
  </tr>
  <c:forEach var="game" items="${games}">
    <tr>
      <td>${game.gameDate}</td>
      <td>
        <c:choose>
          <c:when test="${game.hasResults}">
            <a href="GameResultServlet?gameId=${game.gameId}">결과 보기</a>
          </c:when>
          <c:otherwise>
            <a href="GameFormServlet?gameId=${game.gameId}">결과 입력</a>
          </c:otherwise>
        </c:choose>
      </td>
    </tr>
  </c:forEach>
</table>
</body>
</html>
