function generatePlayerForms() {
    const playerCount = parseInt(document.getElementById('playerCount').value, 10);
    const playersDiv = document.getElementById('players');
    playersDiv.innerHTML = '';

    for (let i = 0; i < playerCount; i++) {
        const row = document.createElement('div');
        row.className = 'player-form';
        row.innerHTML = `
            <h5>플레이어 ${i + 1}</h5>
            <div class="form-row mb-2">
                <div class="form-group col-12 col-md-4">
                    <label>이름</label>
                    <div class="input-group">
                        <input type="text" name="names" class="form-control player-name" placeholder="이름 입력" required>
                        <div class="input-group-append">
                            <button type="button" class="btn btn-secondary btn-sm search-player" data-index="${i}">검색</button>
                        </div>
                    </div>
                </div>
                <div class="form-group col-md-4">
                    <label>핸디</label>
                    <input type="text" name="handicaps" class="form-control handicap-input" placeholder="핸디 입력" required>
                </div>
            </div>
        `;
        playersDiv.appendChild(row);
    }

    // 검색 버튼 클릭 시 실행
    document.querySelectorAll('.search-player').forEach(button => {
        button.addEventListener('click', function () {
            const index = this.dataset.index;
            fetchPlayerList(document.querySelectorAll('.player-name')[index], index);
        });
    });

    // Enter 키로 검색 실행
    document.querySelectorAll('.player-name').forEach(input => {
        input.addEventListener('keypress', function(event) {
            if (event.key === 'Enter') {
                const index = Array.from(document.querySelectorAll('.player-name')).indexOf(input);
                fetchPlayerList(input, index);
            }
        });
    });
}

function fetchPlayerList(inputElement, index) {
    const playerName = inputElement.value.trim();
    if (!playerName) return alert("이름을 입력하세요.");

    fetch(`/search-player-list?playerName=${encodeURIComponent(playerName)}`)
      .then(response => response.json())
      .then(data => {
          if (data.players.length) {
              displayPlayerModal(data.players, index);
          } else {
              alert("해당 이름과 일치하는 플레이어가 없습니다.");
          }
      })
      .catch(error => console.error('Error:', error));
}

function displayPlayerModal(players, index) {
    const modalBody = document.getElementById('playerModalBody');
    modalBody.innerHTML = '';
    players.forEach(player => {
        const btn = document.createElement('button');
        btn.type = "button";  // ✅ 버튼이 폼 제출을 방지하도록 설정
        btn.className = 'list-group-item list-group-item-action';
        btn.textContent = `${player.name} (핸디: ${player.handicap})`;
        btn.addEventListener('click', () => selectPlayer(player, index));
        modalBody.appendChild(btn);
    });
    $('#playerModal').modal('show');
}

function selectPlayer(player, index) {
    document.querySelectorAll('.player-name')[index].value = player.name;
    document.querySelectorAll('.handicap-input')[index].value = player.handicap;
    $('#playerModal').modal('hide');
}

window.onload = function() {
    document.getElementById('generateButton').addEventListener('click', generatePlayerForms);
    document.getElementById('playerCount').addEventListener('keypress', event => {
        if (event.key === 'Enter') {
            event.preventDefault();
            generatePlayerForms();
        }
    });
};