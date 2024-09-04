<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <title>플레이어 추가</title>
    <script>
        function addPlayer() {
            const playerContainer = document.getElementById('players');
            const playerCount = playerContainer.children.length;
            const playerHTML = `
                <div class="form-group">
                    <label for="playerName${playerCount}">플레이어 이름</label>
                    <input type="text" class="form-control" id="playerName${playerCount}" name="playerNames" required>
                </div>
                <div class="form-group">
                    <label for="handicap${playerCount}">핸디캡</label>
                    <input type="number" class="form-control" id="handicap${playerCount}" name="handicaps" value="0" required>
                </div>`;
            playerContainer.insertAdjacentHTML('beforeend', playerHTML);
        }

        function enableSaveButton() {
            document.getElementById('calculateButton').disabled = false;
        }
    </script>
</head>
<body>
<div class="container" style="padding: 20px">
    <h1>플레이어 추가</h1>
    <form action="/savePlayers" method="post">
        <input type="hidden" name="gameId" value="${gameId}">
        <div id="players"></div>
        <button type="button" class="btn btn-primary" onclick="addPlayer()">플레이어 추가</button>
        <button type="submit" class="btn btn-success mt-3" onclick="enableSaveButton()">플레이어 저장하기</button>
    </form>
</div>
</body>
</html>
