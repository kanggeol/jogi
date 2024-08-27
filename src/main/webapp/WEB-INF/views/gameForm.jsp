<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <title>Game Calculator</title>
  <style>
      .player-form {
          border: 1px solid #ccc;
          padding: 15px;
          margin-bottom: 15px;
          background-color: #f9f9f9;
          border-radius: 8px;
      }
      .player-form h5 {
          margin-bottom: 10px;
          font-weight: bold;
      }
  </style>
  <script>
      function generatePlayerForms() {
          const playerCount = parseInt(document.getElementById('playerCount').value, 10);
          const playersDiv = document.getElementById('players');
          const calculateButton = document.getElementById('calculateButton');

          playersDiv.innerHTML = ''; // 기존 폼 초기화

          for (let i = 0; i < playerCount; i++) {
              const playerNo = i + 1;
              const row = document.createElement('div');
              row.className = 'player-form';

              // 문자열 연결을 사용하여 플레이어 번호를 삽입
              row.innerHTML = '<h5>플레이어 ' + playerNo + '</h5>' +
                  '<div class="form-row mb-2">' +
                  '<div class="form-group col-md-4">' +
                  '<label>이름</label>' +
                  '<input type="text" name="names" class="form-control" placeholder="이름 입력" required>' +
                  '</div>' +
                  '<div class="form-group col-md-4">' +
                  '<label>오늘의 타수</label>' +
                  '<input type="text" name="todayScores" class="form-control" placeholder="타수 입력" required>' +
                  '</div>' +
                  '<div class="form-group col-md-4">' +
                  '<label>핸디</label>' +
                  '<input type="text" name="handicaps" class="form-control" placeholder="핸디 입력" required>' +
                  '</div>' +
                  '</div>';

              playersDiv.appendChild(row);
          }

          // 폼 생성 후 계산하기 버튼 활성화
          calculateButton.disabled = false;
      }

      window.onload = function() {
          // 폼 생성하기 버튼 클릭 이벤트 핸들러 설정
          const generateButton = document.getElementById('generateButton');
          generateButton.addEventListener('click', generatePlayerForms);

          // 인원수 입력 필드에서 엔터 키 입력 감지
          document.getElementById('playerCount').addEventListener('keypress', function(event) {
              if (event.key === 'Enter') {
                  event.preventDefault(); // 폼 제출 방지
                  generatePlayerForms();
              }
          });

          // 초기화 시 계산하기 버튼 비활성화
          const calculateButton = document.getElementById('calculateButton');
          calculateButton.disabled = true;
      }
  </script>
</head>
<body>
<div class="container" style="padding: 20px">
  <form action="/calculate" method="post">
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
    <button type="submit" class="btn btn-success mt-3" id="calculateButton" disabled>계산하기</button>
  </form>
</div>
</body>
</html>
