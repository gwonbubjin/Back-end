<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 가입</title>
</head>
<body>
    <h2>회원 가입</h2>
    <form action="result.jsp" method="post">
        <label>이름: <input type="text" name="name" required></label><br><br>
        <label>이메일: <input type="email" name="email" required></label><br><br>
        <label>비밀번호: <input type="password" name="password" required></label><br><br>
        
        <label>성별:</label>
        <input type="radio" name="gender" value="남성" required> 남성
        <input type="radio" name="gender" value="여성" required> 여성
        <br><br>

        <label>관심 분야:</label><br>
        <input type="checkbox" name="interests" value="프로그래밍"> 프로그래밍
        <input type="checkbox" name="interests" value="여행"> 여행
        <input type="checkbox" name="interests" value="음악"> 음악
        <input type="checkbox" name="interests" value="운동"> 운동
        <br><br>

        <label>국가 선택:</label>
        <select name="country">
            <option value="대한민국">대한민국</option>
            <option value="미국">미국</option>
            <option value="영국">영국</option>
            <option value="일본">일본</option>
        </select>
        <br><br>

        <input type="submit" value="가입하기">
    </form>
</body>
</html>
