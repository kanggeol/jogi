<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <title>Game Calculator</title>
  <script>
      // 현재 날짜를 yyyy-MM-dd 형식으로 반환
      function getToday() {
          const today = new Date();
          const year = today.getFullYear();
          const month = ('0' + (today.getMonth() + 1)).slice(-2);
          const day = ('0' + today.getDate()).slice(-2);
          return `${year}-${month}-${day}`;
      }

      function generatePlayerForms() {
          const playerCount = document.getElementById('playerCount').value;
          const playersDiv = document.getElementById('players');
          playersDiv.innerHTML = ''; // 기존 폼 초기화

          for (let i = 0; i < playerCount; i++) {
              const row = document.createElement('div');
              row.className = 'form-row mb-2';

              row.innerHTML = `
                    <div class="form-group col-md-4">
                        <label>이름</label>
                        <input type="text" name="names" class="form-control" placeholder="플레이어 ${i + 1} 이름" required>
                    </div>
                    <div class="form-group col-md-4">
                        <label>오늘의 타수</label>
                        <input type="number" name="todayScores" class="form-control" placeholder="타수 입력" required>
                    </div>
                    <div class="form-group col-md-4">
                        <label>핸디</label>
                        <input type="number" name="handicaps" class="form-control" placeholder="핸디 입력" required>
                    </div>
                `;
              playersDiv.appendChild(row);
          }
      }

      // 페이지가 로드되면 오늘 날짜를 기본값으로 설정
      window.onload = function() {
          document.getElementById('gameDate').value = getToday();
      }
  </script>
</head>
<body>
<div class="container">
  <h1>게임 계산기</h1>
  <form action="/calculate" method="post">
    <div class="form-group">
      <label for="gameDate">날짜</label>
      <input type="date" class="form-control" id="gameDate" name="gameDate" required>
    </div>
    <div class="form-group">
      <label for="gameFee">타당 게임비</label>
      <input type="number" class="form-control" id="gameFee" name="gameFee" required>
    </div>
    <div class="form-group">
      <label for="playerCount">인원수</label>
      <input type="number" class="form-control" id="playerCount" name="playerCount" min="1" max="10" value="4" required>
    </div>
    <button type="button" class="btn btn-primary" onclick="generatePlayerForms()">폼 생성하기</button>
    <div id="players" class="mt-3"></div>
    <button type="submit" class="btn btn-success mt-3">계산하기</button>
  </form>
</div>
</body>
</html>
