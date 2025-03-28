<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <title>날짜 선택</title>
</head>
<body style="margin: 20px">
<div class="container">
  <table class="table table-bordered">
    <thead>
    <tr>
      <h3 class="text-center">날짜 선택</h3>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="date" items="${dates}">
      <tr>
        <td class="text-center">
            <a href="/results?date=${date}" class="btn btn-link">${date}</a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  <div class="d-flex justify-content-center mt-3">
  <a href="/" class="btn btn-primary">홈으로</a>
  </div>
</div>
</body>
</html>
