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
                  window.location.href = '/results?gameId='+document.querySelector('[name="gameId"]').value;
              })
              .catch(error => {
                  console.error('Error:', error);
              });
      }

      function deleteSelectedPlayers() {
        const selectedResultIds = Array.from(document.querySelectorAll('.player-checkbox:checked')).map(checkbox => checkbox.value);
        const gameId = document.querySelector('[name="gameId"]').value;

        if (selectedResultIds.length === 0) {
          alert('삭제할 참가자를 선택하세요.');
          return;
        }

        if (!confirm('선택한 참가자를 삭제하시겠습니까?')) {
          return;
        }

        fetch('/deleteSelectedGamePlayers', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ resultIds: selectedResultIds, gameId: gameId })
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

      function copyLink() {
          navigator.clipboard.writeText(window.location.href)
              .then(() => alert('링크가 복사되었습니다.'));
      }

      function searchNewPlayer() {
          const playerName = document.getElementById('newPlayerName').value.trim();
          if (!playerName) {
              alert('이름을 입력하세요.');
              return;
          }

          const url = '/search-player-list?playerName=' + encodeURIComponent(playerName);
          fetch(url)
              .then(response => response.json())
              .then(data => {
                  if (data.players.length) {
                      displayAddPlayerModal(data.players);
                  } else {
                      alert('해당 이름과 일치하는 참가자가 없습니다.');
                  }
              })
              .catch(error => console.error('Error:', error));
      }

      function displayAddPlayerModal(players) {
          const modalBody = document.getElementById('addPlayerModalBody');
          modalBody.innerHTML = '';
          console.log('Players data:', players);
          players.forEach(player => {
              const btn = document.createElement('button');
              btn.type = "button";
              btn.className = 'list-group-item list-group-item-action';
              console.log('Player:', player, 'Handicap:', player.handicap);
              btn.textContent = player.name + ' (핸디: ' + (player.handicap !== undefined ? player.handicap : '없음') + ')';
              btn.addEventListener('click', () => selectNewPlayer(player));
              modalBody.appendChild(btn);
          });
          $('#addPlayerModal').modal('show');
      }

      function selectNewPlayer(player) {
          document.getElementById('newPlayerName').value = player.name;
          document.getElementById('newPlayerHandicap').value = player.handicap;
          $('#addPlayerModal').modal('hide');
      }

      function deleteGame() {
          if (!confirm('이 게임을 삭제하시겠습니까? 복구할 수 없습니다.')) {
              return;
          }
          const gameId = document.querySelector('[name="gameId"]').value;
          fetch('/deleteGame?gameId=' + gameId, {
              method: 'POST'
          })
              .then(response => response.json())
              .then(result => {
                  if (result.success) {
                      alert('게임이 삭제되었습니다.');
                      window.location.href = '/';
                  } else {
                      alert('게임 삭제 실패');
                  }
              })
              .catch(error => {
                  console.error('Error:', error);
                  alert('게임 삭제 중 오류가 발생했습니다.');
              });
      }

      function addPlayer() {
          console.log('addPlayer called');
          const gameIdElements = document.querySelectorAll('[name="gameId"]');
          console.log('gameId elements found:', gameIdElements.length);

          let gameId = null;
          if (gameIdElements.length > 0) {
              gameId = gameIdElements[gameIdElements.length - 1].value;
          }

          const playerName = document.getElementById('newPlayerName').value.trim();
          const handicapValue = document.getElementById('newPlayerHandicap').value.trim();
          const handicap = parseInt(handicapValue);
          const gameDate = document.querySelector('[name="gameDate"]').value;

          console.log('gameId:', gameId, 'playerName:', playerName, 'handicap:', handicap, 'gameDate:', gameDate);

          if (!playerName) {
              alert('참가자 이름을 입력하세요.');
              return;
          }
          if (!handicapValue || isNaN(handicap)) {
              alert('핸디캡을 입력하세요.');
              return;
          }
          if (!gameId) {
              alert('게임 ID를 찾을 수 없습니다.');
              return;
          }

          fetch('/addPlayer', {
              method: 'POST',
              headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
              body: new URLSearchParams({
                  gameId: gameId,
                  playerName: playerName,
                  handicap: handicap,
                  gameDate: gameDate
              })
          })
              .then(response => {
                  if (response.ok) {
                      window.location.href = '/results?gameId=' + gameId;
                  } else {
                      alert('참가자 추가 실패');
                  }
              })
              .catch(error => {
                  console.error('Error:', error);
                  alert('참가자 추가 중 오류가 발생했습니다.');
              });
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
</head>
<body>
<body>
<div class="app-bar">게임 결과</div>

<div class="container">
  <div class="app-card">
    <p><strong>날짜:</strong> ${gameDate}</p>
    <input type="hidden" name="gameDate" value="${gameDate}" />

    <div class="table-responsive">
      <table class="table table-bordered result-table">
    <thead>
    <tr>
      <th class="col-check"><input type="checkbox" id="selectAllCheckbox" onclick="toggleSelectAll()" /></th>
      <c:if test="${showDeleteButton}">
      <th class="col-num">순위</th>
      </c:if>
      <th class="col-name">이름</th>
      <th class="col-score">타수</th>
      <th class="col-handicap">핸디</th>
      <c:if test="${showDeleteButton}">
        <th class="col-amount">금액</th>
      </c:if>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="result" items="${results}" varStatus="status">
    <input type="hidden" name="gameId" value="${result.gameId}" />
      <tr >
        <td class="col-check"><input type="checkbox" class="player-checkbox" value="${result.resultId}" /></td>
        <c:if test="${showDeleteButton}">
        <td class="col-num">${result.rank}</td>
        </c:if>
        <td class="col-name">
          <input type="hidden" name="names" value="${result.playerName}" />
          <input type="hidden" name="resultIds" value="${result.resultId}" />
            ${result.playerName}
        </td>
        <td class="col-score">
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
        <td class="col-handicap">
          <input type="hidden" name="handicaps" value="${result.handicap}" />
            ${result.handicap}
        </td>
        <c:if test="${showDeleteButton}">
          <td class="col-amount"><fmt:formatNumber value="${result.calculatedAmount}" type="number" groupingUsed="true" />원</td>
        </c:if>
      </tr>
    </c:forEach>
    </tbody>
    </table>
    </div>
  </div>

  <input type="hidden" name="gameId" value="${gameId}" />
  <div class="player-form">
      <h5>참가자 추가</h5>
      <div class="form-row mb-2">
        <div class="form-group col-8">
          <label>이름</label>
          <div class="input-group">
            <input type="text" id="newPlayerName" class="form-control player-name" placeholder="이름 입력" onkeypress="if(event.key==='Enter') searchNewPlayer()" />
            <div class="input-group-append">
              <button type="button" class="btn btn-secondary btn-sm" onclick="searchNewPlayer()">검색</button>
            </div>
          </div>
        </div>
        <div class="form-group col-4">
          <label>핸디</label>
          <input type="text" id="newPlayerHandicap" class="form-control handicap-input" placeholder="핸디" />
        </div>
      </div>
      <div class="form-row">
        <c:choose>
          <c:when test="${!empty results}">
            <div class="form-group col-8">
              <button type="button" class="btn btn-primary btn-sm" onclick="addPlayer()" style="width: 100%;">참가자 추가</button>
            </div>
            <div class="form-group col-4">
              <button type="button" class="btn btn-danger btn-sm" onclick="deleteSelectedPlayers()" style="width: 100%;">삭제</button>
            </div>
          </c:when>
          <c:otherwise>
            <div class="form-group col-12">
              <button type="button" class="btn btn-primary btn-sm" onclick="addPlayer()" style="width: 100%;">참가자 추가</button>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- 참가자 선택 모달 -->
    <div class="modal fade" id="addPlayerModal" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">참가자 선택</h5>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <div class="modal-body">
            <div id="addPlayerModalBody" class="list-group"></div>
          </div>
        </div>
      </div>
    </div>

  <div class="btn-area">
      <a href="/" class="btn btn-primary btn-action">총금액 확인</a>
      <button type="button" class="btn btn-secondary btn-action" onclick="copyLink()">링크 복사</button>
      <c:choose>
          <c:when test="${showDeleteButton}">
              <button type="button" class="btn btn-danger btn-action" onclick="deleteSelectedPlayers()">삭제</button>
          </c:when>
          <c:otherwise>
              <button type="button" class="btn btn-success btn-action" onclick="submitCalculation()">계산하기</button>
              <c:if test="${empty results}">
                  <button type="button" class="btn btn-outline-danger btn-action" onclick="deleteGame()">게임 삭제</button>
              </c:if>
          </c:otherwise>
      </c:choose>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
