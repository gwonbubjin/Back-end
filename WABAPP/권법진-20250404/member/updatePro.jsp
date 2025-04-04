<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	String pwd = request.getParameter("pwd");
	
	try {
		Class.forName("org.mariadb.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");
		
		String sql = "UPDATE member SET name = ?, pwd = ? WHERE userID = ?";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setString(2, pwd);
		pstmt.setString(3, id);
		
		pstmt.executeUpdate();
		
		pstmt.close();
		con.close();
		
		response.sendRedirect("list.jsp");
		
	} catch(Exception e) {
		e.printStackTrace();
		response.sendRedirect("updateForm.jsp?id=" + id);
	}
%>



