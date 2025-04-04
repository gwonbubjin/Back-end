<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%

	Class.forName("org.mariadb.jdbc.Driver");
	
	Connection con = null;
	Statement st = null;
	ResultSet rs = null;
	
	try {
		con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");
		
		st = con.createStatement();
		
		rs = st.executeQuery("SELECT * FROM member");
	} catch(Exception e) {
		e.printStackTrace();
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>사용자 목록</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
	<script>
		function confirmDelete(userID) {
			if(confirm("정말 삭제하시겠습니까?")) {
				location.href = "delete.jsp?id=" + userID;
			}
		}
	</script>
</head>
<body>
	<div class="container"><br>	
	<h1 class="text-center font-weight-bold">사용자 정보</h1>
	<br>
	<table class="table table-hover">
		<tr>
			<th>아이디</th>
			<th>이름</th>
			<th>비밀번호</th>
			<th>관리</th>
		</tr>
<% 
	//5. 결과집합 처리 
	while(rs.next()) {
		String userID = rs.getString("userID");
		String name = rs.getString("name");
		String pwd = rs.getString("pwd");
%>	
		<tr>
			<td><%=userID %></td>
			<td><%=name %></td>
			<td><%=pwd %></td>
			<td>
				<a href="updateForm.jsp?id=<%=userID %>" class="btn btn-primary btn-sm">수정</a>
				<button onclick="confirmDelete('<%=userID %>')" class="btn btn-danger btn-sm">삭제</button>
			</td>
		</tr>
<%} 

	rs.close();
	st.close();
	con.close();
%>
	</table>
	<div class="text-center">
		<a href="insertForm.jsp" class="btn btn-success">새 회원 등록</a>
		<a href="index.jsp" class="btn btn-secondary">메인으로</a>
	</div>
	</div>	
</body>
</html>