<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    int num = Integer.parseInt(request.getParameter("num"));
    
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("org.mariadb.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");
        
        // 조회수 증가
        String updateSql = "UPDATE board SET readcount = readcount + 1 WHERE num = ?";
        pstmt = con.prepareStatement(updateSql);
        pstmt.setInt(1, num);
        pstmt.executeUpdate();
        
        // 게시글 가져오기
        String sql = "SELECT * FROM board WHERE num = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, num);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            String title = rs.getString("title");
            String writer = rs.getString("writer");
            String content = rs.getString("content").replace("\n", "<br>");
            String regdate = rs.getString("regdate");
            int readcount = rs.getInt("readcount");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 보기</title>
    <style>
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
        .board-view {
            border-top: 2px solid #333;
            border-bottom: 2px solid #333;
        }
        .board-view .header {
            padding: 20px 15px;
            border-bottom: 1px solid #ddd;
        }
        .board-view .title {
            font-size: 24px;
            margin-bottom: 10px;
        }
        .board-view .info {
            color: #666;
        }
        .board-view .info span {
            margin-right: 20px;
        }
        .board-view .content {
            padding: 20px 15px;
            min-height: 200px;
            line-height: 1.6;
        }
        .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin: 5px;
        }
        .btn.delete {
            background-color: #f44336;
        }
        .btn:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="board-view">
            <div class="header">
                <h2 class="title"><%=title%></h2>
                <div class="info">
                    <span>작성자: <%=writer%></span>
                    <span>작성일: <%=regdate%></span>
                    <span>조회수: <%=readcount%></span>
                </div>
            </div>
            <div class="content">
                <%=content%>
            </div>
        </div>
        
        <div style="margin-top: 20px; text-align: center;">
            <a href="updateForm.jsp?num=<%=num%>" class="btn">수정</a>
            <a href="#" onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='delete.jsp?num=<%=num%>'" class="btn delete">삭제</a>
            <a href="list.jsp" class="btn">목록</a>
        </div>
    </div>

<%
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(con != null) try { con.close(); } catch(Exception e) {}
    }
%>
</body>
</html>