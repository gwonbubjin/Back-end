<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>게시판 목록</title>

  <!-- Bootstrap 4.6 -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link  rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

  <!-- 프로젝트 공통 CSS -->
  <c:url var="boardCss" value="/css/board.css">
    <c:param name="v" value="7"/>
  </c:url>
  <link rel="stylesheet" href="${boardCss}" />
</head>
<body>

<div class="container my-4">

  <!-- 상단 타이틀/툴바 -->
  <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between mb-3">
    <div class="d-flex align-items-center mb-2 mb-md-0">
      <h1 class="h3 mb-0 font-weight-bold mr-2">게시판</h1>
      <span class="badge badge-pill badge-primary">총 <c:out value="${totalCount}" />개</span>
    </div>

    <!-- 초기화면 / 글쓰기 버튼 -->
    <div class="btn-toolbar">
      <a class="btn btn-secondary btn-sm mr-1" href="<c:url value='/index.do'/>">
        <i class="bi bi-house-door"></i> 초기화면
      </a>
      <a class="btn btn-primary btn-sm" href="<c:url value='/insertForm.do'/>">
        <i class="bi bi-pencil-square"></i> 글쓰기
      </a>
    </div>
  </div>

  <!-- 목록 테이블 -->
  <div class="table-responsive">
    <table class="table table-hover table-sm mb-0">
      <thead class="thead-light">
        <tr class="text-muted">
          <th style="width:90px">번호</th>
          <th>제목</th>
          <th style="width:180px">작성자</th>
          <th style="width:160px">작성일</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="row" items="${list}" varStatus="st">
          <tr>
            <td class="text-monospace">
              ${totalCount - ((p - 1) * pageSize) - st.index}
            </td>

            <!-- 상세보기 링크 -->
            <c:url var="detailUrl" value="/detail.do">
              <c:param name="bcode" value="${row.bcode}" />
              <c:param name="p" value="${p}" />
            </c:url>
            <td class="text-truncate" style="max-width: 520px;">
              <a href="${detailUrl}" class="d-inline-flex align-items-center">
                <i class="bi bi-file-text mr-2"></i>
                <c:out value="${row.subject}" />
              </a>
            </td>

            <td>
              <i class="bi bi-person mr-1"></i>
              <c:out value="${row.writer}" />
            </td>

            <td>
              <i class="bi bi-calendar3 mr-1"></i>
              <fmt:formatDate value="${row.regdate}" pattern="yyyy-MM-dd" />
            </td>
          </tr>
        </c:forEach>

        <!-- Empty state -->
        <c:if test="${empty list}">
          <tr>
            <td colspan="4" class="text-center text-muted py-5">
              <div class="mb-2"><i class="bi bi-inbox" style="font-size:1.6rem;"></i></div>
              아직 작성된 게시글이 없습니다.
            </td>
          </tr>
        </c:if>
      </tbody>
    </table>
  </div>

  <!-- 페이지네이션 -->
  <nav aria-label="페이지" class="mt-3">
    <ul class="pagination justify-content-center pagination-sm">

      <!-- First -->
      <c:choose>
        <c:when test="${p <= 1}">
          <li class="page-item disabled">
            <a class="page-link" href="#" tabindex="-1" aria-disabled="true">&laquo; First</a>
          </li>
        </c:when>
        <c:otherwise>
          <c:url var="firstUrl" value="/list.do">
            <c:param name="p" value="1" />
          </c:url>
          <li class="page-item"><a class="page-link" href="${firstUrl}">&laquo; First</a></li>
        </c:otherwise>
      </c:choose>

      <!-- Prev -->
      <c:choose>
        <c:when test="${startNum <= 1}">
          <li class="page-item disabled">
            <a class="page-link" href="#" tabindex="-1" aria-disabled="true">Previous</a>
          </li>
        </c:when>
        <c:otherwise>
          <c:url var="prevUrl" value="/list.do">
            <c:param name="p" value="${startNum-1}" />
          </c:url>
          <li class="page-item"><a class="page-link" href="${prevUrl}">Previous</a></li>
        </c:otherwise>
      </c:choose>

      <!-- Page numbers -->
      <c:forEach var="i" begin="0" end="4">
        <c:if test="${startNum + i <= lastNum}">
          <c:set var="pageNo" value="${startNum + i}" />
          <c:url var="pageUrl" value="/list.do">
            <c:param name="p" value="${pageNo}" />
          </c:url>
          <li class="page-item ${pageNo == p ? 'active' : ''}">
            <a class="page-link" href="${pageUrl}">${pageNo}</a>
          </li>
        </c:if>
      </c:forEach>

      <!-- Next -->
      <c:choose>
        <c:when test="${startNum + numOfPages > lastNum}">
          <li class="page-item disabled">
            <a class="page-link" href="#" tabindex="-1" aria-disabled="true">Next</a>
          </li>
        </c:when>
        <c:otherwise>
          <c:url var="nextUrl" value="/list.do">
            <c:param name="p" value="${startNum + numOfPages}" />
          </c:url>
          <li class="page-item"><a class="page-link" href="${nextUrl}">Next</a></li>
        </c:otherwise>
      </c:choose>

      <!-- Last -->
      <c:choose>
        <c:when test="${p >= lastNum}">
          <li class="page-item disabled">
            <a class="page-link" href="#" tabindex="-1" aria-disabled="true">Last &raquo;</a>
          </li>
        </c:when>
        <c:otherwise>
          <c:url var="lastUrl" value="/list.do">
            <c:param name="p" value="${lastNum}" />
          </c:url>
          <li class="page-item"><a class="page-link" href="${lastUrl}">Last &raquo;</a></li>
        </c:otherwise>
      </c:choose>

    </ul>
  </nav>

</div>
</body>
</html>
