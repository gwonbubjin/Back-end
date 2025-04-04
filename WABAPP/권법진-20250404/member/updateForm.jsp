<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
	String id = request.getParameter("id");
	String name = "";
	String pwd = "";
	
	try {
		Class.forName("org.mariadb.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");
		
		String sql = "SELECT * FROM member WHERE userID = ?";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, id);
		ResultSet rs = pstmt.executeQuery();
		
		if(rs.next()) {
			name = rs.getString("name");
			pwd = rs.getString("pwd");
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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container"><br>	
	<h1 class="text-center font-weight-bold">회원정보 수정</h1>
	<br>
	<form action="updatePro.jsp" method="post">
		<div class="form-group">
			<label for="id">아이디:</label>
			<input type="text" class="form-control" id="id" name="id" value="<%=id %>" readonly>
		</div>
		<div class="form-group">
			<label for="name">이름:</label>
			<input type="text" class="form-control" id="name" name="name" value="<%=name %>" required>
		</div>
		<div class="form-group">
			<label for="pwd">비밀번호:</label>
			<input type="password" class="form-control" id="pwd" name="pwd" value="<%=pwd %>" required>
		</div>
		<div class="text-center">
			<button type="submit" class="btn btn-primary">수정하기</button>
			<a href="list.jsp" class="btn btn-secondary">취소</a>
		</div>
	</form>
	</div>	
</body>
</html>