<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <title>총금액 순위</title>
</head>
<body style="margin: 20px">
<div class="container">
    <h1>플레이어 총 금액</h1>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>순위</th>
            <th>플레이어 이름</th>
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
    <a href="/gameForm" class="btn btn-primary mt-3">기록 저장하기</a>
</div>
</body>
</html>
