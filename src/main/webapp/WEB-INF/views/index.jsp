<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>총금액 순위</title>
    <style>
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

        .dropdown-container {
            text-align: right;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="app-bar">깊생골프 ⛳</div>

<div class="container">
    <div class="app-card">
        <!-- 드롭다운 버튼 -->
        <div class="dropdown-container">
            <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton">
                <c:choose>
                    <c:when test="${empty selectedYear or selectedYear eq 'thisYear'}">
                        ${currentYear}
                    </c:when>
                    <c:when test="${selectedYear eq 'lastYear'}">
                        ${currentYear - 1}
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
                <a class="dropdown-item" href="#" data-year="${currentYear - 1}">${currentYear - 1}</a>
                <a class="dropdown-item" href="#" data-year="${currentYear}">${currentYear}</a>
                <a class="dropdown-item" href="#" data-year="allTime">전체</a>
            </div>
        </div>

        <!-- 테이블 -->
        <table class="table table-bordered result-table">
            <thead>
            <tr>
                <th class="col-num">순위</th>
                <th class="col-name">이름</th>
                <th class="col-num">참여</th>
                <th class="col-amount">총 금액</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="player" items="${playerTotals}" varStatus="status">
                <tr>
                    <td class="col-num">${status.index + 1}</td>
                    <td class="col-name">${player.playerName}</td>
                    <td class="col-num">${player.participationCount}회</td>
                    <td class="col-amount"><fmt:formatNumber value="${player.totalAmount}" type="number" groupingUsed="true" />원</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="btn-area">
        <a href="/gameForm" class="btn btn-primary btn-action">게임 생성하기</a>
        <button type="button" class="btn btn-info btn-action" onclick="location.href='/dateList'">결과 조회하기</button>
    </div>

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

            document.getElementById('dropdownMenuButton').textContent = yearLabel;
            location.href = '/?year=' + yearValue;
        });
    });

    // 클릭 외부 영역을 누르면 드롭다운 닫기
    document.addEventListener('click', function (e) {
        if (!document.querySelector('.dropdown-container').contains(e.target)) {
            document.querySelector('.dropdown-menu').classList.remove('show');
        }
    });
</script>
</body>
</html>
