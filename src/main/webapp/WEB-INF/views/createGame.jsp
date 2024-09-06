<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>게임 생성하기</title>
    <script>
        function addPlayerForm() {
            var form = document.getElementById('playersForm');
            var index = form.childElementCount;
            var div = document.createElement('div');
            div.innerHTML = `
                <h4>플레이어 ${index + 1}</h4>
                <label>이름:</label>
                <input type="text" name="playerNames" required /><br/>
                <label>핸디:</label>
                <input type="number" name="handicaps" required /><br/>
            `;
            form.appendChild(div);
        }
    </script>
</head>
<body>
<h1>게임 생성하기</h1>
<form action="GameCreateServlet" method="post">
    <label>날짜: <input type="date" name="gameDate"></label><br>
    <label>타당게임비: <input type="number" name="gameFee"></label><br>
    <div id="playerForms">
        <label>플레이어 이름: <input type="text" name="playerName"></label>
        <label>핸디: <input type="number" name="handicap"></label>
        <br>
    </div>
    <button type="button" onclick="addPlayerForm()">플레이어 추가</button><br>
    <input type="submit" value="게임 저장하기">
</form>
</body>
</html>
