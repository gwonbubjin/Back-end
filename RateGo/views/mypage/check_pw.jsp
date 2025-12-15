<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%--
*******************************************************************************
* [check_pw.jsp]
* 설명 : 마이페이지 정보 수정 전 비밀번호 재확인 화면
* 주요 기능 :
* 1. 현재 비밀번호 입력 및 검증 요청 (checkPw.do)
* 2. 검증 실패 시 에러 메시지 출력 (c:if param.error)
* 디자인 : 좌측 이미지 / 우측 폼 분할 레이아웃 (Signup 페이지와 통일감 유지)
*******************************************************************************
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>RateGo - 개인정보 보호</title>
    
    <!-- 
    =================================================================
      EXTERNAL LIBRARIES
    =================================================================
    -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
    <!-- 애니메이션 라이브러리 (에러 시 흔들림 효과용) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet"/>

    <!-- 
    =================================================================
      CUSTOM CSS (Split Layout)
    =================================================================
    -->
    <style>
        /* [ROOT VARIABLES] */
        :root {
            --primary-gold: #FCD535;
            --dark-bg: #0b0e11;
            --input-bg: #1E2329;
        }

        /* [LAYOUT] 스크롤 방지 및 기본 폰트 설정 */
        body, html { 
            height: 100%; margin: 0; 
            font-family: 'Pretendard', sans-serif; 
            overflow: hidden; 
            background: var(--dark-bg); 
        }

        /* [LEFT SIDE] 이미지 영역 */
        .bg-image {
            /* 고화질 배경 이미지 (Unsplash) */
            background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=2070&auto=format&fit=crop');
            background-size: cover; 
            background-position: center; 
            position: relative; 
            height: 100vh;
        }
        /* 이미지 위를 덮는 반투명 그라데이션 오버레이 */
        .bg-overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to right, rgba(0,0,0,0.7), rgba(11, 14, 17, 1));
            display: flex; flex-direction: column; justify-content: center; padding: 60px;
        }

        /* [RIGHT SIDE] 입력 폼 영역 */
        .login-section {
            height: 100vh; 
            display: flex; align-items: center; justify-content: center;
            background-color: var(--dark-bg); 
            color: white; padding: 40px;
        }

        .form-wrapper { width: 100%; max-width: 450px; }

        /* 입력창 커스텀 (부트스트랩 오버라이딩) */
        .input-group-text {
            background-color: var(--input-bg); border: 1px solid #2f3336; border-right: none; color: var(--primary-gold);
        }
        .form-control {
            background-color: var(--input-bg) !important; 
            border: 1px solid #2f3336 !important; border-left: none !important;
            color: white !important; height: 50px;
        }
        .form-control:focus { box-shadow: none; border-color: var(--primary-gold) !important; }
        .input-group:focus-within .input-group-text { border-color: var(--primary-gold); }

        /* 확인 버튼 */
        .btn-gold {
            background: var(--primary-gold); color: black; font-weight: 800; border: none; height: 55px; width: 100%; 
            border-radius: 8px; font-size: 1.1rem; margin-top: 25px;
        }
        .btn-gold:hover { background: #e0bd2f; transform: translateY(-3px); }

        /* 타이포그래피 */
        .brand-title { font-size: 3.5rem; font-weight: 900; color: white; letter-spacing: -2px; margin-bottom: 10px; }
        .brand-slogan { font-size: 1.2rem; color: #b7bdc6; font-weight: 400; line-height: 1.6; }
        .brand-gold { color: var(--primary-gold); }
    </style>
</head>
<body>

    <!-- 
    =================================================================
      MAIN CONTAINER (Full Width/Height)
    =================================================================
    -->
    <div class="container-fluid h-100 p-0">
        <div class="row g-0 h-100">
            
            <!-- 1. [LEFT] 배경 이미지 및 슬로건 -->
            <div class="col-lg-6 d-none d-lg-block bg-image">
                <div class="bg-overlay">
                    <div style="margin-bottom: 50px;">
                        <i class="fa-solid fa-shield-alt fa-3x text-white mb-4"></i> 
                        <h1 class="brand-title">Secure Access <br>is <span class="brand-gold">Our Priority</span></h1>
                        <p class="brand-slogan">
                            개인 정보 보호를 위해,<br>
                            안전한 접속을 다시 한번 확인합니다.
                        </p>
                    </div>
                </div>
            </div>

            <!-- 2. [RIGHT] 비밀번호 확인 폼 -->
            <div class="col-lg-6 login-section">
                <div class="form-wrapper text-center">
                    
                    <!-- 뒤로가기 링크 -->
                    <a href="mypage.do" class="text-decoration-none text-secondary small fw-bold mb-5 d-inline-block">
                        <i class="fa-solid fa-arrow-left"></i> 마이페이지로 돌아가기
                    </a>

                    <h2 class="fw-bold text-white mb-2">개인정보 확인</h2>
                    <p class="text-secondary mb-4">정보 수정을 위해 비밀번호를 다시 입력해주세요.</p>
                    
                    <!-- 
                    =================================================================
                      FORM SUBMISSION
                      - Action: /mypage/checkPw.do (POST)
                    =================================================================
                    -->
                    <form action="checkPw.do" method="post">
                        
                        <!-- 비밀번호 입력 필드 -->
                        <div class="input-group mb-3 mx-auto" style="max-width: 300px;">
                            <span class="input-group-text"><i class="fa-solid fa-key"></i></span>
                            <input type="password" name="currentPw" class="form-control" placeholder="현재 비밀번호" required>
                        </div>
                        
                        <!-- 
                          [ERROR HANDLING]
                          - Controller에서 redirect 시 ?error=fail 파라미터를 보냄
                          - JSTL로 파라미터 확인 후 에러 메시지 출력 + 흔들림 효과(animate.css)
                        -->
                        <c:if test="${param.error eq 'fail'}">
                            <div class="text-danger small fw-bold mb-3 mt-2 animate__animated animate__shakeX" style="color: #f6465d;">
                                <i class="fa-solid fa-triangle-exclamation"></i> 비밀번호가 일치하지 않습니다.
                            </div>
                        </c:if>
                        
                        <button type="submit" class="btn btn-gold w-50 fw-bold">
                            확인
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>