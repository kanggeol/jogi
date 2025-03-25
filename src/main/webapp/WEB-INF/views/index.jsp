<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <title>총금액 순위</title>
    <style>
        /* 드롭다운 메뉴 스타일 */
        .dropdown-menu {
            display: none;
            position: absolute;
            top: 40px;
            right: 20px;
            background-color: #f8f9fa;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1;
        }
        .dropdown.show .dropdown-menu {
            display: block;
        }
        .dropdown-item {
            padding: 10px 20px;
            cursor: pointer;
        }
        .dropdown-item:hover {
            background-color: #ddd;
        }
    </style>
</head>
<body style="margin: 20px">
<div class="container">
    <h1>깊생골프</h1>
    
    <!-- 우측 상단에 년도 선택 드롭다운 추가 -->
    <div class="dropdown" style="position: absolute; top: 20px; right: 20px;">
        <button class="btn btn-secondary" type="button" id="dropdownMenuButton">
            년도 선택
        </button>
        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
            <a class="dropdown-item" href="#" id="lastYear">작년</a>
            <a class="dropdown-item" href="#" id="thisYear">올해</a>
            <a class="dropdown-item" href="#" id="allTime">전체</a>
        </div>
    </div>
    
    <table class="table table-bordered mt-4">
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

<!-- jQuery, Popper.js, Bootstrap JS를 올바르게 포함시켜야 드롭다운이 작동합니다 -->
<script>
    // 드롭다운 토글 기능 구현
    const dropdownButton = document.getElementById('dropdownMenuButton');
    const dropdownMenu = document.querySelector('.dropdown-menu');
    
    dropdownButton.addEventListener('click', function () {
        dropdownMenu.classList.toggle('show');
    });
    
    // 버튼 클릭 시 선택된 년도에 따라 필터링 동작
    document.getElementById('lastYear').addEventListener('click', function() {
        var currentYear = new Date().getFullYear();
        var year = currentYear - 1;
        location.href = '/?year=' + year;  // year 파라미터에 lastYear 값 전달
    });
    
    document.getElementById('thisYear').addEventListener('click', function() {
        var currentYear = new Date().getFullYear();
        location.href = '/?year=' + currentYear;  // year 파라미터에 thisYear 값 전달
    });
    
    document.getElementById('allTime').addEventListener('click', function() {
        location.href = '/?year=allTime';  // 전체를 표시하는 경우 'allTime'으로 설정
    });

</script>
</body>
</html>
