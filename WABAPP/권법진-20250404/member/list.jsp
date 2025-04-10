<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

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
	<title>회원 목록</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
	<h2 class="text-center">회원 목록</h2>
	<a href="insertForm.jsp" class="btn btn-primary mb-3">회원가입</a>

	<table class="table table-bordered table-hover text-center">
		<thead class="thead-dark">
			<tr>
				<th>아이디</th>
				<th>비밀번호</th>
				<th>이름</th>
				<th>성별</th>
				<th>전화번호</th>
				<th>이메일</th>
				<th>주소</th>
				<th>학번</th>
				<th>관리</th>
			</tr>
		</thead>
		<tbody>
		<%
			while(rs.next()) {
				String id = rs.getString("id");
				String pwd = rs.getString("pwd");
				String name = rs.getString("name");
				String gender = rs.getString("gender");
				String phone = rs.getString("phone");
				String email = rs.getString("email");
				String address = rs.getString("address");
				String stuID = rs.getString("stuID");
		%>
			<tr>
				<td><%= id %></td>
				<td><%= pwd %></td>
				<td><%= name %></td>
				<td><%= gender %></td>
				<td><%= phone %></td>
				<td><%= email %></td>
				<td><%= address %></td>
				<td><%= stuID %></td>
				<td>
					<a href="updateForm.jsp?id=<%= id %>" class="btn btn-warning btn-sm">수정</a>
					<a href="delete.jsp?id=<%= rs.getString("id") %>" class="btn btn-danger btn-sm" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>

				</td>
			</tr>
		<%
			}
			rs.close();
			st.close();
			con.close();
		%>
		</tbody>
	</table>
</div>
</body>
</html>
