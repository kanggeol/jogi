<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>Game Form</title>
</head>
<body>
<h2>Enter Results for Game ${gameId}</h2>
<form action="/saveGameResult" method="post">
    <input type="hidden" name="gameId" value="${gameId}" />
    <div id="playersForm">
        <!-- JavaScript will add player forms here -->
    </div>
    <button type="button" onclick="addResultForm()">플레이어 추가</button><br/>
    <input type="submit" value="계산하기" />
</form>
<script>
    function addResultForm() {
        var form = document.getElementById('playersForm');
        var index = form.childElementCount;
        var div = document.createElement('div');
        div.innerHTML = `
                <h4>플레이어 ${index + 1}</h4>
                <label>이름:</label>
                <input type="text" name="playerNames" required /><br/>
                <label>오늘의 타수:</label>
                <input type="number" name="todayScores" required /><br/>
                <label>핸디:</label>
                <input type="number" name="handicaps" required /><br/>
            `;
        form.appendChild(div);
    }
</script>
</body>
</html>
