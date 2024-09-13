<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <title>게임 결과</title>
  <script>
      function showDeleteModal(resultId, date) {
          const modal = document.getElementById('deleteModal');
          modal.dataset.resultId = resultId;
          modal.dataset.date = date;
          modal.querySelector('.modal-body').innerHTML = `
            <p>비밀번호를 입력하여 삭제를 확인하세요.</p>
            <input type="password" id="passwordInput" class="form-control" placeholder="비밀번호 입력">
            <div id="deleteMessage" class="mt-2 text-danger" style="display: none;">삭제 실패: 비밀번호가 일치하지 않습니다.</div>
          `;
          $('#deleteModal').modal('show');

          // 엔터 키를 누르면 삭제 확인
          document.getElementById('passwordInput').addEventListener('keypress', function(event) {
              if (event.key === 'Enter') {
                  event.preventDefault(); // 폼 제출을 방지 (필요시)
                  confirmDelete(); // 삭제 확인 함수 호출
              }
          });
      }

      function confirmDelete() {
          const password = document.getElementById('passwordInput').value;
          const modal = document.getElementById('deleteModal');
          const resultId = modal.dataset.resultId;
          const date = modal.dataset.date;

          if (password === "0") {
              // 비밀번호 일치 시 삭제 요청 전송
              const form = document.createElement('form');
              form.method = 'POST';
              form.action = '/deleteGameResult';

              const resultIdInput = document.createElement('input');
              resultIdInput.type = 'hidden';
              resultIdInput.name = 'resultId';
              resultIdInput.value = resultId;
              form.appendChild(resultIdInput);

              const dateInput = document.createElement('input');
              dateInput.type = 'hidden';
              dateInput.name = 'date';
              dateInput.value = date;
              form.appendChild(dateInput);

              document.body.appendChild(form);
              form.submit();
          } else {
              // 비밀번호 불일치 시 메시지 표시
              document.getElementById('deleteMessage').style.display = 'block';
          }
      }

      function submitCalculation() {
          const resultIds = Array.from(document.querySelectorAll('[name="resultIds"]')).map(input => input.value);
          const playerNames = Array.from(document.querySelectorAll('[name="names"]')).map(input => input.value);
          const todayScores = Array.from(document.querySelectorAll('[name="todayScores"]')).map(input => input.value);
          const handicaps = Array.from(document.querySelectorAll('[name="handicaps"]')).map(input => input.value);

          const data = {
              gameDate: document.querySelector('[name="gameDate"]').value,
              resultId: resultIds,
              names: playerNames,
              todayScores: todayScores,
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
      <c:if test="${showDeleteButton}">
      <th>순위</th>
      </c:if>
      <th>이름</th>
      <th>타수</th>
      <th>핸디</th>
      <c:if test="${showDeleteButton}">
        <th>금액</th>
        <th>삭제</th>
      </c:if>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="result" items="${results}" varStatus="status">
      <tr >
        <c:if test="${showDeleteButton}">
        <td>${status.index + 1}</td>
        </c:if>
        <td>
          <input type="hidden" name="names" value="${result.playerName}" />
          <input type="hidden" name="resultIds" value="${result.resultId}" />
            ${result.playerName}
        </td>
        <td>
          <c:choose>
            <c:when test="${result.rank == 0}">
              <input type="number" class="form-control" name="todayScores" value="${result.originalScore}" required/>
            </c:when>
            <c:otherwise>
              ${result.originalScore}
              <input type="hidden" name="todayScores" value="${result.originalScore}" />
            </c:otherwise>
          </c:choose>
        </td>
        <td>
          <input type="hidden" name="handicaps" value="${result.handicap}" />
            ${result.handicap}
        </td>
        <c:if test="${showDeleteButton}">
          <td>${result.calculatedAmount}원</td>
          <td>
            <button class="btn btn-danger" onclick="showDeleteModal('${result.resultId}', '${gameDate}')">삭제</button>
          </td>
        </c:if>
      </tr>
    </c:forEach>
    </tbody>
  </table>

  <a href="/" class="btn btn-primary mt-3">총금액 확인</a>
  <button type="button" class="btn btn-success mt-3" onclick="submitCalculation()">계산하기</button>
</div>

<!-- 모달 HTML -->
<div id="deleteModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">

