<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>게시글 상세</title>

  <!-- 기존 CSS (유지) -->
  <link rel="stylesheet" href="<c:url value='/css/board.css'/>?v=2" />

  <!-- 외부 라이브러리: Bootstrap 4.6 + Bootstrap Icons -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link  rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
  <link  rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

<div class="container py-4">

  <!-- 카드 레이아웃 -->
  <div class="card shadow-sm border-0">
    <div class="card-header bg-white d-flex justify-content-between align-items-center">
      <div>
        <h2 class="h5 mb-1">
          <i class="bi bi-journal-text mr-2"></i>
          <c:out value="${dto.subject}" />
        </h2>
        <div class="text-muted small">
          <i class="bi bi-person mr-1"></i> <c:out value="${dto.writer}" />
          <span class="mx-2">·</span>
          <i class="bi bi-calendar3 mr-1"></i> <c:out value="${dto.regdate}" />
        </div>
      </div>

      <div class="btn-group">
        <a class="btn btn-outline-secondary btn-sm"
           href="<c:url value='/editForm.do'><c:param name='bcode' value='${dto.bcode}'/></c:url>">
          <i class="bi bi-pencil-square mr-1"></i> 수정
        </a>

        <form method="post" action="<c:url value='/delete.do'/>" class="d-inline">
          <input type="hidden" name="bcode" value="${dto.bcode}" />
          <button class="btn btn-outline-danger btn-sm"
                  type="submit" onclick="return confirm('삭제할까요?')">
            <i class="bi bi-trash mr-1"></i> 삭제
          </button>
        </form>

        <a class="btn btn-primary btn-sm" href="<c:url value='/list.do'/>">
          <i class="bi bi-card-list mr-1"></i> 목록
        </a>
      </div>
    </div>

    <div class="card-body">
      <dl class="row mb-3">
        <dt class="col-sm-2 text-muted"><i class="bi bi-person mr-1"></i> 작성자</dt>
        <dd class="col-sm-10"><c:out value="${dto.writer}" /></dd>

        <dt class="col-sm-2 text-muted"><i class="bi bi-calendar3 mr-1"></i> 작성일</dt>
        <dd class="col-sm-10"><c:out value="${dto.regdate}" /></dd>

        <dt class="col-sm-2 text-muted"><i class="bi bi-text-paragraph mr-1"></i> 내용</dt>
        <dd class="col-sm-10">
          <pre class="mb-0" style="white-space:pre-wrap;"><c:out value="${dto.content}" /></pre>
        </dd>
      </dl>
    </div>

    <div class="card-footer bg-light text-muted small">
      <i class="bi bi-chat-dots mr-1"></i> 댓글 기능은 수업에서 함께 구현 예정입니다.
    </div>
  </div>

</div>

</body>
</html>
