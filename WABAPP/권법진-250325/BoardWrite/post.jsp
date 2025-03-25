<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

request.setCharacterEncoding("UTF-8");
    
    String name = request.getParameter("name");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    
    if (name == null || title == null || content == null) {
        name = "익명";
        title = "제목 없음";
        content = "내용 없음";
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 보기</title>
</head>
<body>
    <h2>게시글 내용</h2>
    <p><strong>작성자:</strong> <%= name %></p>
    <p><strong>제목:</strong> <%= title %></p>
    <p><strong>내용:</strong></p>
    <pre><%= content %></pre>
    <br>
    <a href="write.jsp">새 글 작성</a>
</body>
</html>
