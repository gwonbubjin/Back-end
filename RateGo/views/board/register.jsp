<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
*******************************************************************************
* [register.jsp]
* 설명 : 게시글 작성 화면
* 주요 기능 :
* 1. 카테고리 선택 및 제목 입력
* 2. Summernote 에디터를 이용한 본문 작성 (이미지, 동영상 첨부 가능)
* 3. 작성 완료 시 서버(register.do)로 폼 전송
* 디자인 : 브라우저 높이에 맞춰 꽉 차는 Full Screen Editor 레이아웃
*******************************************************************************
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>RateGo - 게시글 쓰기</title>
    
    <!-- 
    =================================================================
      EXTERNAL LIBRARIES (jQuery, Bootstrap, Summernote)
    =================================================================
    -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Summernote Editor (Lite Version) -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">

    <!-- 
    =================================================================
      CUSTOM CSS (Full Screen Layout)
    =================================================================
    -->
    <style>
        /* [ROOT VARIABLES] 전역 스타일 변수 */
        :root {
            --bg-body: #0d1117;       /* 메인 배경 */
            --bg-editor: #161b22;     /* 에디터 툴바 배경 */
            --border-color: #30363d;  /* 테두리 색상 */
            --text-main: #c9d1d9;     /* 텍스트 색상 */
            --primary-gold: #FCD535;  /* 포인트 컬러 */
        }

        /* [LAYOUT] 화면 전체 높이 사용 (스크롤 제거) */
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden; /* 바디 스크롤 금지 (에디터 내부 스크롤만 허용) */
            background-color: var(--bg-body);
            color: var(--text-main);
            font-family: 'Pretendard', sans-serif;
            display: flex;
            flex-direction: column;
        }

        /* [NAVBAR] 상단 네비게이션 (고정 높이) */
        .navbar {
            background: rgba(13, 17, 23, 1);
            border-bottom: 1px solid var(--border-color);
            padding: 10px 20px;
            flex-shrink: 0; /* 공간 부족해도 줄어들지 않음 */
        }
        .brand-logo {
            color: var(--primary-gold);
            font-weight: 900;
            font-size: 1.3rem;
            text-decoration: none;
        }

        /* [EDITOR WRAPPER] 메인 컨텐츠 영역 */
        .editor-wrapper {
            flex: 1; /* 남은 높이(height)를 모두 차지 */
            display: flex;
            flex-direction: column;
            padding: 0;
            overflow: hidden; 
        }

        .write-form {
            height: 100%;
            display: flex;
            flex-direction: column;
            max-width: 1200px; /* 좌우 너무 넓어지는 것 방지 */
            width: 100%;
            margin: 0 auto;
            padding: 20px;
        }

        /* [FORM HEADER] 카테고리/제목/버튼 영역 */
        .form-header {
            flex-shrink: 0;
            margin-bottom: 15px;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 10px;
        }

        /* 카테고리 셀렉트 박스 */
        .category-select {
            background: transparent;
            color: var(--primary-gold);
            border: 1px solid var(--border-color);
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
        }
        .category-select option { background: var(--bg-editor); color: white; }

        /* 제목 입력 필드 */
        .title-input {
            width: 100%;
            background: transparent;
            border: none;
            border-bottom: 1px solid var(--border-color);
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            padding: 10px 0;
        }
        .title-input:focus { outline: none; border-bottom-color: var(--primary-gold); }

        /* [SUMMERNOTE OVERRIDES] 에디터 스타일 강제 수정 */
        /* 에디터 영역 컨테이너 */
        .editor-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden; /* 에디터 밖으로 내용 삐져나감 방지 */
            border: 1px solid var(--border-color);
            border-radius: 8px;
        }

        /* Summernote 프레임 (Flex 적용으로 높이 자동 조절) */
        .note-editor.note-frame {
            border: none !important;
            flex: 1;
            display: flex;
            flex-direction: column;
            margin: 0 !important;
        }
        
        /* 툴바 (상단 버튼 영역) */
        .note-toolbar {
            background-color: var(--bg-editor) !important;
            border-bottom: 1px solid var(--border-color) !important;
            flex-shrink: 0;
        }
        
        /* 편집 영역 (흰색 배경 제거 및 Flex 적용) */
        .note-editing-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            background-color: var(--bg-body) !important;
            position: relative;
        }
        
        /* 실제 텍스트 입력 구간 (여기서만 스크롤 발생) */
        .note-editable {
            flex: 1;
            background-color: var(--bg-body) !important;
            color: #e6edf3 !important;
            padding: 20px !important;
            overflow-y: auto !important; /* ★ 핵심: 내용 많으면 스크롤 생성 */
        }
        
        .note-statusbar { display: none !important; } /* 하단 리사이즈 바 숨김 */
        .note-placeholder { color: #484f58 !important; }

        /* 툴바 버튼 커스텀 */
        .note-btn { color: #c9d1d9 !important; background: transparent !important; border: none !important; }
        .note-btn:hover { color: var(--primary-gold) !important; background: rgba(255,255,255,0.1) !important; }

        /* 등록 버튼 */
        .btn-register {
            background: var(--primary-gold);
            color: #0d1117;
            font-weight: 800;
            border: none;
            padding: 8px 25px;
            border-radius: 4px;
        }
        .btn-register:hover { background: #fff; }
        
    </style>
</head>
<body>

    <!-- 
    =================================================================
      NAVBAR HEADER
    =================================================================
    -->
    <nav class="navbar">
        <div class="container-fluid px-4 d-flex justify-content-between">
            <a href="/" class="brand-logo"><i class="fa-solid fa-earth-asia"></i> RateGo</a>
            <div class="text-secondary small fw-bold">
                <i class="fa-solid fa-pen-nib me-1"></i> Writing Mode
            </div>
        </div>
    </nav>

    <!-- 
    =================================================================
      EDITOR FORM WRAPPER
    =================================================================
    -->
    <div class="editor-wrapper">
        <form action="register.do" method="post" class="write-form">
            
            <!-- 1. 폼 헤더 (제목, 카테고리, 버튼) -->
            <div class="form-header">
                <div class="header-top">
                    <div class="d-flex align-items-center gap-3">
                        <span class="text-white fw-bold fs-5">글쓰기</span>
                        
                        <!-- 카테고리 선택 -->
                        <select name="category" class="category-select">
                            <option value="잡담">💬 잡담</option>
                            <option value="정보">📢 정보공유</option>
                            <option value="질문">❓ 질문하기</option>
                            <option value="후기">📸 여행후기</option>
                        </select>
                    </div>
                    <div>
                        <!-- 나가기 버튼 (목록으로 이동) -->
                        <a href="list.do" class="text-decoration-none text-secondary me-3 fw-bold small">나가기</a>
                        <button type="submit" class="btn-register">등록</button>
                    </div>
                </div>

                <!-- 제목 입력 -->
                <input type="text" name="title" class="title-input" placeholder="제목을 입력해 주세요." required autocomplete="off">
                
                <!-- 작성자 정보 (세션에서 가져옴, 없으면 빈값) -->
                <input type="hidden" name="writer" value="${not empty sessionScope.user ? sessionScope.user.userId : ''}">
                
            </div>

            <!-- 2. 에디터 영역 (Summernote) -->
            <div class="editor-area">
                <textarea id="summernote" name="content"></textarea>
            </div>

        </form>
    </div>

    <!-- 
    =================================================================
      SUMMERNOTE SCRIPT
    =================================================================
    -->
    <script>
        $(document).ready(function() {
            $('#summernote').summernote({
                // height: 600,     // ★ 중요: 높이 고정하지 않음 (CSS Flex로 자동 채움)
                lang: "ko-KR",      // 한국어 설정
                placeholder: '내용을 입력하세요.',
                disableResizeEditor: true, // 하단 리사이즈 바 비활성화
                focus: true,        // 로드 시 포커스
                toolbar: [          // 툴바 구성
                    ['font', ['bold', 'underline', 'clear']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['insert', ['picture', 'link', 'video']],
                    ['view', ['codeview']]
                ]
            });
        });
    </script>

</body>
</html>