<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page isELIgnored="false" %>

<%--
*******************************************************************************
* [activity.jsp]
* 설명 : 마이페이지 - 내 전체 활동 내역 조회 화면
* 주요 기능 :
* 1. 활동 요약 통계 (포인트, 게시글 수, 받은 좋아요)
* 2. 탭(Tab) 기반 활동 내역 조회 (작성글 / 작성댓글 / 좋아요한 글)
* 3. 실시간 클라이언트 검색 (JavaScript Filter)
* 디자인 : Dashboard 스타일의 Split Layout (Sidebar + Main Content)
*******************************************************************************
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>RateGo - Activity Log</title>
    
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
      CUSTOM CSS (Dashboard Layout)
    =================================================================
    -->
    <style>
        /* [ROOT VARIABLES] */
        :root {
            --primary-gold: #FCD535;
            --bg-body: #0d1117;
            --glass-bg: rgba(22, 27, 34, 0.7);
            --glass-border: rgba(255, 255, 255, 0.08);
            --text-main: #e6edf3;
            --text-sub: #8b949e;
            --table-hover: rgba(252, 213, 53, 0.05);
        }

        /* [LAYOUT] 전체 레이아웃 설정 */
        body {
            background-color: var(--bg-body);
            background-image: radial-gradient(circle at 0% 0%, #161b22 0%, #0d1117 60%);
            color: var(--text-main);
            font-family: 'Pretendard', sans-serif;
            height: 100vh;
            margin: 0;
            overflow: hidden; /* 스크롤은 내부 컨테이너에서 처리 */
            display: flex;
        }

        .dashboard-container {
            display: flex;
            width: 100%;
            height: 100%;
            padding: 20px;
            gap: 20px;
        }

        /* [SIDEBAR] 좌측 네비게이션 메뉴 */
        .sidebar {
            width: 280px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            display: flex;
            flex-direction: column;
            padding: 30px 20px;
            flex-shrink: 0;
        }
        .home-btn {
            text-decoration: none; color: var(--primary-gold); font-weight: 800; font-size: 1.2rem;
            margin-bottom: 40px; display: flex; align-items: center; gap: 10px;
        }
        
        /* 프로필 섹션 */
        .profile-section { text-align: center; margin-bottom: 40px; }
        .profile-img {
            width: 100px; height: 100px; border-radius: 50%; background: #161b22;
            border: 2px solid var(--primary-gold); display: flex; align-items: center; justify-content: center;
            font-size: 3rem; color: var(--primary-gold); margin: 0 auto 15px;
            box-shadow: 0 0 15px rgba(252, 213, 53, 0.2);
        }
        .user-name { font-size: 1.4rem; font-weight: 700; color: white; }
        .user-id { color: var(--primary-gold); font-size: 1rem; font-weight: 700; letter-spacing: 1px; margin-top: 5px; }
        
        /* 메뉴 리스트 */
        .menu-list a {
            display: flex; align-items: center; gap: 15px; padding: 14px 20px;
            color: var(--text-sub); text-decoration: none; font-weight: 600;
            border-radius: 12px; transition: all 0.2s; margin-bottom: 5px;
        }
        .menu-list a:hover { background: rgba(255,255,255,0.05); color: white; }
        .menu-list a.active { background: rgba(252, 213, 53, 0.1); color: var(--primary-gold); }
        .menu-logout { margin-top: auto; color: #f6465d !important; }

        /* [MAIN CONTENT] 우측 메인 영역 */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
            height: 100%;
            overflow: hidden;
        }

        /* [STATS CARDS] 상단 통계 카드 (3열) */
        .stats-row { display: flex; gap: 20px; height: 110px; flex-shrink: 0; }
        .stat-card {
            flex: 1; background: var(--glass-bg); border: 1px solid var(--glass-border);
            border-radius: 16px; display: flex; align-items: center; padding: 0 30px; gap: 20px;
        }
        .stat-icon {
            width: 50px; height: 50px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; background: rgba(255,255,255,0.03);
        }
        .stat-info h4 { font-size: 1.5rem; font-weight: 800; margin: 0; color: white; font-family: 'Roboto Mono'; }
        .stat-info p { margin: 0; font-size: 0.8rem; color: var(--text-sub); text-transform: uppercase; letter-spacing: 1px; }

        /* [ACTIVITY SECTION] 활동 내역 리스트 영역 */
        .activity-section {
            flex: 1; background: var(--glass-bg); border: 1px solid var(--glass-border);
            border-radius: 20px; display: flex; flex-direction: column;
            overflow: hidden; padding: 25px;
        }

        /* 섹션 헤더 (제목 + 탭 + 검색창) */
        .section-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px; flex-shrink: 0;
        }
        .header-left { display: flex; align-items: center; gap: 20px; }
        .page-title { font-size: 1.3rem; font-weight: 700; color: white; margin: 0; }
        
        /* 탭 버튼 스타일 */
        .filter-tabs { display: flex; gap: 8px; }
        .tab-btn {
            background: rgba(255,255,255,0.05); border: none; color: var(--text-sub);
            padding: 6px 14px; border-radius: 50px; font-weight: 600; font-size: 0.85rem; cursor: pointer; transition: all 0.2s;
        }
        .tab-btn:hover { background: rgba(255,255,255,0.1); color: white; }
        .tab-btn.active { background: var(--primary-gold); color: #0d1117; }

        /* 검색창 스타일 */
        .search-box { position: relative; width: 250px; }
        .search-input {
            width: 100%; background: #161b22; border: 1px solid var(--glass-border);
            color: white; padding: 8px 15px 8px 35px; border-radius: 8px; outline: none; font-size: 0.9rem;
        }
        .search-input:focus { border-color: var(--primary-gold); }
        .search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-sub); font-size: 0.8rem; }

        /* 테이블 스타일 */
        .table-wrapper { flex: 1; overflow-y: auto; display: flex; flex-direction: column; }
        .custom-table { width: 100%; border-collapse: collapse; margin-bottom: auto; }
        .custom-table th {
            text-align: left; color: var(--text-sub); font-size: 0.75rem; 
            padding: 12px 15px; font-weight: 600; text-transform: uppercase;
            position: sticky; top: 0; background: #0d1117; z-index: 1; border-bottom: 1px solid var(--glass-border);
        }
        .custom-table td {
            padding: 12px 15px; border-bottom: 1px solid rgba(255,255,255,0.03);
            vertical-align: middle; color: var(--text-main); font-size: 0.9rem;
        }
        .custom-table tr:hover { background: var(--table-hover); cursor: pointer; }

        /* 카테고리 뱃지 */
        .cat-badge {
            font-size: 0.7rem; font-weight: 700; padding: 4px 10px; border-radius: 6px;
            display: inline-block; min-width: 50px; text-align: center;
        }
        .cat-talk { color: #FCD535; background: rgba(252, 213, 53, 0.1); border: 1px solid rgba(252, 213, 53, 0.2); }
        .cat-info { color: #0ecb81; background: rgba(14, 203, 129, 0.1); border: 1px solid rgba(14, 203, 129, 0.2); }
        .cat-qna  { color: #3b82f6; background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.2); }
        .cat-review { color: #f6465d; background: rgba(246, 70, 93, 0.1); border: 1px solid rgba(246, 70, 93, 0.2); }
        .cat-etc { color: #8b949e; background: rgba(139, 148, 158, 0.1); border: 1px solid rgba(139, 148, 158, 0.2); }

        .stat-box { font-size: 0.8rem; color: var(--text-sub); display: flex; gap: 12px; }
        
        /* 페이지네이션 */
        .pagination-area {
            display: flex; justify-content: center; gap: 5px; margin-top: 20px; padding-bottom: 10px;
        }
        .page-link-custom {
            background: rgba(255,255,255,0.05); border: 1px solid var(--glass-border); color: var(--text-sub);
            padding: 6px 12px; border-radius: 6px; font-size: 0.85rem; text-decoration: none; transition: all 0.2s;
        }
        .page-link-custom:hover { background: rgba(255,255,255,0.1); color: white; }
        .page-link-custom.active { background: var(--primary-gold); color: #0d1117; border-color: var(--primary-gold); font-weight: 700; }
    </style>
</head>
<body>

    <div class="dashboard-container">
        
        <!-- 
        =================================================================
          [LEFT SIDEBAR] 프로필 및 메뉴 네비게이션
        =================================================================
        -->
        <div class="sidebar">
            <a href="/" class="home-btn"><i class="fa-solid fa-chevron-left"></i> MAIN</a>
            
            <div class="profile-section">
                <div class="profile-img"><i class="fa-solid fa-user"></i></div>
                <div class="user-name">${sessionScope.user.userName}</div>
                <div class="user-id">@${sessionScope.user.userId}</div>
            </div>
            
            <div class="menu-list">
                <a href="/mypage.do"><i class="fa-solid fa-chart-pie"></i> 활동 요약</a>
                <a href="/mypage/checkPw.do"><i class="fa-solid fa-user-pen"></i> 정보 수정</a>
                <a href="/mypage/activity.do" class="active"><i class="fa-solid fa-clock-rotate-left"></i> 전체 활동</a>
                <a href="/mypage/points.do"><i class="fa-solid fa-wallet"></i> 포인트 관리</a>
                <a href="/logout.do" class="menu-logout"><i class="fa-solid fa-right-from-bracket"></i> 로그아웃</a>
            </div>
        </div>

        <!-- 
        =================================================================
          [MAIN CONTENT] 통계 및 활동 내역 테이블
        =================================================================
        -->
        <div class="main-content">
            
            <!-- 1. 상단 요약 통계 카드 -->
            <div class="stats-row">
                <!-- 포인트 카드 -->
                <div class="stat-card">
                    <div class="stat-icon" style="color:#FCD535;"><i class="fa-solid fa-coins"></i></div>
                    <div class="stat-info">
                        <h4><fmt:formatNumber value="${sessionScope.user.points}" pattern="#,###" /></h4>
                        <p>Points</p>
                    </div>
                </div>
                <!-- 작성글 수 카드 -->
                <div class="stat-card">
                    <div class="stat-icon" style="color:#3b82f6;"><i class="fa-solid fa-file-lines"></i></div>
                    <div class="stat-info">
                        <h4>${postCount}</h4>
                        <p>Posts</p>
                    </div>
                </div>
                <!-- 받은 좋아요 카드 -->
                <div class="stat-card">
                    <div class="stat-icon" style="color:#f6465d;"><i class="fa-solid fa-heart"></i></div>
                    <div class="stat-info">
                        <h4>${likesReceived}</h4>
                        <p>Likes</p>
                    </div>
                </div>
            </div>

            <!-- 2. 활동 내역 리스트 섹션 -->
            <div class="activity-section">
                
                <!-- 섹션 헤더: 탭 버튼 & 검색창 -->
                <div class="section-header">
                    <div class="header-left">
                        <span class="page-title">My Activities</span>
                        <div class="filter-tabs">
                            <button class="tab-btn active" onclick="showTab('posts', this)">작성글</button>
                            <button class="tab-btn" onclick="showTab('comments', this)">작성댓글</button>
                            <button class="tab-btn" onclick="showTab('likes', this)">좋아요</button>
                        </div>
                    </div>
                    
                    <div class="search-box">
                        <i class="fa-solid fa-magnifying-glass search-icon"></i>
                        <!-- JS onkeyup 이벤트로 실시간 필터링 -->
                        <input type="text" id="searchInput" class="search-input" placeholder="내 게시글 검색..." onkeyup="filterTable()">
                    </div>
                </div>

                <!-- 테이블 영역 -->
                <div class="table-wrapper">
                    
                    <!-- [TAB 1] 작성글 목록 -->
                    <div id="tab-posts" class="tab-content active">
                        <table class="custom-table" id="postsTable">
                            <thead>
                                <tr>
                                    <th width="15%" class="text-center">Type</th>
                                    <th width="45%">Subject</th>
                                    <th width="15%" class="text-center">Stats</th>
                                    <th width="15%" class="text-center">Date</th>
                                    <th width="10%" class="text-end">Link</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${activityList}" var="post">
                                    <tr onclick="location.href='/board/get.do?bno=${post.bno}'">
                                        <!-- 카테고리 뱃지 분기 -->
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${post.category eq '잡담'}"><span class="cat-badge cat-talk">잡담</span></c:when>
                                                <c:when test="${post.category eq '정보'}"><span class="cat-badge cat-info">정보</span></c:when>
                                                <c:when test="${post.category eq '질문'}"><span class="cat-badge cat-qna">질문</span></c:when>
                                                <c:when test="${post.category eq '후기'}"><span class="cat-badge cat-review">후기</span></c:when>
                                                <c:otherwise><span class="cat-badge cat-etc">${post.category}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        
                                        <!-- 제목 -->
                                        <td class="fw-bold text-truncate title-cell" style="max-width: 350px;">
                                            ${post.title}
                                            <c:if test="${post.replycnt > 0}">
                                                <span class="text-gold ms-1 small">[${post.replycnt}]</span>
                                            </c:if>
                                        </td>
                                        
                                        <!-- 통계 (조회수/좋아요) -->
                                        <td class="text-center">
                                            <div class="stat-box justify-content-center">
                                                <span><i class="fa-regular fa-eye"></i> ${post.viewcnt}</span>
                                                <span class="text-danger"><i class="fa-solid fa-heart"></i> ${post.likecnt}</span>
                                            </div>
                                        </td>
                                        
                                        <!-- 날짜 -->
                                        <td class="text-center" style="font-family: 'Roboto Mono'; font-size: 0.85rem; color: var(--text-sub);">
                                            <fmt:formatDate value="${post.regdate}" pattern="yyyy-MM-dd"/>
                                        </td>
                                        
                                        <!-- 이동 아이콘 -->
                                        <td class="text-end text-gold"><i class="fa-solid fa-arrow-up-right-from-square"></i></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- 페이지네이션 (작성글에만 적용됨) -->
                        <c:if test="${pageMaker.total > 0}">
                            <div class="pagination-area">
                                <c:if test="${pageMaker.prev}">
                                    <a href="activity.do?pageNum=${pageMaker.startPage - 1}&amount=${pageMaker.cri.amount}" class="page-link-custom"><i class="fa-solid fa-chevron-left"></i></a>
                                </c:if>
                                <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                                    <a href="activity.do?pageNum=${num}&amount=${pageMaker.cri.amount}" class="page-link-custom ${pageMaker.cri.pageNum == num ? 'active' : ''}">${num}</a>
                                </c:forEach>
                                <c:if test="${pageMaker.next}">
                                    <a href="activity.do?pageNum=${pageMaker.endPage + 1}&amount=${pageMaker.cri.amount}" class="page-link-custom"><i class="fa-solid fa-chevron-right"></i></a>
                                </c:if>
                            </div>
                        </c:if>
                    </div>

                    <!-- [TAB 2] 작성 댓글 목록 -->
                    <div id="tab-comments" class="tab-content" style="display:none;">
                        <table class="custom-table" id="commentsTable">
                            <thead><tr><th width="60%">Comment & Post</th><th width="25%" class="text-center">Date</th><th width="15%" class="text-end">Link</th></tr></thead>
                            <tbody>
                                <c:forEach items="${commentList}" var="reply">
                                    <tr onclick="location.href='/board/get.do?bno=${reply.bno}'">
                                        <td class="title-cell">
                                            <div class="fw-bold text-white text-truncate" style="max-width: 450px;">${reply.reply}</div>
                                            <div class="text-sub small mt-1"><i class="fa-solid fa-turn-up fa-rotate-90 me-2"></i> ${reply.boardTitle}</div>
                                        </td>
                                        <td class="text-center" style="font-family: 'Roboto Mono'; font-size: 0.85rem; color: var(--text-sub);"><fmt:formatDate value="${reply.replyDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td class="text-end text-gold"><i class="fa-solid fa-arrow-up-right-from-square"></i></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- [TAB 3] 좋아요한 글 목록 -->
                    <div id="tab-likes" class="tab-content" style="display:none;">
                        <table class="custom-table" id="likesTable">
                            <thead><tr><th width="15%" class="text-center">Type</th><th width="50%">Subject</th><th width="15%">Writer</th><th width="15%" class="text-center">Date</th><th width="10%" class="text-end">Link</th></tr></thead>
                            <tbody>
                                <c:forEach items="${likedList}" var="like">
                                    <tr onclick="location.href='/board/get.do?bno=${like.bno}'">
                                        <td class="text-center"><span class="cat-badge cat-etc">${like.category}</span></td>
                                        <td class="fw-bold text-truncate title-cell" style="max-width: 350px;">${like.title}</td>
                                        <td class="text-sub small">${like.writer}</td>
                                        <td class="text-center" style="font-family: 'Roboto Mono'; font-size: 0.85rem; color: var(--text-sub);"><fmt:formatDate value="${like.regdate}" pattern="yyyy-MM-dd"/></td>
                                        <td class="text-end text-danger"><i class="fa-solid fa-heart"></i></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <!-- 
    =================================================================
      JAVASCRIPT LOGIC
    =================================================================
    -->
    <script>
        // [TAB SWITCH] 탭 전환 함수
        function showTab(tabId, btn) {
            // 모든 탭 버튼 비활성화
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            // 클릭한 버튼 활성화
            btn.classList.add('active');
            
            // 모든 탭 컨텐츠 숨기기
            document.querySelectorAll('.tab-content').forEach(c => c.style.display = 'none');
            // 선택한 탭 컨텐츠 보이기
            document.getElementById('tab-' + tabId).style.display = 'block';
            
            // 검색창 초기화 및 필터링 리셋
            document.getElementById('searchInput').value = '';
            filterTable(); 
        }

        // [SEARCH FILTER] 현재 보이는 테이블 필터링
        function filterTable() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toUpperCase();
            
            // 현재 활성화된 탭의 테이블 찾기
            const activeTab = document.querySelector('.tab-content[style*="block"]') || document.querySelector('.tab-content.active');
            const table = activeTab.querySelector('table');
            const tr = table.getElementsByTagName('tr');

            // 테이블 행 루프 (헤더 제외하고 1부터 시작)
            for (let i = 1; i < tr.length; i++) { 
                // 'title-cell' 클래스를 가진 td(제목/내용)를 우선 검색
                let td = tr[i].querySelector('.title-cell'); 
                if (!td) { td = tr[i].getElementsByTagName("td")[1]; } // 없으면 두 번째 컬럼 검색
                
                if (td) {
                    const txtValue = td.textContent || td.innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = ""; // 검색어 포함 시 보이기
                    } else {
                        tr[i].style.display = "none"; // 미포함 시 숨기기
                    }
                }
            }
        }
    </script>
</body>
</html>