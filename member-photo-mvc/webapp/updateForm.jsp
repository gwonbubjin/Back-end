<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>사용자 정보 변경</title>
    <!-- Bootstrap CSS & JS -->
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container mt-4">
        <h2 class="text-center mb-4">사용자 정보 변경</h2>
        <form action="update.do" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="id">ID:</label>
                <input type="text" class="form-control" id="id" name="id"
                       value="${dto.id}" readonly>
            </div>
            <div class="form-group">
                <label for="name">NAME:</label>
                <input type="text" class="form-control" id="name" name="name"
                       value="${dto.name}">
            </div>
            <div class="form-group">
                <label for="pwd">PASSWORD:</label>
                <input type="password" class="form-control" id="pwd" name="pwd"
                       value="${dto.pwd}">
            </div>
            <div class="form-group">
                <label for="photo">PHOTO:</label>
                <div class="mb-2">
                    <img src="photos/${dto.photo}" width="100" height="80" alt="current photo">
                    <span>${dto.photo}</span>
                </div>
                <input type="file" class="form-control-file" id="photo" name="photo">
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-primary mx-1">변경</button>
                <button type="button" class="btn btn-danger mx-1"
                        onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='delete.do?id=${dto.id}'">
                    삭제
                </button>
                <button type="button" class="btn btn-secondary mx-1"
                        onclick="location.href='list.do'">
                    목록으로
                </button>
            </div>
        </form>
    </div>
</body>
</html>
