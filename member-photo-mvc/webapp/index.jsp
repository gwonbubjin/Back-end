<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메인 화면</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <!-- jQuery, Popper.js, Bootstrap JS -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</head>
<body>
    <!-- 헤더 -->
    <div class="jumbotron text-center mb-0">
        <h1>My First Member Management</h1>
        <p>나의 첫 번째 사용자 관리 프로그램</p>
    </div>

    <!-- 네비게이션 바 -->
    <nav class="navbar navbar-expand-sm bg-dark navbar-dark">
        <a class="navbar-brand" href="index.do">Home</a>
        <button class="navbar-toggler" type="button"
                data-toggle="collapse" data-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="list.do">멤버 목록</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="insertForm.do">멤버 입력</a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- 메인 버튼 -->
    <div class="container text-center mt-4">
        <a href="list.do" class="btn btn-primary mx-2">멤버 목록</a>
        <a href="insertForm.do" class="btn btn-secondary mx-2">멤버 입력</a>
    </div>
</body>
</html>
