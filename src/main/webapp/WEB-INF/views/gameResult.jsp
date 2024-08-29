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
          document.getElementById('deleteModal').dataset.resultId = resultId;
          document.getElementById('deleteModal').dataset.date = date;
          document.getElementById('deleteModal').querySelector('.modal-body').innerHTML = `
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

          if (password === "12345") {
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
  </script>
</head>
<body>
<div class="container">
  <h1>계산 결과</h1>
  <p><strong>날짜:</strong> ${gameDate}</p>
  <table class="table table-bordered">
    <thead>
    <tr>
      <th>순위</th>
      <th>이름</th>
      <th>타수</th>
      <th>핸디</th>
      <th>금액</th>
      <c:if test="${showDeleteButton}">
        <th>삭제</th>
      </c:if>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="result" items="${results}" varStatus="status">
      <tr>
        <td>${status.index + 1}</td>
        <td>${result.playerName}</td>
        <td>${result.originalScore}</td>
        <td>${result.handicap}</td>
        <td>${result.calculatedAmount}원</td>
        <c:if test="${showDeleteButton}">
          <td>
            <button class="btn btn-danger" onclick="showDeleteModal('${result.resultId}', '${gameDate}')">삭제</button>
          </td>
        </c:if>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  <a href="/" class="btn btn-primary mt-3">총금액 확인</a>
</div>

<!-- 모달 HTML -->
<div id="deleteModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">삭제 확인</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <!-- 비밀번호 입력 및 실패 메시지를 동적으로 추가 -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
        <button type="button" class="btn btn-danger" onclick="confirmDelete()">삭제</button>
      </div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<footer style="position: fixed; bottom: 10px; right: 10px;">
  <p>since 2024.8.29<br>ver 1.1</p>
</footer>

</body>
</html>
