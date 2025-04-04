<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    int num = Integer.parseInt(request.getParameter("num"));
    
    Connection con = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("org.mariadb.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");
        
        String sql = "DELETE FROM board WHERE num=?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, num);
        
        pstmt.executeUpdate();
        
        response.sendRedirect("list.jsp");
        
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(con != null) try { con.close(); } catch(Exception e) {}
    }
%>