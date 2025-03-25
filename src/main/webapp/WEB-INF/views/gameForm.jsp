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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</head>
<body>
    <div class="container" style="padding: 20px">
        <form action="/save" method="post">
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
            <!-- 플레이어 선택 모달 -->
            <div class="modal fade" id="playerModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">플레이어 선택</h5>
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <div id="playerModalBody" class="list-group"></div>
                        </div>
                    </div>
                </div>
            </div>
            <button type="submit" class="btn btn-success mt-3" id="saveButton">저장하기</button>
        </form>
    </div>
</body>
</html>
