<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%--
*******************************************************************************
* [get.jsp]
* 설명 : 게시글 상세 조회 및 댓글(대댓글 포함) 기능 구현 화면
* 주요 기능 :
* 1. 게시글 본문 및 메타 정보(작성자, 조회수 등) 출력
* 2. 좋아요/싫어요 비동기(AJAX) 처리
* 3. 계층형 댓글(댓글+대댓글) 목록 렌더링 및 CRUD
* 스타일 : Bootstrap 5 + Pretendard 폰트 + 커스텀 다크 모드(RateGo Design)
*******************************************************************************
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>RateGo - ${board.title}</title>
    
    <!-- 
    =================================================================
      EXTERNAL LIBRARIES (폰트, 아이콘, 부트스트랩)
    =================================================================
    -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">

    <!-- 
    =================================================================
      CUSTOM CSS (다크 모드 디자인 시스템)
    =================================================================
    -->
    <style>
        /* [ROOT VARIABLES] 색상 팔레트 정의 */
        :root {
            --bg-body: #0d1117;       /* 메인 배경색 (GitHub Dark Dimmed 스타일) */
            --text-main: #c9d1d9;     /* 메인 텍스트 */
            --text-muted: #8b949e;    /* 보조 텍스트 */
            --primary-gold: #FCD535;  /* 포인트 컬러 (골드) */
            --border-color: #30363d;  /* 테두리 색상 */
            --code-bg: #161b22;       /* 입력창 배경 */
        }

        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            overflow-x: hidden;
        }

        /* [NAVBAR] 상단 네비게이션 */
        .navbar {
            background: rgba(13, 17, 23, 0.95);
            border-bottom: 1px solid var(--border-color);
            padding: 15px 0;
            position: sticky; /* 스크롤 시 상단 고정 */
            top: 0;
            z-index: 1000;
            backdrop-filter: blur(10px); /* 블러 효과 */
        }
        .brand-logo {
            color: var(--primary-gold);
            font-weight: 900;
            font-size: 1.5rem;
            text-decoration: none;
            letter-spacing: -0.5px;
        }

        /* [LAYOUT] 메인 컨테이너 */
        .view-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 60px 20px 100px;
        }

        /* [POST HEADER] 제목 및 메타 정보 */
        .post-header {
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
        }
        .category-label {
            color: var(--primary-gold);
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 10px;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .post-title {
            font-size: 2.5rem;
            font-weight: 800;
            color: white;
            line-height: 1.3;
            margin-bottom: 20px;
        }
        .post-meta {
            display: flex;
            justify-content: space-between; /* 양끝 정렬 */
            align-items: center;
            color: var(--text-muted);
            font-size: 0.95rem;
        }
        .meta-left { display: flex; align-items: center; gap: 15px; }
        .writer-name { color: white; font-weight: 600; }
        .meta-divider { width: 1px; height: 12px; background: #30363d; }

        /* [POST CONTENT] 본문 영역 */
        .post-content {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #e6edf3;
            min-height: 200px;
            margin-bottom: 60px;
            word-break: break-all; /* 긴 단어 줄바꿈 */
        }
        .post-content img { max-width: 100%; border-radius: 8px; margin: 20px 0; }

        /* [INTERACTION] 좋아요/싫어요 버튼 */
        .reaction-wrapper {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 60px;
        }
        .btn-reaction {
            background: transparent;
            border: 1px solid var(--border-color);
            color: var(--text-muted);
            padding: 12px 30px;
            border-radius: 50px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn-reaction:hover {
            border-color: var(--primary-gold);
            color: white;
            background: rgba(252, 213, 53, 0.05);
        }
        /* 활성화(Active) 상태 스타일 */
        .btn-reaction.active {
            border-color: var(--primary-gold);
            color: var(--primary-gold);
            background: rgba(252, 213, 53, 0.1);
        }

        /* [ACTION BAR] 목록/수정/삭제 버튼 */
        .action-bar {
            display: flex;
            justify-content: space-between;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
            margin-bottom: 60px;
        }
        .btn-text {
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        .btn-text:hover { color: white; }

        /* [COMMENT SECTION] 댓글 영역 전체 */
        .comment-section { margin-top: 60px; }
        .comment-head {
            font-size: 1.3rem;
            font-weight: 700;
            color: white;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .comment-input-box {
            background: var(--code-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 40px;
        }
        .comment-textarea {
            width: 100%;
            background: transparent;
            border: none;
            color: white;
            resize: none;
            outline: none;
            min-height: 60px;
            font-size: 1rem;
        }
        .btn-submit-comment {
            background: var(--primary-gold);
            color: #0d1117;
            font-weight: 800;
            border: none;
            padding: 8px 20px;
            border-radius: 4px;
            float: right;
            margin-top: 10px;
        }

        /* [COMMENT LIST] 개별 댓글 스타일 */
        .comment-item {
            padding: 25px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .comment-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .comment-author { color: white; font-weight: 700; font-size: 0.95rem; }
        .comment-date { color: #484f58; font-size: 0.85rem; }
        .comment-body { color: #c9d1d9; line-height: 1.6; }
        
        /* 댓글 하단 버튼 그룹 (답글/수정/삭제) - 한 줄 정렬 */
        .comment-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 8px;
        }

        .comment-btn {
            font-size: 0.85rem;
            cursor: pointer;
            transition: color 0.2s;
            font-weight: 500;
            background: none;
            border: none;
            padding: 0;
        }

        .btn-reply { color: #8b949e; }
        .btn-reply:hover { color: var(--primary-gold); }

        .btn-edit { color: #79c0ff; } /* 파란색 계열 */
        .btn-edit:hover { text-decoration: underline; }

        .btn-delete { color: #ff7b72; } /* 빨간색 계열 */
        .btn-delete:hover { text-decoration: underline; }

        /* [REPLY ITEM] 대댓글 전용 스타일 (들여쓰기 적용) */
        .reply-item {
            padding: 20px 0 20px 40px; /* 왼쪽 여백 추가 */
            border-bottom: 1px solid rgba(255,255,255,0.05);
            background-color: rgba(255,255,255,0.01); /* 아주 살짝 밝게 */
        }
        .reply-arrow { color: #484f58; margin-right: 8px; }
    </style>
</head>
<body>

    <!-- 
    =================================================================
      NAVBAR HEADER
    =================================================================
    -->
    <nav class="navbar">
        <div class="container" style="max-width: 1000px;">
            <a href="/" class="brand-logo"><i class="fa-solid fa-earth-asia"></i> RateGo</a>
        </div>
    </nav>

    <!-- 
    =================================================================
      MAIN VIEW CONTAINER
    =================================================================
    -->
    <div class="view-container">
        
        <!-- 1. 게시글 헤더 (제목, 작성자, 날짜, 조회수) -->
        <div class="post-header">
            <span class="category-label">${board.category}</span>
            <h1 class="post-title">${board.title}</h1>
            
            <div class="post-meta">
                <div class="meta-left">
                    <span class="writer-name">${board.writer}</span>
                    <span class="meta-divider"></span>
                    <span><fmt:formatDate value="${board.regdate}" pattern="yyyy.MM.dd HH:mm"/></span>
                </div>
                <div>
                    <i class="fa-regular fa-eye me-1"></i> ${board.viewcnt}
                </div>
            </div>
        </div>

        <!-- 2. 게시글 본문 -->
        <div class="post-content">
            ${board.content}
        </div>

        <!-- 3. 좋아요 / 싫어요 버튼 영역 -->
        <div class="reaction-wrapper">
            <button class="btn-reaction btn-like">
                <i class="fa-regular fa-thumbs-up"></i> <span id="likeCount">${board.likecnt}</span>
            </button>
            <button class="btn-reaction btn-dislike">
                <i class="fa-regular fa-thumbs-down"></i> <span id="dislikeCount">${board.dislikecnt}</span>
            </button>
        </div>

        <!-- 4. 하단 액션바 (목록, 수정, 삭제) -->
        <div class="action-bar">
            <a href="list.do" class="btn-text"><i class="fa-solid fa-arrow-left me-2"></i>목록으로</a>
            
            <%-- 로그인한 사용자와 작성자가 일치할 때만 수정/삭제 버튼 노출 --%>
            <c:if test="${not empty sessionScope.user and sessionScope.user.userId eq board.writerId}">
                <div>
                    <a href="modify.do?bno=${board.bno}" class="btn-text me-3">수정</a>
                    <form action="remove.do" method="post" onsubmit="return confirm('정말 게시글을 삭제하시겠습니까?');" style="display:inline;">
                        <input type="hidden" name="bno" value="${board.bno}">
                        <button type="submit" class="btn-text text-danger bg-transparent border-0 p-0 fw-bold" style="font-family: 'Pretendard', sans-serif;">삭제</button>
                    </form>
                </div>
            </c:if>
        </div>

        <!-- 5. 댓글 영역 -->
        <div class="comment-section">
            <div class="comment-head">
                Comments
            </div>

            <!-- 댓글 입력 창 -->
            <div class="comment-input-box">
                <textarea class="comment-textarea" placeholder="자유롭게 의견을 남겨주세요."></textarea>
                <div class="clearfix">
                    <button class="btn-submit-comment">등록</button>
                </div>
            </div>

            <!-- 댓글 목록이 표시될 위치 (AJAX로 로드됨) -->
            <div class="comment-list"></div>
        </div>

    </div>

    <!-- 
    =================================================================
      JAVASCRIPT LOGIC
    =================================================================
    -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script>
        /************************************************
         * GLOBAL VARIABLES & INITIALIZATION
         ************************************************/
        // JSP EL 태그를 사용하여 서버 측 데이터를 JS 변수로 할당
        const bnoValue = '<c:out value="${board.bno}"/>';
        const currentUser = '${sessionScope.user.userId}';

        // 문서 로드 완료 시 실행
        $(document).ready(function() {
            showList(); // 댓글 목록 불러오기

            // 1. [댓글 등록] 버튼 클릭 이벤트
            $(".btn-submit-comment").on("click", function(e){
                const replyText = $(".comment-textarea").val();
                if(replyText == "") { alert("내용을 입력하세요."); return; }
                if(currentUser == "") { alert("로그인이 필요합니다."); return; }

                // 부모 댓글 번호(parent_rno)는 0 (최상위 댓글)
                const replyData = { bno: bnoValue, reply: replyText, replyer: currentUser, parent_rno: 0 };
                addReply(replyData);
            });

            // 2. [좋아요] 버튼 클릭 이벤트
            $(".btn-like").on("click", function(){
                if(currentUser == "") { alert("로그인이 필요합니다."); return; }
                $.ajax({
                    type: 'post', url: '/board/like', data: { bno: bnoValue },
                    success: function(result) {
                        if(result == -1) { alert("로그인이 필요합니다."); return; }
                        // UI 업데이트 : 카운트 갱신 및 버튼 활성화 토글
                        $("#likeCount").text(result);
                        $(".btn-like").toggleClass("active");
                        $(".btn-dislike").removeClass("active"); // 싫어요는 해제
                    },
                    error: function() { alert("오류가 발생했습니다."); }
                });
            });

            // 3. [싫어요] 버튼 클릭 이벤트
            $(".btn-dislike").on("click", function(){
                if(currentUser == "") { alert("로그인이 필요합니다."); return; }
                $.ajax({
                    type: 'post', url: '/board/dislike', data: { bno: bnoValue },
                    success: function(result) {
                        if(result == -1) { alert("로그인이 필요합니다."); return; }
                        $("#dislikeCount").text(result);
                        $(".btn-dislike").toggleClass("active");
                        $(".btn-like").removeClass("active"); // 좋아요는 해제
                    },
                    error: function() { alert("오류가 발생했습니다."); }
                });
            });
        });

        /************************************************
         * AJAX FUNCTIONS (CRUD)
         ************************************************/

        // [CREATE] 댓글 등록
        function addReply(replyData) {
            $.ajax({
                type: 'post', url: '/replies/new',
                data: JSON.stringify(replyData),
                contentType: "application/json; charset=utf-8",
                success: function(result) {
                    if (result === "success") {
                        $(".comment-textarea").val(""); // 입력창 초기화
                        $(".re-reply-box").remove();    // 대댓글 입력창이 열려있다면 제거
                        showList();                     // 목록 갱신
                    }
                },
                error: function() { alert("등록 실패"); }
            });
        }

        // [DELETE] 댓글 삭제
        function removeReply(rno) {
            if(!confirm("정말 삭제하시겠습니까?")) return;
            $.ajax({
                type: 'delete', url: '/replies/' + rno,
                success: function(result) {
                    if (result === "success") showList();
                },
                error: function() { alert("삭제 실패"); }
            });
        }

        // [UI] 댓글 수정 모드 진입 (입력창으로 변환)
        function enableEditMode(rno, btn) {
            const body = $(btn).closest('.comment-item, .reply-item').find('.comment-body');
            const originalText = body.text().trim().replace("↳ ", ""); // 화살표 제거 후 텍스트만 추출
            
            // 수정용 입력창 HTML 생성
            const editHtml = 
                '<div class="edit-box mt-2">' +
                '  <textarea class="form-control mb-2 edit-input" style="background:#0d1117; color:white; border:1px solid #30363d;">' + originalText + '</textarea>' +
                '  <div class="text-end">' +
                '    <button class="btn btn-sm btn-secondary me-1" onclick="showList()">취소</button>' +
                '    <button class="btn btn-sm btn-warning" onclick="modifyReply(' + rno + ', this)">수정완료</button>' +
                '  </div>' +
                '</div>';
            body.html(editHtml);
        }

        // [UPDATE] 댓글 수정 처리
        function modifyReply(rno, btn) {
            const modifiedText = $(btn).closest('.edit-box').find('.edit-input').val();
            if(modifiedText == "") return;

            $.ajax({
                type: 'put', url: '/replies/' + rno,
                data: JSON.stringify({reply: modifiedText, replyer: currentUser}),
                contentType: "application/json; charset=utf-8",
                success: function(result) {
                    if (result === "success") showList();
                },
                error: function() { alert("수정 실패"); }
            });
        }

        /************************************************
         * LIST RENDERING & HELPERS
         ************************************************/

        // [READ] 댓글 목록 가져오기 및 렌더링
        function showList() {
            $.getJSON("/replies/pages/" + bnoValue, function(list) {
                let str = "";
                
                $(list).each(function(i, obj) {
                    // 대댓글 판별 (parent_rno가 0이 아니면 대댓글)
                    const isReReply = obj.parent_rno != 0;
                    const containerClass = isReReply ? 'reply-item' : 'comment-item';
                    const arrowIcon = isReReply ? '<i class="fa-solid fa-turn-up reply-arrow fa-rotate-90"></i> ' : '';

                    str += '<div class="' + containerClass + '">';
                    
                    // 1. 작성자 및 날짜
                    str += '    <div class="comment-info">';
                    str += '        <span class="comment-author">' + obj.replyerName + '</span>';
                    str += '        <span class="comment-date">' + displayTime(obj.replyDate) + '</span>';
                    str += '    </div>';
                    
                    // 2. 본문 내용 (멘션 @이름 스타일링)
                    let content = obj.reply;
                    if(content.startsWith("@")) {
                        content = content.replace(/(@.*? )/, '<span class="text-gold fw-bold">$1</span>');
                    }
                    str += '    <div class="comment-body">' + arrowIcon + content + '</div>';
                    
                    // 3. 액션 버튼 그룹 (로그인한 경우만 표시)
                    if(currentUser != "") {
                        str += '    <div class="comment-actions">';
                        
                        // [답글] 버튼: 대댓글인 경우 부모 ID 유지, 아니면 자기 자신 ID 사용
                        let targetParent = isReReply ? obj.parent_rno : obj.rno;
                        str += '<button class="comment-btn btn-reply" onclick="openReReplyForm(' + targetParent + ', \'' + obj.replyerName + '\', this)">답글</button>';
                        
                        // [수정/삭제] 버튼: 내 댓글인 경우만 표시
                        if(currentUser == obj.replyer) {
                            str += '<button class="comment-btn btn-edit" onclick="enableEditMode(' + obj.rno + ', this)">수정</button>';
                            str += '<button class="comment-btn btn-delete" onclick="removeReply(' + obj.rno + ')">삭제</button>';
                        }
                        str += '    </div>';
                    }
                    str += '</div>';
                });

                $(".comment-list").html(str);
            });
        }

        // [UI] 대댓글 입력창 열기
        function openReReplyForm(rno, writerName, btn) {
            $(".re-reply-box").remove(); // 기존에 열려있는 다른 입력창 제거
            const reReplyForm = '<div class="comment-input-box re-reply-box mt-3" style="margin-left:40px; border-left:2px solid var(--primary-gold);"><textarea class="comment-textarea re-reply-text"></textarea><div class="clearfix"><button class="btn-submit-comment" onclick="submitReReply('+rno+')">답글 등록</button></div></div>';
            
            $(btn).parent().parent().append(reReplyForm);
            // 자동으로 "@작성자 " 멘션 추가 및 포커스
            $(btn).parent().parent().find(".re-reply-text").val("@" + writerName + " ").focus();
        }

        // [CREATE] 대댓글 등록 요청
        function submitReReply(parentRno) {
            const text = $(".re-reply-text").val();
            if(text == "") return;
            const replyData = { bno: bnoValue, reply: text, replyer: currentUser, parent_rno: parentRno };
            addReply(replyData);
        }

        // [HELPER] 날짜 포맷 변환 (yyyy-MM-dd HH:mm)
        function displayTime(timeValue) {
            const date = new Date(timeValue);
            return date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();
        }
    </script>

</body>
</html>