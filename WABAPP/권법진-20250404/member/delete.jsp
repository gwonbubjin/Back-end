<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    String id = request.getParameter("id");

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/gwondb", "root", "1111");

        String sql = "DELETE FROM member WHERE id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, id);

        pstmt.executeUpdate();

        pstmt.close();
        con.close();

        response.sendRedirect("list.jsp");
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("list.jsp");
    }
%>
