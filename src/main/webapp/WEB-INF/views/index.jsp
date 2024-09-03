<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <title>깊생골프</title>
</head>
<body style="margin: 20px">
<div class="container">
    <h1>깊생골프</h1>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>순위</th>
            <th>이름</th>
            <th>참여</th>
            <th>총 금액</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="player" items="${playerTotals}" varStatus="status">
            <tr>
                <td>${status.index + 1}</td>
                <td>${player.playerName}</td>
                <td>${player.participationCount}회</td>
                <td>${player.totalAmount}원</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <a href="/gameForm" class="btn btn-primary mt-3">게임 생성하기</a>
    <button type="button" class="btn btn-info mt-3" onclick="location.href='/dateList'">결과 조회하기</button>
</div>

<footer style="position: fixed; bottom: 10px; right: 10px;">
    <p>since 2024.8.29<br>ver 1.2</p>
</footer>

</body>
</html>
