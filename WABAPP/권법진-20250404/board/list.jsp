<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    // 페이지 처리
    int pageSize = 10; 
    int pageNum = 1;  
    
    if(request.getParameter("pageNum") != null) {
        pageNum = Integer.parseInt(request.getParameter("pageNum"));
    }
    
    int startRow = (pageNum - 1) * pageSize;
    
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int totalCount = 0; 
    
    try {
        Class.forName("org.mariadb.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/gwondb", "root", "1111");
        
        // 전체 게시글 수 구하기
        String countSql = "SELECT COUNT(*) FROM board";
        pstmt = con.prepareStatement(countSql);
        rs = pstmt.executeQuery();
        if(rs.next()) {
            totalCount = rs.getInt(1);
        }
        
        String sql = "SELECT * FROM board ORDER BY num DESC LIMIT ?, ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, startRow);
        pstmt.setInt(2, pageSize);
        rs = pstmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f5f5f5;
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
        .btn:hover {
            background-color: #45a049;
        }
        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a {
            color: black;
            padding: 8px 16px;
            text-decoration: none;
            border: 1px solid #ddd;
            margin: 0 4px;
        }
        .pagination a.active {
            background-color: #4CAF50;
            color: white;
            border: 1px solid #4CAF50;
        }
    </style>
</head>
<body>
    <div style="width: 80%; margin: 0 auto;">
        <h1 style="text-align: center;">😊게시판😊</h1>
        
        <div style="text-align: right;">
            <a href="writeForm.jsp" class="btn">글쓰기</a>
        </div>
        
        <table>
            <tr>
                <th width="10%">번호</th>
                <th width="40%">제목</th>
                <th width="15%">작성자</th>
                <th width="20%">작성일</th>
                <th width="15%">조회수</th>
            </tr>
<%
        while(rs.next()) {
            int num = rs.getInt("num");
            String title = rs.getString("title");
            String writer = rs.getString("writer");
            String regdate = rs.getString("regdate").substring(0, 16); // 날짜 형식 간단히
            int readcount = rs.getInt("readcount");
%>
            <tr>
                <td><%=num%></td>
                <td style="text-align: left;">
                    <a href="content.jsp?num=<%=num%>" style="text-decoration: none; color: #333;">
                        <%=title%>
                    </a>
                </td>
                <td><%=writer%></td>
                <td><%=regdate%></td>
                <td><%=readcount%></td>
            </tr>
<%
        }
%>
        </table>
        
        <div class="pagination">
<%
            int totalPages = (totalCount + pageSize - 1) / pageSize;
            int startPage = ((pageNum - 1) / 10) * 10 + 1;
            int endPage = startPage + 9;
            if(endPage > totalPages) endPage = totalPages;
            
            if(startPage > 1) {
%>
                <a href="list.jsp?pageNum=<%=startPage-1%>">&laquo;</a>
<%
            }
            
            for(int i = startPage; i <= endPage; i++) {
%>
                <a href="list.jsp?pageNum=<%=i%>" <%=pageNum == i ? "class='active'" : ""%>><%=i%></a>
<%
            }
            
            if(endPage < totalPages) {
%>
                <a href="list.jsp?pageNum=<%=endPage+1%>">&raquo;</a>
<%
            }
%>
        </div>
    </div>
<%
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