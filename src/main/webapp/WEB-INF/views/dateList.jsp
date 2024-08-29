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
<body>
<div class="container">
  <h1>날짜 선택</h1>
  <table class="table table-bordered">
    <thead>
    <tr>
      <th>날짜</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="date" items="${dates}">
      <tr>
        <td>
          <a href="/results?date=${date}" class="btn btn-link">${date}</a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  <a href="/" class="btn btn-primary mt-3">홈으로</a>
</div>
</body>
</html>
