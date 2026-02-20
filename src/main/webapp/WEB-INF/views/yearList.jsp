<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <title>연도 선택</title>
</head>
<body style="margin: 20px">
<div class="container">
  <h3 class="text-center mb-4">연도 선택</h3>
  <table class="table table-bordered">
    <thead>
    <tr>
      <th class="text-center">연도</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="year" items="${years}">
      <tr>
        <td class="text-center">
            <a href="/dateListByYear?year=${year}" class="btn btn-link">${year}년</a>
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
