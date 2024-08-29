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
    <a href="/gameForm" class="btn btn-primary mt-3">기록 저장하기</a>
    <button type="button" class="btn btn-info mt-3" onclick="showDatePicker()">결과 조회하기</button>

    <!-- 모달 형태로 날짜 선택 달력 표시 -->
    <div id="datePickerModal" class="modal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">날짜 선택</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="/results" method="get">
                        <div class="form-group">
                            <input type="date" id="date" name="date" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary">조회하기</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function showDatePicker() {
        $('#datePickerModal').modal('show');
    }
</script>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<footer style="position: fixed; bottom: 10px; right: 10px;">
    <p>since 2024.8.29<br>ver 1.1</p>
</footer>

</body>
</html>
