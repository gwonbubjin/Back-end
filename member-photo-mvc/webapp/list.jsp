<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>사용자 목록</title>
    <!-- Bootstrap CSS & JS -->
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container mt-4">
        <h1 class="text-center mb-4">사용자 정보</h1>

        <!-- 목록 테이블 -->
        <table class="table table-hover">
            <thead class="thead-dark">
                <tr>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>비밀번호</th>
                    <th>사진</th>
                    <th>삭제</th>
                    <th>수정</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="dto" items="${dtos}">
                    <tr>
                        <td>
                            <a href="get.do?id=${dto.id}">
                                ${dto.id}
                            </a>
                        </td>
                        <td>${dto.name}</td>
                        <td>${dto.pwd}</td>
                        <td>
                            <a download href="photos/${dto.photo}">
                                <img src="photos/${dto.photo}"
                                     width="100" height="80" alt="photo"/>
                            </a>
                        </td>
                        <td>
                            <a href="delete.do?id=${dto.id}"
                               onclick="return confirm('정말 삭제하시겠습니까?');">
                                삭제
                            </a>
                        </td>
                        <td>
                            <a href="get.do?id=${dto.id}">수정</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- 페이지 하단 버튼 -->
        <div class="text-center mt-3">
            <a href="insertForm.do" class="btn btn-primary mx-2">새 회원 등록</a>
            <a href="index.do" class="btn btn-secondary mx-2">메인으로</a>
        </div>
    </div>
</body>
</html>