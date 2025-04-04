<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    request.setCharacterEncoding("UTF-8");
    String title = request.getParameter("title");
    String writer = request.getParameter("writer");
    String content = request.getParameter("content");
    
    Connection con = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("org.mariadb.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");
        
        String sql = "INSERT INTO board(title, writer, content, regdate, readcount) VALUES(?, ?, ?, NOW(), 0)";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, writer);
        pstmt.setString(3, content);
        
        pstmt.executeUpdate();
        
        response.sendRedirect("list.jsp");
        
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(con != null) try { con.close(); } catch(Exception e) {}
    }
%>