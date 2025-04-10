<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
	request.setCharacterEncoding("UTF-8");
	String userID = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	String name = request.getParameter("name");
	String gender = request.getParameter("gender");
	String phone = request.getParameter("phone");
	String email = request.getParameter("email");
	String address = request.getParameter("address");
	String stuID = request.getParameter("stuID");
	
	try {
		Class.forName("org.mariadb.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");
		
		String sql = "INSERT INTO member(userID, pwd, NAME, gender, phone, regdate, email, address, stuID) VALUES (?, ?, ?, ?, ?, NOW(), ?, ?, ?)";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, userID);
		pstmt.setString(2, pwd);
		pstmt.setString(3, name);
		pstmt.setString(4, gender);
		pstmt.setString(5, phone);
		pstmt.setString(6, email);
		pstmt.setString(7, address);
		pstmt.setString(8, stuID);
		
		pstmt.executeUpdate();
		
		pstmt.close();
		con.close();
		
		response.sendRedirect("list.jsp");
		
	} catch(Exception e) {
		e.printStackTrace();
		response.sendRedirect("insertForm.jsp");
	}
%>
