<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>게시물 관리</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- 아이콘 (Bootstrap Icons) -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-body-tertiary">

  <!-- Hero -->
  <div class="p-5 mb-4 bg-light text-center border-bottom">
    <div class="container">
      <h1 class="display-5 fw-bold">My First Board Management</h1>
      <p class="fs-5 text-secondary">나의 첫 번째 게시물 관리 프로그램</p>
      <div class="mt-4">
        <a href="${ctx}/list.do" class="btn btn-primary btn-lg me-2">게시물 목록</a>
        <a href="${ctx}/insertForm.do" class="btn btn-outline-secondary btn-lg">게시물 등록</a>
      </div>
    </div>
  </div>

  <!-- Feature Cards -->
  <div class="container py-5">
    <div class="row g-4">
      <div class="col-md-4">
        <div class="card h-100 shadow-sm text-center">
          <div class="card-body">
            <i class="bi bi-lightning-charge-fill display-5 text-primary mb-3"></i>
            <h5 class="card-title fw-bold">빠른 처리</h5>
            <p class="card-text text-muted">간단한 CRUD로 누구나 쉽게 게시판을 관리할 수 있습니다.</p>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card h-100 shadow-sm text-center">
          <div class="card-body">
            <i class="bi bi-layout-text-window display-5 text-success mb-3"></i>
            <h5 class="card-title fw-bold">깔끔한 UI</h5>
            <p class="card-text text-muted">Bootstrap 기반으로 모바일·데스크톱에서 보기 좋게 반응형 지원.</p>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card h-100 shadow-sm text-center">
          <div class="card-body">
            <i class="bi bi-gear-fill display-5 text-danger mb-3"></i>
            <h5 class="card-title fw-bold">확장성</h5>
            <p class="card-text text-muted">댓글, 첨부파일, 검색 기능을 손쉽게 추가할 수 있는 구조.</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Footer -->
  <footer class="bg-light border-top py-3 mt-5">
    <div class="container text-center text-secondary small">
      © <c:out value="${pageContext.request.serverName}" /> Board Project
    </div>
  </footer>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
