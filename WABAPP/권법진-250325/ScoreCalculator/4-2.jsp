<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
   
    String korStr = request.getParameter("kor");
    String engStr = request.getParameter("eng");
    String mathStr = request.getParameter("math");

    
    int kor = 0, eng = 0, math = 0;
    
    try {
        kor = Integer.parseInt(korStr);
        eng = Integer.parseInt(engStr);
        math = Integer.parseInt(mathStr);
    } catch (NumberFormatException e) {
        out.println("<p style='color:red;'>올바른 숫자를 입력해주세요.</p>");
    }

  
    int total = kor + eng + math;
    float avg = total / 3.0f; 

    
    String formattedAvg = String.format("%.2f", avg);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>점수 결과</title>
</head>
<body>
    <h2>점수 결과</h2>
    <p>국어 점수: <%= kor %>점</p>
    <p>영어 점수: <%= eng %>점</p>
    <p>수학 점수: <%= math %>점</p>
    <p>총점: <%= total %>점</p>
    <p>평균: <%= formattedAvg %>점</p>
    <br>
    <a href="4-1.jsp">다시 입력하기</a>
</body>
</html>
