<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
*******************************************************************************
* [modify.jsp]
* 설명 : 게시글 수정 화면
* 주요 기능 :
* 1. 기존 게시글 내용(제목, 카테고리, 본문) 로드 및 표시
* 2. Summernote 에디터를 이용한 위지윅(WYSIWYG) 편집
* 3. 수정 완료 시 서버(modify.do)로 폼 전송
* 디자인 : register.jsp와 동일한 Full Screen Editor 레이아웃 적용
*******************************************************************************
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>RateGo - 게시글 수정</title>
    
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
      CUSTOM CSS (Editor Layout)
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
        
        /* [LAYOUT] 전체 화면 꽉 채우기 (스크롤 방지) */
        html, body { 
            height: 100%; margin: 0; padding: 0; 
            overflow: hidden; 
            background-color: var(--bg-body); 
            color: var(--text-main); 
            font-family: 'Pretendard', sans-serif; 
            display: flex; flex-direction: column; 
        }

        /* [NAVBAR] 상단 네비게이션 */
        .navbar { 
            background: rgba(13, 17, 23, 1); 
            border-bottom: 1px solid var(--border-color); 
            padding: 10px 20px; 
            flex-shrink: 0; 
        }
        .brand-logo { color: var(--primary-gold); font-weight: 900; font-size: 1.3rem; text-decoration: none; }

        /* [EDITOR CONTAINER] 에디터 영역 래퍼 */
        .editor-wrapper { 
            flex: 1; display: flex; flex-direction: column; padding: 0; overflow: hidden; 
        }
        .write-form { 
            height: 100%; display: flex; flex-direction: column; 
            max-width: 1200px; width: 100%; margin: 0 auto; padding: 20px; 
        }

        /* [FORM HEADER] 제목, 카테고리, 버튼 영역 */
        .form-header { flex-shrink: 0; margin-bottom: 15px; }
        .header-top { 
            display: flex; justify-content: space-between; align-items: center; 
            margin-bottom: 15px; border-bottom: 1px solid var(--border-color); padding-bottom: 10px; 
        }
        
        /* 카테고리 선택 셀렉트 박스 */
        .category-select { 
            background: transparent; color: var(--primary-gold); 
            border: 1px solid var(--border-color); padding: 5px 10px; 
            border-radius: 4px; font-weight: bold; cursor: pointer; 
        }
        .category-select option { background: var(--bg-editor); color: white; }

        /* 제목 입력 인풋 */
        .title-input { 
            width: 100%; background: transparent; border: none; 
            border-bottom: 1px solid var(--border-color); 
            color: white; font-size: 1.5rem; font-weight: 700; padding: 10px 0; 
        }
        .title-input:focus { outline: none; border-bottom-color: var(--primary-gold); }

        /* [SUMMERNOTE CUSTOMIZATION] 썸머노트 강제 스타일 오버라이딩 */
        .editor-area { 
            flex: 1; display: flex; flex-direction: column; overflow: hidden; 
            border: 1px solid var(--border-color); border-radius: 8px; 
        }
        .note-editor.note-frame { 
            border: none !important; flex: 1; display: flex; flex-direction: column; margin: 0 !important; 
        }
        .note-toolbar { 
            background-color: var(--bg-editor) !important; 
            border-bottom: 1px solid var(--border-color) !important; flex-shrink: 0; 
        }
        .note-editing-area { 
            flex: 1; display: flex; flex-direction: column; 
            background-color: var(--bg-body) !important; position: relative; 
        }
        .note-editable { 
            flex: 1; background-color: var(--bg-body) !important; 
            color: #e6edf3 !important; padding: 20px !important; overflow-y: auto !important; 
        }
        .note-statusbar { display: none !important; } /* 하단 리사이즈 바 숨김 */
        .note-placeholder { color: #484f58 !important; }
        
        /* 툴바 버튼 스타일 */
        .note-btn { color: #c9d1d9 !important; background: transparent !important; border: none !important; }
        .note-btn:hover { color: var(--primary-gold) !important; background: rgba(255,255,255,0.1) !important; }

        /* 등록(수정) 버튼 */
        .btn-register { 
            background: var(--primary-gold); color: #0d1117; font-weight: 800; 
            border: none; padding: 8px 25px; border-radius: 4px; 
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
                <i class="fa-solid fa-pen-to-square me-1"></i> Edit Mode
            </div>
        </div>
    </nav>

    <!-- 
    =================================================================
      EDITOR WRAPPER (Form)
    =================================================================
    -->
    <div class="editor-wrapper">
        <form action="modify.do" method="post" class="write-form">
            
            <!-- 수정 시 게시글 번호(bno)는 필수 전달 -->
            <input type="hidden" name="bno" value="${board.bno}">
            
            <!-- 1. 폼 헤더 (카테고리, 제목, 버튼) -->
            <div class="form-header">
                <div class="header-top">
                    <div class="d-flex align-items-center gap-3">
                        <span class="text-white fw-bold fs-5">글 수정</span>
                        
                        <!-- 카테고리 선택 (기존 값 자동 선택) -->
                        <select name="category" class="category-select">
                            <option value="잡담" ${board.category == '잡담' ? 'selected' : ''}>💬 잡담</option>
                            <option value="정보" ${board.category == '정보' ? 'selected' : ''}>📢 정보공유</option>
                            <option value="질문" ${board.category == '질문' ? 'selected' : ''}>❓ 질문하기</option>
                            <option value="후기" ${board.category == '후기' ? 'selected' : ''}>📸 여행후기</option>
                        </select>
                    </div>
                    <div>
                        <!-- 취소 버튼 (상세 페이지로 복귀) -->
                        <a href="get.do?bno=${board.bno}" class="text-decoration-none text-secondary me-3 fw-bold small">취소</a>
                        <button type="submit" class="btn-register">수정 완료</button>
                    </div>
                </div>

                <!-- 제목 입력 (기존 제목 로드) -->
                <input type="text" name="title" class="title-input" value="${board.title}" required autocomplete="off">
                
                <!-- 작성자는 수정 불가 (hidden으로 전송하거나, 서버 세션에서 처리) -->
                <input type="hidden" name="writer" value="${board.writer}">
            </div>

            <!-- 2. 에디터 영역 (기존 본문 로드) -->
            <div class="editor-area">
                <textarea id="summernote" name="content">${board.content}</textarea>
            </div>

        </form>
    </div>

    <!-- 
    =================================================================
      SUMMERNOTE INITIALIZATION
    =================================================================
    -->
    <script>
        $(document).ready(function() {
            $('#summernote').summernote({
                // height: 600, // CSS에서 flex로 꽉 채웠으므로 높이 지정 불필요
                lang: "ko-KR",
                placeholder: '내용을 입력하세요.',
                disableResizeEditor: true, // 하단 드래그 리사이즈 비활성화
                focus: true,
                toolbar: [
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