<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판 글쓰기</title>
</head>
<body>
    <h2>게시판 글쓰기</h2>
    <form action="post.jsp" method="post">
        <label>이름: <input type="text" name="name" required></label><br><br>
        <label>제목: <input type="text" name="title" required></label><br><br>
        <label>내용:<br> <textarea name="content" rows="5" cols="50" required></textarea></label><br><br>
        <input type="submit" value="작성 완료">
    </form>
</body>
</html>
