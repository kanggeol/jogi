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
        /* 테이블 컨테이너 */
        .table-container {
            position: relative;
            margin-top: 50px; /* 드롭다운과 여백 확보 */
        }

        /* 드롭다운 버튼을 테이블 우측 상단에 위치 */
        .dropdown {
            position: absolute;
            top: -40px; /* 테이블 위쪽 */
            right: 0;
        }

        /* 드롭다운 메뉴 스타일 */
        .dropdown-menu {
            background-color: #f8f9fa;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1000;
        }

        .dropdown-item {
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

    <!-- 테이블 컨테이너 -->
    <div class="table-container">
        <!-- 드롭다운 버튼 (테이블 우측 상단) -->
        <div class="dropdown">
            <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton">
                <c:choose>
                    <c:when test="${empty selectedYear or selectedYear eq 'thisYear'}">
                        올해
                    </c:when>
                    <c:when test="${selectedYear eq 'lastYear'}">
                        작년
                    </c:when>
                    <c:when test="${selectedYear eq 'allTime'}">
                        전체
                    </c:when>
                    <c:otherwise>
                        ${selectedYear}
                    </c:otherwise>
                </c:choose>
            </button>

            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                <a class="dropdown-item" href="#" data-year="lastYear">작년</a>
                <a class="dropdown-item" href="#" data-year="thisYear">올해</a>
                <a class="dropdown-item" href="#" data-year="allTime">전체</a>
            </div>
        </div>

        <!-- 테이블 -->
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
    </div>

    <a href="/gameForm" class="btn btn-primary mt-3">게임 생성하기</a>
    <button type="button" class="btn btn-info mt-3" onclick="location.href='/dateList'">결과 조회하기</button>
</div>

<script>
    document.getElementById('dropdownMenuButton').addEventListener('click', function () {
        document.querySelector('.dropdown-menu').classList.toggle('show');
    });

    document.querySelectorAll('.dropdown-item').forEach(item => {
        item.addEventListener('click', function (e) {
            e.preventDefault();
            let yearLabel = this.textContent;
            let yearValue = this.getAttribute('data-year');

            if (yearValue === 'lastYear') {
                yearValue = new Date().getFullYear() - 1;
            } else if (yearValue === 'thisYear') {
                yearValue = new Date().getFullYear();
            }

            document.getElementById('dropdownMenuButton').textContent = yearLabel;
            location.href = '/?year=' + yearValue;
        });
    });

    // 클릭 외부 영역을 누르면 드롭다운 닫기
    document.addEventListener('click', function (e) {
        if (!document.querySelector('.dropdown').contains(e.target)) {
            document.querySelector('.dropdown-menu').classList.remove('show');
        }
    });
</script>
</body>
</html>
