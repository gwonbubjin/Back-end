<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container"><br>	
	<h1 class="text-center font-weight-bold">회원가입</h1>
	<br>
	<form action="insertPro.jsp" method="post">
		<div class="form-group">
			<label for="id">아이디:</label>
			<input type="text" class="form-control" id="id" name="id" required>
		</div>
		<div class="form-group">
			<label for="pwd">비밀번호:</label>
			<input type="password" class="form-control" id="pwd" name="pwd" required>
		</div>
		<div class="form-group">
			<label for="name">이름:</label>
			<input type="text" class="form-control" id="name" name="name" required>
		</div>
		<div class="form-group">
			<label for="gender">성별:</label>
			<select class="form-control" id="gender" name="gender">
				<option value="남성">남성</option>
				<option value="여성">여성</option>
			</select>
		</div>
		<div class="form-group">
			<label for="phone">전화번호:</label>
			<input type="text" class="form-control" id="phone" name="phone" placeholder="010-1234-5678" pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}">
		</div>
		<div class="form-group">
			<label for="email">이메일:</label>
			<input type="email" class="form-control" id="email" name="email">
		</div>
		<div class="form-group">
			<label for="address">주소:</label>
			<input type="text" class="form-control" id="address" name="address">
		</div>
		<div class="form-group">
			<label for="stuID">학번:</label>
			<input type="text" class="form-control" id="stuID" name="stuID">
		</div>
		<div class="text-center">
			<button type="submit" class="btn btn-primary">가입하기</button>
			<a href="index.jsp" class="btn btn-secondary">취소</a>
		</div>
	</form>
	</div>	
</body>
</html>


