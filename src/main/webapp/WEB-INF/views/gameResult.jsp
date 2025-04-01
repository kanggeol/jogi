<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <title>게임 결과</title>
  <script>
      function submitCalculation() {
          const resultIds = Array.from(document.querySelectorAll('[name="resultIds"]')).map(input => input.value);
          const playerNames = Array.from(document.querySelectorAll('[name="names"]')).map(input => input.value);
          const originalScoreInputs = Array.from(document.querySelectorAll('[name="originalScore"]'));
          const originalScore = originalScoreInputs.map(input => input.value.trim());

          // 빈값 유효성 검사
          if (originalScore.some(score => score === "")) {
              alert("스코어를 입력해주세요");
              originalScoreInputs.find(input => input.value.trim() === "").focus(); // 첫 번째 빈 입력란에 포커스
          } else {
              console.log(originalScore); // 유효하면 값 출력 또는 다른 로직 실행
          }
          const handicaps = Array.from(document.querySelectorAll('[name="handicaps"]')).map(input => input.value);

          const data = {
              gameDate: document.querySelector('[name="gameDate"]').value,
              gameId:document.querySelector('[name="gameId"]').value,
              resultId: resultIds,
              names: playerNames,
              originalScore: originalScore,
              handicaps: handicaps
          };

          // Send the data using fetch
          fetch('/calculate', {
              method: 'POST',
              headers: {
                  'Content-Type': 'application/json'
              },
              body: JSON.stringify(data)
          })
              .then(response => response.json())
              .then(result => {
                  console.log('Success:', result);
                  window.location.href = '/results?date='+document.querySelector('[name="gameDate"]').value;
              })
              .catch(error => {
                  console.error('Error:', error);
              });
      }

      function deleteSelectedPlayers() {
        const selectedResultIds = Array.from(document.querySelectorAll('.player-checkbox:checked')).map(checkbox => checkbox.value);

        if (selectedResultIds.length === 0) {
          alert('삭제할 플레이어를 선택하세요.');
          return;
        }

        if (!confirm('선택한 플레이어를 삭제하시겠습니까?')) {
          return;
        }

        fetch('/deleteSelectedGamePlayers', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ resultIds: selectedResultIds })
        })
          .then(response => response.json())
          .then(result => {
            if (result.success) {
              alert('삭제되었습니다.');
              window.location.reload();
            } else {
              alert('삭제 실패: ' + result.message);
            }
          })
          .catch(error => console.error('Error:', error));
      }

      function toggleSelectAll() {
        const checkboxes = document.querySelectorAll('.player-checkbox');
        const selectAll = document.getElementById('selectAllCheckbox').checked;

        checkboxes.forEach(checkbox => {
          checkbox.checked = selectAll;
        });
      }

      // 개별 체크박스 변경 시 전체 선택 체크박스 상태 업데이트
      function updateSelectAllCheckbox() {
        const checkboxes = document.querySelectorAll('.player-checkbox');
        const selectAll = document.getElementById('selectAllCheckbox');

        // 모든 체크박스가 선택된 경우 전체 선택 체크박스도 선택
        selectAll.checked = Array.from(checkboxes).every(checkbox => checkbox.checked);
      }

  </script>
  <style>
    tr,td {
        text-align: center
    }
  </style>
</head>
<body>
<div class="container">
  <h1>게임 결과</h1>
  <p><strong>날짜:</strong> ${gameDate}</p>
  <input type="hidden" name="gameDate" value="${gameDate}" />

  <table class="table table-bordered">
    <thead>
    <tr>
      <th><input type="checkbox" id="selectAllCheckbox" onclick="toggleSelectAll()" /></th>
      <c:if test="${showDeleteButton}">
      <th>순위</th>
      </c:if>
      <th>이름</th>
      <th>타수</th>
      <th>핸디</th>
      <c:if test="${showDeleteButton}">
        <th>금액</th>
      </c:if>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="result" items="${results}" varStatus="status">
    <input type="hidden" name="gameId" value="${result.gameId}" />
      <tr >
        <td><input type="checkbox" class="player-checkbox" value="${result.resultId}" /></td>
        <c:if test="${showDeleteButton}">
        <td>${result.rank}</td>
        </c:if>
        <td>
          <input type="hidden" name="names" value="${result.playerName}" />
          <input type="hidden" name="resultIds" value="${result.resultId}" />
            ${result.playerName}
        </td>
        <td>
          <c:choose>
            <c:when test="${result.rank == 0}">
              <input type="number" class="form-control" name="originalScore" required/>
            </c:when>
            <c:otherwise>
              ${result.originalScore}
              <input type="hidden" name="originalScore" value="${result.originalScore}" />
            </c:otherwise>
          </c:choose>
        </td>
        <td>
          <input type="hidden" name="handicaps" value="${result.handicap}" />
            ${result.handicap}
        </td>
        <c:if test="${showDeleteButton}">
          <td><fmt:formatNumber value="${result.calculatedAmount}" type="number" groupingUsed="true" />원</td>
        </c:if>
      </tr>
    </c:forEach>
    </tbody>
  </table>

  <div class="d-flex justify-content-center mt-3">
      <a href="/" class="btn btn-primary">총금액 확인</a>
      <c:choose>
          <c:when test="${showDeleteButton}">
              <button type="button" class="btn btn-danger ml-2" onclick="deleteSelectedPlayers()">삭제</button>
          </c:when>
          <c:otherwise>
              <button type="button" class="btn btn-success ml-2" onclick="submitCalculation()">계산하기</button>
          </c:otherwise>
      </c:choose>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
