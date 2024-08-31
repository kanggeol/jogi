function ensurePlayerExistsAndFetchHandicap(playerNameInput, handicapInput) {
    const playerName = playerNameInput.value.trim();

    if (playerName === '') {
        return; // 이름이 비어있으면 핸디캡을 업데이트하지 않음
    }

    fetch(`/player-handicap?playerName=${encodeURIComponent(playerName)}`)
        .then(response => response.json())
        .then(data => {
            if (data.exists) {
                handicapInput.value = data.handicap; // 기존 핸디캡 설정
            } else {
                handicapInput.value = 20; // 새로운 플레이어의 경우 기본 핸디캡 20으로 설정
            }
        })
        .catch(error => {
            console.error('Error fetching player handicap:', error);
        });
}


function generatePlayerForms() {
    const playerCount = parseInt(document.getElementById('playerCount').value, 10);
    const playersDiv = document.getElementById('players');
    const calculateButton = document.getElementById('calculateButton');

    playersDiv.innerHTML = ''; // 기존 폼 초기화

    for (let i = 0; i < playerCount; i++) {
        const playerNo = i + 1;
        const row = document.createElement('div');
        row.className = 'player-form';

        row.innerHTML = '<h5>플레이어 ' + playerNo + '</h5>' +
            '<div class="form-row mb-2">' +
            '<div class="form-group col-md-4">' +
            '<label>이름</label>' +
            '<input type="text" name="names" class="form-control player-name" placeholder="이름 입력" required>' +
            '</div>' +
            '<div class="form-group col-md-4">' +
            '<label>오늘의 타수</label>' +
            '<input type="text" name="todayScores" class="form-control" placeholder="타수 입력" required>' +
            '</div>' +
            '<div class="form-group col-md-4">' +
            '<label>핸디</label>' +
            '<input type="text" name="handicaps" class="form-control handicap-input" placeholder="핸디 입력" required>' +
            '</div>' +
            '</div>';

        playersDiv.appendChild(row);

        const playerNameInput = row.querySelector('.player-name');
        const handicapInput = row.querySelector('.handicap-input');

        playerNameInput.addEventListener('blur', function() {
            ensurePlayerExistsAndFetchHandicap(playerNameInput, handicapInput);
        });
    }

    // 폼 생성 후 계산하기 버튼 활성화
    calculateButton.disabled = false;
}

window.onload = function() {
    const generateButton = document.getElementById('generateButton');
    generateButton.addEventListener('click', generatePlayerForms);

    document.getElementById('playerCount').addEventListener('keypress', function(event) {
        if (event.key === 'Enter') {
            event.preventDefault();
            generatePlayerForms();
        }
    });

    const calculateButton = document.getElementById('calculateButton');
    calculateButton.disabled = true;
}
