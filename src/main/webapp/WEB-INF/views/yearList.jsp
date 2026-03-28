<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <title>연도 선택</title>
</head>
<body>
<div class="app-bar">연도 선택</div>

<div class="container">
  <div class="app-card">
    <h5 class="text-center mb-4">연도 선택</h5>
    <table class="table table-bordered result-table">
      <thead>
      <tr>
        <th>연도</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="year" items="${years}">
        <tr>
          <td>
              <a href="/dateListByYear?year=${year}" style="color: inherit; text-decoration: none;">${year}년</a>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>

  <div class="btn-area">
    <a href="/" class="btn btn-primary btn-action">홈으로</a>
  </div>
</div>
</body>
</html>
