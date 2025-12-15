<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%--
*******************************************************************************
* [edit_form.jsp]
* 설명 : 회원 개인정보(닉네임, 이메일, 비밀번호) 수정 화면
* 접근 권한 : check_pw.jsp에서 비밀번호 검증을 통과한 세션만 접근 가능
* 주요 기능 :
* 1. 기존 정보(이름, 이메일) 표시 및 수정
* 2. 비밀번호 변경 (새 비밀번호 입력 + 확인)
* 3. JavaScript를 이용한 입력값 유효성 검사 (일치 여부, 길이 등)
*******************************************************************************
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>RateGo - 개인정보 수정</title>
    
    <!-- 
    =================================================================
      EXTERNAL LIBRARIES
    =================================================================
    -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">

    <!-- 
    =================================================================
      CUSTOM CSS (MyPage Layout)
    =================================================================
    -->
    <style>
        /* [ROOT VARIABLES] */
        :root {
            --primary-gold: #FCD535;
            --primary-dark: #1E2329;
            --text-gray: #848e9c;
            --glass-bg: rgba(30, 35, 41, 0.75);
            --glass-border: rgba(255, 255, 255, 0.08);
            --neon-shadow: 0 0 10px rgba(252, 213, 53, 0.3);
        }

        /* [LAYOUT] */
        body {
            background: radial-gradient(circle at 50% -20%, #2b3139, #0b0e11 90%);
            color: #eaecef; font-family: 'Pretendard', sans-serif;
            min-height: 100vh; margin: 0; padding: 25px 0;
        }
        
        /* 마이페이지 전용 컨테이너 (Navbar 없음) */
        .container { max-width: 1200px; } 

        /* [GLASS CARD STYLE] 유리 질감 박스 */
        .glass-box {
            background: var(--glass-bg); backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border); border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.5);
        }

        /* [FORM INPUTS] 다크 테마 입력창 */
        .input-dark {
            background: #0b0e11; border: 1px solid #474d57; 
            color: white; border-radius: 6px; font-size: 0.9rem;
        }
        .input-dark:focus { border-color: var(--primary-gold); outline: none; box-shadow: 0 0 5px rgba(252, 213, 53, 0.3); }
        
        /* [BUTTONS] */
        .btn-gold { 
            background: var(--primary-gold); color: black; font-weight: 800; border: none; 
            padding: 8px 20px; border-radius: 6px; transition: all 0.2s; 
        }
        .btn-gold:hover { background: #e0bd2f; transform: translateY(-2px); }
    </style>
</head>
<body>

    <div class="container">
        <h3 class="fw-bold text-white mb-4">개인정보 수정</h3>

        <div class="row">
            
            <!-- 
            =================================================================
              [LEFT SIDEBAR] 마이페이지 메뉴
            =================================================================
            -->
            <div class="col-lg-3">
                <div class="glass-box p-3">
                    <!-- 프로필 요약 -->
                    <div class="text-center mb-3">
                        <i class="fa-solid fa-user-circle fa-4x text-secondary"></i>
                        <h5 class="mt-2 text-gold">${sessionScope.user.userName}</h5>
                        <p class="small text-secondary">@${sessionScope.user.userId}</p>
                    </div>
                    
                    <!-- 네비게이션 링크 -->
                    <div class="list-group list-group-flush">
                        <a href="mypage.do" class="list-group-item list-group-item-action bg-transparent text-white border-0">
                            <i class="fa-solid fa-gauge me-2"></i> 활동 요약
                        </a>
                        <!-- 현재 페이지 활성화 (active) -->
                        <a href="checkPw.do" class="list-group-item list-group-item-action bg-transparent text-white border-0 active">
                            <i class="fa-solid fa-user-edit me-2"></i> 정보 수정
                        </a>
                        <a href="mypage/activity.do" class="list-group-item list-group-item-action bg-transparent text-white border-0">
                            <i class="fa-solid fa-clock-rotate-left me-2"></i> 전체 활동
                        </a>
                        <a href="mypage/points.do" class="list-group-item list-group-item-action bg-transparent text-white border-0">
                            <i class="fa-solid fa-wallet me-2"></i> 포인트 관리
                        </a>
                    </div>
                </div>
            </div>

            <!-- 
            =================================================================
              [RIGHT CONTENT] 정보 수정 폼
            =================================================================
            -->
            <div class="col-lg-9">
                <div class="glass-box p-4">
                    <h5 class="fw-bold border-bottom pb-2 mb-4">개인 정보 변경</h5>
                    
                    <!-- Form Start -->
                    <form action="update.do" method="post" class="needs-validation">
                        
                        <!-- 아이디는 수정 불가 (Primary Key) -->
                        <input type="hidden" name="userId" value="${sessionScope.user.userId}">
                        
                        <!-- 1. 닉네임 수정 -->
                        <div class="mb-4 row">
                            <label for="userName" class="col-sm-3 col-form-label text-gold fw-bold">닉네임</label>
                            <div class="col-sm-9">
                                <input type="text" name="userName" value="${sessionScope.user.userName}" 
                                       class="form-control input-dark" required style="height: 40px;">
                                <div class="form-text text-secondary">커뮤니티에서 사용할 이름입니다.</div>
                            </div>
                        </div>
                        
                        <!-- 2. 이메일 수정 -->
                        <div class="mb-4 row">
                            <label for="userEmail" class="col-sm-3 col-form-label text-gold fw-bold">이메일</label>
                            <div class="col-sm-9">
                                <input type="email" name="userEmail" value="${sessionScope.user.userEmail}" 
                                       class="form-control input-dark" style="height: 40px;">
                                <div class="form-text text-secondary">환율 알림 등 중요 알림을 받을 주소입니다.</div>
                            </div>
                        </div>
                        
                        <hr class="border-secondary my-4">
                        
                        <!-- 3. 비밀번호 변경 (선택 사항) -->
                        <div class="mb-4 row">
                            <label for="newPw" class="col-sm-3 col-form-label text-gold fw-bold">새 비밀번호</label>
                            <div class="col-sm-9">
                                <input type="password" id="newPw" name="userPw" class="form-control input-dark" 
                                       placeholder="변경 시에만 입력하세요" style="height: 40px;">
                                <div class="form-text text-secondary">변경하지 않으려면 비워두세요.</div>
                            </div>
                        </div>

                        <!-- 4. 비밀번호 확인 -->
                        <div class="mb-5 row">
                            <label for="confirmPw" class="col-sm-3 col-form-label text-gold fw-bold">비밀번호 확인</label>
                            <div class="col-sm-9">
                                <input type="password" id="confirmPw" class="form-control input-dark" 
                                       placeholder="새 비밀번호를 다시 입력하세요" style="height: 40px;">
                                <!-- 에러 메시지 표시 영역 -->
                                <div class="form-text text-danger fw-bold" id="pwCheckMsg"></div>
                            </div>
                        </div>
                        
                        <!-- 버튼 영역 -->
                        <div class="text-end">
                            <button type="submit" id="updateBtn" class="btn btn-gold fw-bold">
                                <i class="fa-solid fa-save me-1"></i> 정보 수정
                            </button>
                        </div>
                    </form>
                    <!-- Form End -->
                    
                </div>
            </div>
        </div>
    </div>

    <!-- 
    =================================================================
      JAVASCRIPT VALIDATION
    =================================================================
    -->
    <script>
    // [VALIDATION] 비밀번호 변경 시 일치 여부 및 길이 확인
    document.getElementById('updateBtn').addEventListener('click', function(event) {
        const newPw = document.getElementById('newPw').value;
        const confirmPw = document.getElementById('confirmPw').value;
        const msgDiv = document.getElementById('pwCheckMsg');
        
        // 초기화
        msgDiv.innerHTML = ''; 

        // 1. 새 비밀번호를 입력했는데 확인란과 다를 경우
        if (newPw && newPw !== confirmPw) {
            msgDiv.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i> 새 비밀번호가 일치하지 않습니다.';
            msgDiv.style.color = '#f6465d'; // Danger Red
            event.preventDefault(); // 폼 전송 막기
            return;
        }
        
        // 2. 새 비밀번호를 입력했는데 4자 미만일 경우 (최소 길이 유효성 검사)
        if (newPw && newPw.length > 0 && newPw.length < 4) { 
            msgDiv.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i> 비밀번호는 최소 4자 이상이어야 합니다.';
            msgDiv.style.color = '#f6465d'; // Danger Red
            event.preventDefault(); // 폼 전송 막기
            return;
        }
        
        // 3. (옵션) 비밀번호를 비워두면 기존 비밀번호 유지 (Controller 처리)
    });
    </script>

</body>
</html>