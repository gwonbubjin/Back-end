<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String pwd = request.getParameter("pwd");
    String gender = request.getParameter("gender");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    String address = request.getParameter("address");
    String stuID = request.getParameter("stuID");

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");

        String sql = "UPDATE member SET pwd = ?, name = ?, gender = ?, phone = ?, email = ?, address = ?, stuID = ? WHERE id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, pwd);
        pstmt.setString(2, name);
        pstmt.setString(3, gender);
        pstmt.setString(4, phone);
        pstmt.setString(5, email);
        pstmt.setString(6, address);
        pstmt.setString(7, stuID);
        pstmt.setString(8, id);

        pstmt.executeUpdate();

        pstmt.close();
        con.close();

        response.sendRedirect("list.jsp");

    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("updateForm.jsp?id=" + id);
    }
%>
