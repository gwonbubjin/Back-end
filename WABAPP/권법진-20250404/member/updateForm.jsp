<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
	String id = request.getParameter("id");
	String name = "";
	String pwd = "";
	String gender = "";
	String phone = "";
	String email = "";
	String address = "";
	String stuID = "";

	try {
		Class.forName("org.mariadb.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");

		String sql = "SELECT * FROM member WHERE id = ?";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, id);
		ResultSet rs = pstmt.executeQuery();

		if(rs.next()) {
			name = rs.getString("name");
			pwd = rs.getString("pwd");
			gender = rs.getString("gender");
			phone = rs.getString("phone");
			email = rs.getString("email");
			address = rs.getString("address");
			stuID = rs.getString("stuID");
		}

		rs.close();
		pstmt.close();
		con.close();

	} catch(Exception e) {
		e.printStackTrace();
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원정보 수정</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
</head>
<body>
	<div class="container"><br>	
	<h1 class="text-center font-weight-bold">회원정보 수정</h1>
	<br>
	<form action="updatePro.jsp" method="post">
		<input type="hidden" name="id" value="<%= id %>">
		
		<div class="form-group">
			<label for="pwd">비밀번호:</label>
			<input type="password" class="form-control" id="pwd" name="pwd" value="<%= pwd %>" required>
		</div>
		<div class="form-group">
			<label for="name">이름:</label>
			<input type="text" class="form-control" id="name" name="name" value="<%= name %>" required>
		</div>
		<div class="form-group">
			<label for="gender">성별:</label>
			<input type="text" class="form-control" id="gender" name="gender" value="<%= gender %>">
		</div>
		<div class="form-group">
			<label for="phone">전화번호:</label>
			<input type="text" class="form-control" id="phone" name="phone" value="<%= phone %>">
		</div>
		<div class="form-group">
			<label for="email">이메일:</label>
			<input type="email" class="form-control" id="email" name="email" value="<%= email %>">
		</div>
		<div class="form-group">
			<label for="address">주소:</label>
			<input type="text" class="form-control" id="address" name="address" value="<%= address %>">
		</div>
		<div class="form-group">
			<label for="stuID">학번:</label>
			<input type="text" class="form-control" id="stuID" name="stuID" value="<%= stuID %>">
		</div>

		<div class="text-center">
			<button type="submit" class="btn btn-primary">수정하기</button>
			<a href="list.jsp" class="btn btn-secondary">취소</a>
		</div>
	</form>
	</div>	
</body>
</html>
