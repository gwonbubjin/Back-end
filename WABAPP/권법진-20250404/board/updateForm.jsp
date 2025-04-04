<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    int num = Integer.parseInt(request.getParameter("num"));
    
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String title = "";
    String content = "";
    String writer = "";
    
    try {
        Class.forName("org.mariadb.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");
        
        String sql = "SELECT * FROM board WHERE num = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, num);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            title = rs.getString("title");
            writer = rs.getString("writer");
            content = rs.getString("content");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(con != null) try { con.close(); } catch(Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
</head>
<body>
    <h2>게시글 수정</h2>
    
    <form action="updatePro.jsp" method="post">
        <input type="hidden" name="num" value="<%=num%>">
        <table>
            <tr>
                <td>제목</td>
                <td><input type="text" name="title" value="<%=title%>" required></td>
            </tr>
            <tr>
                <td>작성자</td>
                <td><input type="text" name="writer" value="<%=writer%>" readonly></td>
            </tr>
            <tr>
                <td>내용</td>
                <td>
                    <textarea name="content" rows="10" cols="50" required><%=content%></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="수정">
                    <input type="button" value="취소" onclick="location.href='content.jsp?num=<%=num%>'">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>