<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>게임 생성</title>
    <script src="${pageContext.request.contextPath}/js/main.js" defer></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        function validateForm(event) {
            const playerCount = parseInt(document.getElementById('playerCount').value, 10);
            const playerNameInputs = document.querySelectorAll('[name="names"]');

            if (playerCount > 0 && playerNameInputs.length === 0) {
                generatePlayerForms();
                event.preventDefault();
                return false;
            }

            if (playerCount > 0 && playerNameInputs.length > 0) {
                for (let input of playerNameInputs) {
                    if (input.value.trim() === '') {
                        event.preventDefault();
                        alert('모든 참가자의 이름을 입력해주세요.');
                        input.focus();
                        return false;
                    }
                }
            }

            return true;
        }

        window.addEventListener('DOMContentLoaded', function() {
            document.querySelector('form').addEventListener('submit', validateForm);

        });
    </script>
</head>
<body>
    <div class="app-bar">게임 생성하기</div>

    <div class="container">
        <div class="app-card">
            <form action="/save" method="post">
                <div class="form-group">
                    <label for="gameDate">날짜</label>
                    <input type="date" class="form-control" id="gameDate" name="gameDate" value="${today}" required>
                </div>
                <div class="form-group">
                    <label for="gameFee">타당 게임비</label>
                    <input type="number" class="form-control" id="gameFee" name="gameFee" value="2000" required>
                </div>

                <div class="alert alert-info">
                    <strong>참가자 추가 방식</strong>
                    <ul style="margin-bottom: 0;">
                        <li><strong>방법 1:</strong> 아래에서 인원수를 선택하고 참가자를 등록 후 저장</li>
                        <li><strong>방법 2:</strong> 게임을 생성한 후 링크를 공유하면 각자가 참가자를 추가</li>
                    </ul>
                </div>

                <div class="form-group">
                    <label for="playerCount">인원수 (선택사항)</label>
                    <input type="number" class="form-control" id="playerCount" name="playerCount" min="0" max="10" value="0" placeholder="0명이면 생성 후 추가">
                </div>
                <div class="btn-area">
                    <button type="submit" class="btn btn-success btn-action" id="saveButton">게임 생성</button>
                    <a href="/" class="btn btn-secondary btn-action">취소</a>
                </div>
                <div id="players" class="mt-3"></div>

                <!-- 참가자 선택 모달 -->
                <div class="modal fade" id="playerModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">참가자 선택</h5>
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                            </div>
                            <div class="modal-body">
                                <div id="playerModalBody" class="list-group"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
