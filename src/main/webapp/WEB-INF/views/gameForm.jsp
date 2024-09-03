<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <title>Game Calculator</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/main.js" defer></script>
</head>
<body>
<div class="container" style="padding: 20px">
    <form action="/saveGame" method="post">
        <div class="form-group">
            <label for="gameDate">날짜</label>
            <input type="date" class="form-control" id="gameDate" name="gameDate" value="${today}" required>
        </div>
        <div class="form-group">
            <label for="gameFee">타당 게임비</label>
            <input type="number" class="form-control" id="gameFee" name="gameFee" value="2000" required>
        </div>
        <div class="form-group">
            <label for="playerCount">인원수</label>
            <input type="number" class="form-control" id="playerCount" name="playerCount" min="1" max="10" value="4" required>
        </div>
        <button type="button" class="btn btn-primary" id="generateButton">폼 생성하기</button>
        <div id="players" class="mt-3"></div>
        <button type="submit" class="btn btn-success mt-3" id="calculateButton" disabled>게임 저장하기</button>
    </form>
</div>
</body>
</html>
