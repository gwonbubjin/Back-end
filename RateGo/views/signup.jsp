<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>RateGo - Join Us</title>
    
    <!-- 
    =================================================================
      EXTERNAL LIBRARIES
    =================================================================
    -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 애니메이션 효과 (입력 폼 슬라이드 인) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

    <!-- 
    =================================================================
      CUSTOM CSS (Split Layout Theme)
    =================================================================
    -->
    <style>
        /* [ROOT VARIABLES] */
        :root {
            --primary-gold: #FCD535;
            --dark-bg: #0b0e11;
            --input-bg: #1E2329;
            --text-guide: #848e9c;
        }

        /* [LAYOUT] 스크롤 없이 꽉 찬 화면 */
        body, html { 
            height: 100%; margin: 0; 
            font-family: 'Pretendard', sans-serif; 
            overflow: hidden; 
            background: var(--dark-bg); 
        }

        /* [LEFT SECTION] 이미지 영역 */
        .bg-image {
            /* 고화질 여행 이미지 (Unsplash) */
            background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=2070&auto=format&fit=crop');
            background-size: cover; 
            background-position: center; 
            position: relative; 
            height: 100vh;
        }
        /* 이미지 위 그라데이션 오버레이 (텍스트 가독성 확보) */
        .bg-overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to right, rgba(0,0,0,0.6), rgba(11, 14, 17, 1));
            display: flex; flex-direction: column; justify-content: center; padding: 60px;
        }

        /* [RIGHT SECTION] 입력 폼 영역 */
        .login-section {
            height: 100vh; 
            display: flex; align-items: center; justify-content: center;
            background-color: var(--dark-bg); 
            color: white; padding: 40px;
        }

        /* 폼 래퍼 (등장 애니메이션 적용) */
        .form-wrapper { 
            width: 100%; max-width: 460px; 
            animation: slideIn 0.8s ease-out; 
        }

        /* [FORM ELEMENTS] 입력창 스타일 */
        .form-label { color: #b7bdc6; font-weight: 700; font-size: 0.9rem; margin-left: 2px; margin-bottom: 8px; }
        
        /* 아이콘이 들어가는 왼쪽 부분 */
        .input-group-text {
            background-color: var(--input-bg); border: 1px solid #2f3336; border-right: none; color: var(--primary-gold);
            border-top-left-radius: 8px; border-bottom-left-radius: 8px;
        }
        
        /* 실제 입력창 */
        .form-control {
            background-color: var(--input-bg) !important;
            border: 1px solid #2f3336 !important; border-left: none !important;
            color: white !important; height: 50px;
            border-top-right-radius: 8px; border-bottom-right-radius: 8px;
        }
        
        /* 포커스 효과 (골드 테두리) */
        .form-control:focus { box-shadow: none; border-color: var(--primary-gold) !important; }
        .input-group:focus-within .input-group-text { border-color: var(--primary-gold); }

        /* 입력 가이드 문구 (아이콘 + 텍스트) */
        .form-text-custom {
            font-size: 0.75rem; color: var(--text-guide); margin-top: 6px; margin-left: 4px; display: flex; align-items: center; gap: 5px;
        }
        .form-text-custom i { font-size: 0.7rem; }

        /* [BUTTONS] */
        .btn-gold {
            background: var(--primary-gold); color: black; font-weight: 800; border: none;
            height: 55px; width: 100%; border-radius: 8px; font-size: 1.1rem; margin-top: 10px;
            transition: 0.3s;
        }
        .btn-gold:hover { background: #e0bd2f; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(252, 213, 53, 0.2); }

        /* [TYPOGRAPHY] 브랜드 텍스트 */
        .brand-title { font-size: 3.5rem; font-weight: 900; color: white; letter-spacing: -2px; margin-bottom: 10px; }
        .brand-slogan { font-size: 1.2rem; color: #b7bdc6; font-weight: 400; line-height: 1.6; }
        .brand-gold { color: var(--primary-gold); }

        /* 애니메이션 키프레임 (오른쪽에서 스르륵) */
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }
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
            
            <!-- 
            =================================================================
              [LEFT COLUMN] 브랜드 이미지 & 슬로건
            =================================================================
            -->
            <div class="col-lg-6 d-none d-lg-block bg-image">
                <div class="bg-overlay">
                    <div style="margin-bottom: 50px;">
                        <h1 class="brand-title">Smart Travel <br>Starts with <span class="brand-gold">RateGo</span></h1>
                        <p class="brand-slogan">
                            실시간 환율 알림부터 여행자 커뮤니티까지.<br>
                            더 현명한 여행을 위한 첫걸음, 지금 시작하세요.
                        </p>
                    </div>
                </div>
            </div>

            <!-- 
            =================================================================
              [RIGHT COLUMN] 회원가입 입력 폼
            =================================================================
            -->
            <div class="col-lg-6 login-section">
                <div class="form-wrapper">
                    
                    <!-- 헤더 영역 (뒤로가기 + 타이틀) -->
                    <div class="mb-4">
                        <a href="./" class="text-decoration-none text-secondary small fw-bold mb-3 d-inline-block hover-white">
                            <i class="fa-solid fa-arrow-left"></i> 메인으로 돌아가기
                        </a>
                        <h2 class="fw-bold text-white mb-2">계정 만들기</h2>
                    </div>

                    <!-- 
                      [FORM START] 회원가입 요청
                      - Action: join.do (POST)
                    -->
                    <form action="join.do" method="post" autocomplete="off">
                        
                        <!-- 1. 아이디 입력 -->
                        <div class="mb-3">
                            <label class="form-label">아이디</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-regular fa-user"></i></span>
                                <input type="text" name="userId" class="form-control" placeholder="아이디를 입력하세요" required>
                            </div>
                            <div class="form-text-custom">
                                <i class="fa-solid fa-circle-info"></i> 영문 소문자 및 숫자 포함 4~12자
                            </div>
                        </div>

                        <!-- 2. 비밀번호 입력 -->
                        <div class="mb-3">
                            <label class="form-label">비밀번호</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                <input type="password" name="userPw" class="form-control" placeholder="비밀번호를 입력하세요" required>
                            </div>
                            <div class="form-text-custom">
                                <i class="fa-solid fa-shield-halved"></i> 특수문자 포함 8자 이상 권장
                            </div>
                        </div>

                        <!-- 3. 닉네임 입력 -->
                        <div class="mb-3">
                            <label class="form-label">닉네임</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-regular fa-id-badge"></i></span>
                                <input type="text" name="userName" class="form-control" placeholder="활동명을 입력하세요" required>
                            </div>
                            <div class="form-text-custom">
                                <i class="fa-regular fa-face-smile"></i> 커뮤니티 활동 시 보여집니다
                            </div>
                        </div>

                        <!-- 4. 이메일 입력 (선택) -->
                        <div class="mb-4">
                            <label class="form-label">이메일 (선택)</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-regular fa-envelope"></i></span>
                                <input type="email" name="userEmail" class="form-control" placeholder="example@ratego.com">
                            </div>
                            <div class="form-text-custom">
                                <i class="fa-regular fa-bell"></i> 환율 알림을 받아보실 수 있습니다
                            </div>
                        </div>

                        <!-- 제출 버튼 -->
                        <button type="submit" class="btn btn-gold">
                            회원가입 완료
                        </button>
                    </form>
                    <!-- [FORM END] -->
                    
                </div>
            </div>
        </div>
    </div>

</body>
</html>