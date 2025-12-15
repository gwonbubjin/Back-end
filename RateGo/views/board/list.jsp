<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page isELIgnored="false" %>

<%--
*******************************************************************************
* [list.jsp]
* 설명 : 커뮤니티 게시판 목록 조회 화면
* 주요 기능 :
* 1. 게시글 목록 출력 (페이징 포함)
* 2. 카테고리 필터링 (전체/잡담/정보/질문/후기)
* 3. 조건부 UI 렌더링 (카테고리별 뱃지 색상, HOT 게시글 강조)
* 4. 세계 시간 위젯 (하단 Ticker)
* 디자인 : Glassmorphism(유리 질감) + Dark Mode 테마 적용
*******************************************************************************
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>RateGo - Community Board</title>
    
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
      CUSTOM CSS (Glassmorphism & Dark Theme)
    =================================================================
    -->
    <style>
        /* [전역 설정 및 변수] */
        * { box-sizing: border-box; } /* 박스 크기 계산 고정 */

        :root {
            --primary-gold: #FCD535;          /* 브랜드 컬러 */
            --primary-dark: #1E2329;          /* 어두운 배경 */
            --text-gray: #848e9c;             /* 보조 텍스트 */
            --glass-bg: rgba(30, 35, 41, 0.75); /* 유리 배경색 */
            --glass-border: rgba(255, 255, 255, 0.08); /* 유리 테두리 */
            --neon-shadow: 0 0 10px rgba(252, 213, 53, 0.3); /* 네온 효과 */
            --table-hover: rgba(252, 213, 53, 0.05); /* 테이블 호버 색상 */
            --scrollbar-thumb: rgba(255, 255, 255, 0.1);
        }

        /* [기본 레이아웃] */
        body {
            height: 100vh;
            margin: 0;
            overflow: hidden; /* 페이지 전체 스크롤 방지 (앱 같은 느낌) */
            background: radial-gradient(circle at 50% -20%, #2b3139, #0b0e11 90%);
            color: #eaecef;
            font-family: 'Pretendard', sans-serif;
            display: flex;
            flex-direction: column;
        }

        /* [커스텀 스크롤바] */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: var(--scrollbar-thumb); border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: rgba(255, 255, 255, 0.2); }

        .text-gold { color: var(--primary-gold) !important; }
        
        /* [상단 네비게이션] */
        .navbar {
            background: rgba(11, 14, 17, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--glass-border);
            padding: 13px 0;
            flex-shrink: 0;
            z-index: 100;
        }
        .brand-logo {
            color: var(--primary-gold); font-weight: 900; font-size: 1.6rem;
            letter-spacing: -1px; text-decoration: none;
        }

        /* [메인 컨텐츠 영역] */
        .main-container {
            flex: 1;
            padding: 20px 0;
            overflow: hidden; 
            display: flex;
            flex-direction: column;
        }

        /* [유리 질감 박스 컨테이너] */
        .glass-box {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
            display: flex;
            flex-direction: column;
            height: 100%;
            overflow: hidden; 
        }

        /* [게시판 헤더 (제목+버튼)] */
        .box-header {
            padding: 20px 30px;
            border-bottom: 1px solid var(--glass-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(0,0,0,0.2);
            flex-shrink: 0; 
        }

        .box-title { 
            font-size: 1.2rem; font-weight: 700; color: white; 
            display: flex; align-items: center; gap: 10px; 
        }

        /* [카테고리 탭 (필터)] */
        .category-tabs {
            display: flex; gap: 10px; padding: 15px 30px 15px 30px; flex-shrink: 0;
            border-bottom: 1px solid rgba(255,255,255,0.03);
        }
        .cat-tab {
            text-decoration: none; color: #8b949e; font-weight: 700; padding: 6px 14px;
            border-radius: 50px; transition: all 0.2s; background: rgba(255, 255, 255, 0.03);
            font-size: 0.85rem; border: 1px solid transparent;
        }
        .cat-tab:hover { color: white; background: rgba(255, 255, 255, 0.1); }
        /* 활성화된 탭 스타일 */
        .cat-tab.active {
            background: rgba(252, 213, 53, 0.15); color: var(--primary-gold);
            border-color: var(--primary-gold); box-shadow: 0 0 10px rgba(252, 213, 53, 0.1);
        }

        /* [테이블 영역 설정] */
        .table-container {
            flex: 1; 
            overflow-y: auto; /* 세로 스크롤만 허용 (목록이 길어질 경우) */
            overflow-x: hidden; /* 가로 스크롤 강제 숨김 */
            padding: 0; 
            display: flex;
            flex-direction: column;
            width: 100%;
        }

        .custom-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            color: #eaecef;
            margin-bottom: auto;
            table-layout: fixed; /* 셀 너비 고정 (텍스트 말줄임표 처리에 필수) */
        }
        
        /* 테이블 헤더 Sticky (스크롤 시 고정) */
        .custom-table thead th {
            position: sticky;
            top: 0;
            background: #1E2329; 
            color: var(--text-gray);
            font-weight: 600;
            font-size: 0.8rem;
            padding: 15px 10px;
            border-bottom: 1px solid #474d57;
            text-align: center;
            z-index: 10;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            white-space: nowrap;
        }

        .custom-table tbody td {
            padding: 18px 10px;
            border-bottom: 1px solid rgba(255,255,255,0.03);
            font-size: 0.95rem;
            vertical-align: middle;
            white-space: nowrap;    /* 줄바꿈 방지 */
            overflow: hidden;       /* 넘치는 내용 숨김 */
            text-overflow: ellipsis; /* 말줄임표(...) 처리 */
        }

        .custom-table tbody tr { transition: all 0.2s; }
        .custom-table tbody tr:hover { background-color: var(--table-hover); transform: scale(1.001); }

        /* [링크 및 버튼] */
        .post-link { 
            text-decoration: none; color: white; font-weight: 500; transition: color 0.2s; 
            display: block; width: 100%; 
            overflow: hidden; text-overflow: ellipsis;
        }
        .post-link:hover { color: var(--primary-gold); }

        .btn-gold {
            background: var(--primary-gold); color: black; font-weight: 800; border: none; padding: 10px 25px;
            border-radius: 8px; transition: all 0.2s; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-gold:hover { background: #f0b90b; transform: translateY(-2px); box-shadow: var(--neon-shadow); }

        .badge-reply { font-size: 0.7rem; background: rgba(252, 213, 53, 0.15); color: var(--primary-gold); padding: 2px 6px; border-radius: 4px; margin-left: 8px; font-weight: 700; }

        /* [페이지네이션] */
        .pagination { gap: 5px; margin: 30px 0 20px 0; justify-content: center; }
        .custom-page-link {
            background: transparent; border: 1px solid var(--glass-border); color: #8b949e;
            border-radius: 8px !important; padding: 8px 16px; font-weight: 600; transition: all 0.2s; text-decoration: none; display: block;
        }
        .custom-page-link:hover { background: rgba(252, 213, 53, 0.1); color: var(--primary-gold); border-color: var(--primary-gold); }
        .page-item.active .custom-page-link { background: var(--primary-gold); color: #0d1117; border-color: var(--primary-gold); font-weight: 800; }

        /* [하단 월드 타임바] */
        .world-clock-strip {
            background: rgba(0, 0, 0, 0.85); border-top: 1px solid var(--glass-border); padding: 4px 0; font-size: 0.7rem; flex-shrink: 0;
        }
        .world-clock-item { display: inline-flex; align-items: center; gap: 4px; padding: 2px 10px; color: rgba(255, 255, 255, 0.6); }
        .world-clock-time { font-family: 'Roboto Mono', monospace; font-weight: 700; color: var(--primary-gold); }
    </style>
</head>
<body>

    <!-- 
    =================================================================
      NAVBAR HEADER
    =================================================================
    -->
    <nav class="navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <!-- 로고 -->
            <a href="/" class="brand-logo"><i class="fa-solid fa-earth-asia"></i> RateGo</a>
            
            <!-- 우측 정보 (시간 / 로그인 유저) -->
            <div class="d-flex align-items-center gap-4 text-secondary small fw-bold">
                <span><i class="fa-regular fa-clock me-1"></i> Current Time <span id="clock" class="text-white ms-1">00:00:00</span></span>
                
                <%-- 세션에 유저 정보가 있는지 확인 --%>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span class="text-gold"><i class="fa-solid fa-user me-1"></i> ${sessionScope.user.userName}님</span>
                    </c:when>
                    <c:otherwise>
                        <span class="text-secondary"><i class="fa-solid fa-user-slash me-1"></i> Guest</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <!-- 
    =================================================================
      MAIN CONTAINER (게시판 영역)
    =================================================================
    -->
    <div class="container main-container">
        <div class="glass-box">
            
            <!-- 1. 헤더 영역 (타이틀 + 글쓰기 버튼) -->
            <div class="box-header">
                <div class="box-title">
                    <i class="fa-solid fa-comments text-gold"></i>
                    <span>Traveler Community Board</span>
                    <span class="badge bg-secondary bg-opacity-25 ms-2 text-secondary" style="font-size: 0.8rem; font-weight: 500;">자유게시판</span>
                </div>
                <a href="register.do" class="btn-gold">
                    <i class="fa-solid fa-pen"></i> 새 글 작성
                </a>
            </div>

            <!-- 2. 카테고리 필터 탭 -->
            <%-- 현재 선택된 카테고리(pageCategory)에 따라 'active' 클래스 추가 --%>
            <div class="category-tabs">
                <a href="list.do?pageNum=1&amount=10" class="cat-tab ${empty pageCategory ? 'active' : ''}">전체</a>
                <a href="list.do?pageNum=1&amount=10&category=잡담" class="cat-tab ${pageCategory eq '잡담' ? 'active' : ''}">💬 잡담</a>
                <a href="list.do?pageNum=1&amount=10&category=정보" class="cat-tab ${pageCategory eq '정보' ? 'active' : ''}">📢 정보</a>
                <a href="list.do?pageNum=1&amount=10&category=질문" class="cat-tab ${pageCategory eq '질문' ? 'active' : ''}">❓ 질문</a>
                <a href="list.do?pageNum=1&amount=10&category=후기" class="cat-tab ${pageCategory eq '후기' ? 'active' : ''}">📸 후기</a>
            </div>

            <!-- 3. 게시글 목록 테이블 -->
            <div class="table-container">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th width="8%">NO.</th>
                            <th width="50%" style="text-align: left; padding-left: 20px;">SUBJECT</th>
                            <th width="15%">WRITER</th>
                            <th width="15%">DATE</th>
                            <th width="12%">VIEWS</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${list}" var="board">
                            <tr>
                                <!-- 글 번호 -->
                                <td class="text-center text-secondary font-monospace small">${board.bno}</td>
                                
                                <!-- 제목 (클릭 시 상세 이동) -->
                                <td style="padding-left: 20px;">
                                    <a href="get.do?bno=${board.bno}" class="post-link">
                                        
                                        <%-- 카테고리별 뱃지 색상 분기 처리 --%>
                                        <c:choose>
                                            <c:when test="${board.category eq '정보'}">
                                                <span class="badge bg-success bg-opacity-25 text-success me-2 border border-success border-opacity-25">정보</span>
                                            </c:when>
                                            <c:when test="${board.category eq '질문'}">
                                                <span class="badge bg-primary bg-opacity-25 text-primary me-2 border border-primary border-opacity-25">질문</span>
                                            </c:when>
                                            <c:when test="${board.category eq '후기'}">
                                                <span class="badge bg-danger bg-opacity-25 text-danger me-2 border border-danger border-opacity-25">후기</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary bg-opacity-25 text-secondary me-2 border border-secondary border-opacity-25">${board.category}</span>
                                            </c:otherwise>
                                        </c:choose>

                                        ${board.title}
                                        
                                        <%-- 댓글 수 표시 (0개보다 많을 때만) --%>
                                        <c:if test="${board.replycnt > 0}">
                                            <span class="badge-reply">[${board.replycnt}]</span>
                                        </c:if>
                                        
                                        <%-- 인기글(HOT) 뱃지: 조회수 100 이상 or 좋아요 10 이상 --%>
                                        <c:if test="${board.viewcnt >= 100 or board.likecnt >= 10}">
                                            <span class="badge bg-warning text-dark ms-1" style="font-size: 0.6em;">HOT</span>
                                        </c:if>
                                    </a>
                                </td>
                                
                                <!-- 작성자 -->
                                <td class="text-center">
                                    <i class="fa-regular fa-user text-secondary me-1 small"></i> ${board.writer}
                                </td>
                                
                                <!-- 작성일 -->
                                <td class="text-center text-secondary small">
                                    <fmt:formatDate value="${board.regdate}" pattern="MM-dd HH:mm"/>
                                </td>
                                
                                <!-- 조회수 -->
                                <td class="text-center text-secondary small">
                                    <i class="fa-regular fa-eye me-1"></i> ${board.viewcnt}
                                </td>
                            </tr>
                        </c:forEach>

                        <%-- 게시글이 하나도 없을 경우 --%>
                        <c:if test="${empty list}">
                            <tr>
                                <td colspan="5" class="text-center py-5">
                                    <div class="text-secondary opacity-50">
                                        <i class="fa-regular fa-folder-open fa-3x mb-3"></i><br>
                                        <c:if test="${not empty pageCategory}">
                                            '${pageCategory}' 카테고리에<br>
                                        </c:if>
                                        등록된 게시글이 없습니다.
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                
                <!-- 4. 페이지네이션 (Pagination) -->
                <c:if test="${pageMaker.total > 0}">
                    <div class="d-flex justify-content-center pb-3">
                        <nav aria-label="Page navigation">
                            <ul class="pagination">
                                
                                <!-- 이전 버튼 -->
                                <c:if test="${pageMaker.prev}">
                                    <li class="page-item">
                                        <a class="page-link custom-page-link" href="list.do?pageNum=${pageMaker.startPage - 1}&amount=${pageMaker.cri.amount}&category=${pageCategory}">
                                            <i class="fa-solid fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <!-- 페이지 번호 반복 -->
                                <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                                    <li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                                        <a class="page-link custom-page-link" href="list.do?pageNum=${num}&amount=${pageMaker.cri.amount}&category=${pageCategory}">
                                            ${num}
                                        </a>
                                    </li>
                                </c:forEach>

                                <!-- 다음 버튼 -->
                                <c:if test="${pageMaker.next}">
                                    <li class="page-item">
                                        <a class="page-link custom-page-link" href="list.do?pageNum=${pageMaker.endPage + 1}&amount=${pageMaker.cri.amount}&category=${pageCategory}">
                                            <i class="fa-solid fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- 
    =================================================================
      FOOTER WIDGET (World Time)
    =================================================================
    -->
    <div class="world-clock-strip">
        <div class="container d-flex align-items-center gap-2 overflow-hidden">
            <span class="text-gold fw-bold me-2"><i class="fa-solid fa-globe"></i> World Time</span>
            <div id="world-clock-ticker" class="d-flex gap-3"></div>
        </div>
    </div>

    <!-- 
    =================================================================
      JAVASCRIPT LOGIC
    =================================================================
    -->
    <script>
        // 세계 시간 데이터 정의 (주요 도시 및 오프셋)
        const WORLD_ZONES = [
            { city: "뉴욕 (NY)",   offset: -4, symbol: "🇺🇸" },
            { city: "런던 (GMT)",  offset:  1, symbol: "🇬🇧" },
            { city: "두바이 (DXB)", offset: 4, symbol: "🇦🇪" },
            { city: "싱가포르 (SIN)", offset: 8, symbol: "🇸🇬" },
            { city: "베이징 (PEK)",   offset: 8, symbol: "🇨🇳" },
            { city: "도쿄 (TYO)",  offset:  9, symbol: "🇯🇵" },
            { city: "시드니 (SYD)", offset: 11, symbol: "🇦🇺" }
        ];

        // 시간 업데이트 함수
        function updateTime() {
            const now = new Date();
            // 상단 Navbar 시간 갱신
            const clock = document.getElementById('clock');
            if(clock) clock.innerText = now.toLocaleTimeString('ko-KR');

            // 하단 World Time Ticker 갱신
            const utc = now.getTime() + (now.getTimezoneOffset() * 60000);
            const ticker = document.getElementById('world-clock-ticker');
            if(ticker) {
                let html = '';
                WORLD_ZONES.forEach(z => {
                    const t = new Date(utc + (3600000 * z.offset));
                    const ts = t.toLocaleTimeString('en-US', {hour:'2-digit', minute:'2-digit', hour12:true});
                    html += `<div class="world-clock-item"><span>${z.symbol} ${z.city}</span> <span class="world-clock-time">${ts}</span></div>`;
                });
                ticker.innerHTML = html;
            }
        }

        // 1초마다 실행
        setInterval(updateTime, 1000);
        updateTime(); // 최초 실행
    </script>
</body>
</html>