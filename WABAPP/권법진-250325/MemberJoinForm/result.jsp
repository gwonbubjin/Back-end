<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 한글 깨짐 방지
    request.setCharacterEncoding("UTF-8");

    // 입력된 데이터 가져오기
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String gender = request.getParameter("gender");
    String country = request.getParameter("country");

    // 체크박스는 여러 개 선택될 수 있으므로 배열로 받기
    String[] interests = request.getParameterValues("interests");

    // 체크박스 선택값을 문자열로 변환
    String interestsStr = "없음";
    if (interests != null) {
        interestsStr = String.join(", ", interests);
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>가입 결과</title>
</head>
<body>
    <h2>가입 완료</h2>
    <p><strong>이름:</strong> <%= name %></p>
    <p><strong>이메일:</strong> <%= email %></p>
    <p><strong>비밀번호:</strong> <%= password %> (보안상 평문 저장은 금지!)</p>
    <p><strong>성별:</strong> <%= gender %></p>
    <p><strong>관심 분야:</strong> <%= interestsStr %></p>
    <p><strong>국가:</strong> <%= country %></p>
    
    <br>
    <a href="register.jsp">다시 가입하기</a>
</body>
</html>
