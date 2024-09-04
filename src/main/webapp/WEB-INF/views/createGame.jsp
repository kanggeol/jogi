<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <title>게임 생성</title>
</head>
<body>
<div class="container" style="padding: 20px">
    <h1>게임 생성</h1>
    <form action="/saveGame" method="post">
        <div class="form-group">
            <label for="gameDate">날짜</label>
            <input type="date" class="form-control" id="gameDate" name="gameDate" required>
        </div>
        <div class="form-group">
            <label for="gameFee">타당 게임비</label>
            <input type="number" class="form-control" id="gameFee" name="gameFee" value="2000" required>
        </div>
        <button type="submit" class="btn btn-success">게임 생성하기</button>
    </form>
</div>
</body>
</html>
