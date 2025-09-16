<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>글쓰기</title>

  <!-- 기존 CSS 유지 -->
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
        <h1 class="h5 mb-1">
          <i class="bi bi-pencil-square mr-2"></i> 글쓰기
        </h1>
        <div class="text-muted small">새 게시글을 작성하세요.</div>
      </div>
      <div>
        <a class="btn btn-outline-secondary btn-sm" href="<c:url value='/list.do'/>">
          <i class="bi bi-card-list mr-1"></i> 목록
        </a>
      </div>
    </div>

    <div class="card-body">
      <form method="post" action="<c:url value='/write.do'/>" novalidate>

        <!-- 제목 -->
        <div class="form-group">
          <label for="subject" class="font-weight-bold">
            <i class="bi bi-type mr-1"></i> 제목
          </label>
          <input id="subject" name="subject"
                 class="form-control form-control-lg"
                 placeholder="제목을 입력하세요"
                 required maxlength="100" />
          <small class="form-text text-muted">최대 100자까지 입력 가능합니다.</small>
        </div>

        <!-- 작성자 -->
        <div class="form-group">
          <label for="writer" class="font-weight-bold">
            <i class="bi bi-person mr-1"></i> 작성자
          </label>
          <div class="input-group">
            <div class="input-group-prepend">
              <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
            </div>
            <input id="writer" name="writer"
                   class="form-control"
                   placeholder="작성자명을 입력하세요"
                   required maxlength="50" />
          </div>
        </div>

        <!-- 내용 -->
        <div class="form-group">
          <label for="content" class="font-weight-bold">
            <i class="bi bi-text-paragraph mr-1"></i> 내용
          </label>
          <textarea id="content" name="content"
                    class="form-control"
                    placeholder="내용을 입력하세요"
                    rows="10" required></textarea>
        </div>

        <!-- 액션 버튼 -->
        <div class="d-flex justify-content-between align-items-center mt-4">
          <div class="text-muted small">
            <i class="bi bi-info-circle mr-1"></i> 작성 후 등록 버튼을 눌러주세요.
          </div>
          <div>
            <a class="btn btn-outline-secondary mr-2" href="<c:url value='/list.do'/>">
              취소
            </a>
            <button class="btn btn-primary" type="submit">
              <i class="bi bi-check2-circle mr-1"></i> 등록
            </button>
          </div>
        </div>
      </form>
    </div>
  </div>

</div>

</body>
</html>
