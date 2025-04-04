<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글쓰기</title>
    <style>
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
        .write-form {
            border-top: 2px solid #333;
            border-bottom: 2px solid #333;
            padding: 20px;
        }
        .write-form input[type="text"], 
        .write-form textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .write-form textarea {
            min-height: 300px;
            resize: vertical;
        }
        .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 4px;
            margin: 5px;
            cursor: pointer;
        }
        .btn.cancel {
            background-color: #666;
        }
        .btn:hover {
            opacity: 0.8;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 style="text-align: center;">글쓰기</h2>
        
        <form action="writePro.jsp" method="post" class="write-form">
            <div>
                <label for="title">제목</label>
                <input type="text" id="title" name="title" required placeholder="제목을 입력하세요">
            </div>
            <div>
                <label for="writer">작성자</label>
                <input type="text" id="writer" name="writer" required placeholder="작성자를 입력하세요">
            </div>
            <div>
                <label for="content">내용</label>
                <textarea id="content" name="content" required placeholder="내용을 입력하세요"></textarea>
            </div>
            <div style="text-align: center; margin-top: 20px;">
                <button type="submit" class="btn">등록</button>
                <button type="button" class="btn cancel" onclick="location.href='list.jsp'">취소</button>
            </div>
        </form>
    </div>
</body>
</html>