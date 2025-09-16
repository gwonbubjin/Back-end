<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>글 수정</title>

  <!-- 기존 프로젝트 CSS (그대로 유지) -->
  <link rel="stylesheet" href="${ctx}/css/board.css" />

  <!-- 외부 라이브러리: Bootstrap 4.6 + Bootstrap Icons (구조/아이콘만 사용) -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link  rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
  <link  rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

<div class="container py-4">
  <!-- 상단: 제목 + 액션 -->
  <div class="d-flex align-items-center justify-content-between mb-3">
    <div class="d-flex align-items-center">
      <i class="bi bi-pencil-square mr-2" style="font-size:1.4rem;"></i>
      <h1 class="h4 mb-0 font-weight-bold">글 수정</h1>
      <span class="badge badge-light ml-3">번호 <c:out value="${dto.bcode}" /></span>
    </div>
    <div class="btn-toolbar">
      <a class="btn btn-outline-secondary btn-sm mr-2" href="${ctx}/detail.do?bcode=${dto.bcode}">
        <i class="bi bi-file-text mr-1"></i> 상세
      </a>
      <a class="btn btn-primary btn-sm" href="${ctx}/list.do">
        <i class="bi bi-card-list mr-1"></i> 목록
      </a>
    </div>
  </div>

  <!-- 카드 레이아웃 -->
  <div class="card border-0 shadow-sm">
    <div class="card-body">
      <form method="post" action="${ctx}/edit.do" novalidate>
        <input type="hidden" name="bcode" value="${dto.bcode}" />

        <div class="form-row">
          <div class="form-group col-12">
            <label for="subject" class="font-weight-bold">제목</label>
            <input id="subject" class="form-control form-control-lg"
                   name="subject" required maxlength="100"
                   value="${dto.subject}" placeholder="제목을 입력하세요" />
            <small class="form-text text-muted">최대 100자</small>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="writer" class="font-weight-bold">작성자</label>
            <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text"><i class="bi bi-person"></i></span>
              </div>
              <input id="writer" class="form-control"
                     name="writer" required maxlength="50"
                     value="${dto.writer}" placeholder="작성자 이름" />
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="font-weight-bold">작성 번호</label>
            <input class="form-control" value="${dto.bcode}" readonly />
          </div>
        </div>

        <div class="form-group">
          <label for="content" class="font-weight-bold d-flex align-items-center">
            내용
            <span class="text-muted small ml-2">(Shift+Enter 줄바꿈)</span>
          </label>
          <div class="d-flex">
            <i class="bi bi-journal-text mr-2 pt-2"></i>
            <textarea id="content" class="form-control" name="content" required
                      rows="10" placeholder="내용을 입력하세요"><c:out value="${dto.content}" /></textarea>
          </div>
        </div>

        <!-- 하단 액션 -->
        <div class="d-flex justify-content-between align-items-center pt-2">
          <div class="text-muted small">
            <i class="bi bi-shield-check mr-1"></i>폼 전송 시 저장됩니다.
          </div>
          <div>
            <a class="btn btn-outline-secondary mr-2" href="${ctx}/detail.do?bcode=${dto.bcode}">
              취소
            </a>
            <button class="btn btn-primary" type="submit">
              <i class="bi bi-check2-circle mr-1"></i> 저장
            </button>
          </div>
        </div>
      </form>
    </div>
  </div>

  <!-- 하단 빠른 이동 -->
  <div class="d-flex justify-content-end mt-3">
    <a class="btn btn-light btn-sm mr-2" href="${ctx}/list.do"><i class="bi bi-arrow-left-circle mr-1"></i> 목록으로</a>
    <a class="btn btn-outline-dark btn-sm" href="${ctx}/writeForm.do"><i class="bi bi-plus-circle mr-1"></i> 새 글</a>
  </div>
</div>

</body>
</html>
