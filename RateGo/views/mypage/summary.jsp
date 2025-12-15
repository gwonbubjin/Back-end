<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%--
*******************************************************************************
* [summary.jsp]
* 설명 : 마이페이지 메인 대시보드 화면
* 주요 기능 :
* 1. 사용자 핵심 지표(총 포인트, 작성글 수, 받은 좋아요) 카드 형태 표시
* 2. 최근 작성한 게시글 5~10개 요약 리스트 출력
* 3. 마이페이지 네비게이션(사이드바) 포함
*******************************************************************************
--%>

<html>
<head>
    <title>RateGo - 마이페이지</title>
    
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
      CUSTOM CSS (Dashboard Theme)
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

        /* [LAYOUT] 전체 화면 고정 (스크롤 없음) */
        body {
            background-color: var(--bg-body);
            background-image: radial-gradient(circle at 0% 0%, #161b22 0%, #0d1117 60%);
            color: var(--text-main);
            font-family: 'Pretendard', sans-serif;
            height: 100vh;
            margin: 0;
            overflow: hidden;
            display: flex;
        }

        /* 메인 컨테이너 (사이드바 + 콘텐츠 영역) */
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
        
        /* 프로필 영역 */
        .profile-section { text-align: center; margin-bottom: 40px; }
        .profile-img {
            width: 100px; height: 100px; border-radius: 50%; background: #161b22;
            border: 2px solid var(--primary-gold); display: flex; align-items: center; justify-content: center;
            font-size: 3rem; color: var(--primary-gold); margin: 0 auto 15px;
            box-shadow: 0 0 15px rgba(252, 213, 53, 0.2);
        }
        .user-name { font-size: 1.4rem; font-weight: 700; color: white; }
        .user-id { 
            color: var(--primary-gold); font-size: 1rem; font-weight: 700; 
            letter-spacing: 1px; text-shadow: 0 0 10px rgba(252, 213, 53, 0.3); margin-top: 5px; 
        }
        
        /* 메뉴 링크 */
        .menu-list a {
            display: flex; align-items: center; gap: 15px; padding: 14px 20px;
            color: var(--text-sub); text-decoration: none; font-weight: 600;
            border-radius: 12px; transition: all 0.2s; margin-bottom: 5px;
        }
        .menu-list a:hover { background: rgba(255,255,255,0.05); color: white; }
        .menu-list a.active { background: rgba(252, 213, 53, 0.1); color: var(--primary-gold); }
        .menu-logout { margin-top: auto; color: #f6465d !important; }

        /* [MAIN CONTENT] 우측 콘텐츠 영역 */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
            height: 100%;
            overflow: hidden;
        }

        /* [STATS CARDS] 상단 3개 통계 카드 */
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

        /* [RECENT ACTIVITY] 최근 활동 테이블 영역 */
        .activity-section {
            flex: 1; background: var(--glass-bg); border: 1px solid var(--glass-border);
            border-radius: 20px; display: flex; flex-direction: column;
            overflow: hidden; padding: 25px;
        }
        .section-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 15px; flex-shrink: 0;
        }
        .section-title { font-size: 1.2rem; font-weight: 700; color: white; }
        .view-all { font-size: 0.8rem; color: var(--primary-gold); text-decoration: none; font-weight: 700; }

        /* 테이블 스타일 */
        .table-wrapper { flex: 1; overflow-y: auto; }
        .custom-table { width: 100%; border-collapse: collapse; }
        
        /* Sticky Header */
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

        /* [BADGES] 카테고리 뱃지 스타일 */
        .cat-badge {
            font-size: 0.7rem; font-weight: 700; padding: 4px 10px; border-radius: 6px;
            display: inline-block; min-width: 50px; text-align: center;
            background: rgba(255,255,255,0.1); color: white;
        }
        .cat-talk { color: #FCD535; background: rgba(252, 213, 53, 0.1); border: 1px solid rgba(252, 213, 53, 0.2); }
        .cat-info { color: #0ecb81; background: rgba(14, 203, 129, 0.1); border: 1px solid rgba(14, 203, 129, 0.2); }
        .cat-qna  { color: #3b82f6; background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.2); }
        .cat-review { color: #f6465d; background: rgba(246, 70, 93, 0.1); border: 1px solid rgba(246, 70, 93, 0.2); }
        .cat-etc { color: #8b949e; background: rgba(139, 148, 158, 0.1); border: 1px solid rgba(139, 148, 158, 0.2); }

        .text-date { font-family: 'Roboto Mono'; font-size: 0.8rem; color: var(--text-sub); }
        .t-react i { margin-right: 4px; font-size: 0.8rem; }
    </style>
</head>
<body>

    <div class="dashboard-container">
        
        <!-- 
        =================================================================
          [LEFT SIDEBAR] 마이페이지 메뉴
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
                <!-- 현재 페이지 활성화 (active 클래스) -->
                <a href="/mypage.do" class="active"><i class="fa-solid fa-chart-pie"></i> 활동 요약</a>
                <a href="/mypage/checkPw.do"><i class="fa-solid fa-user-pen"></i> 정보 수정</a>
                <a href="/mypage/activity.do"><i class="fa-solid fa-clock-rotate-left"></i> 전체 활동 내역</a>
                <a href="/mypage/points.do"><i class="fa-solid fa-wallet"></i> 포인트 관리</a>
                <a href="/logout.do" class="menu-logout"><i class="fa-solid fa-right-from-bracket"></i> 로그아웃</a>
            </div>
        </div>

        <!-- 
        =================================================================
          [MAIN CONTENT] 대시보드 컨텐츠
        =================================================================
        -->
        <div class="main-content">
            
            <!-- 1. [STATS ROW] 핵심 지표 카드 -->
            <div class="stats-row">
                <!-- 포인트 (숫자 포맷팅 적용) -->
                <div class="stat-card">
                    <div class="stat-icon" style="color:#FCD535;"><i class="fa-solid fa-coins"></i></div>
                    <div class="stat-info">
                        <h4><fmt:formatNumber value="${sessionScope.user.points}" pattern="#,###" /></h4>
                        <p>Total Points</p>
                    </div>
                </div>
                <!-- 작성글 수 -->
                <div class="stat-card">
                    <div class="stat-icon" style="color:#3b82f6;"><i class="fa-solid fa-file-lines"></i></div>
                    <div class="stat-info">
                        <h4>${postCount}</h4>
                        <p>My Posts</p>
                    </div>
                </div>
                <!-- 받은 좋아요 수 -->
                <div class="stat-card">
                    <div class="stat-icon" style="color:#f6465d;"><i class="fa-solid fa-heart"></i></div>
                    <div class="stat-info">
                        <h4>${likesReceived}</h4>
                        <p>Likes Received</p>
                    </div>
                </div>
            </div>
            
            <!-- 2. [RECENT ACTIVITY] 최근 활동 내역 리스트 -->
            <div class="activity-section">
                 <div class="section-header">
                    <div class="section-title">Recent Activity</div>
                    <a href="/mypage/activity.do" class="view-all">VIEW ALL <i class="fa-solid fa-arrow-right ms-1"></i></a>
                 </div>
                 
                 <div class="table-wrapper">
                     <table class="custom-table">
                        <thead>
                            <tr>
                                <th width="15%">Type</th>
                                <th width="50%">Subject</th>
                                <th width="20%" class="text-center">Date</th>
                                <th width="15%" class="text-end">Reacts</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${myRecentList}" var="post">
                                <tr onclick="location.href='/board/get.do?bno=${post.bno}'">
                                    <!-- 카테고리 뱃지 -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${post.category eq '잡담'}"><span class="cat-badge cat-talk">잡담</span></c:when>
                                            <c:when test="${post.category eq '정보'}"><span class="cat-badge cat-info">정보</span></c:when>
                                            <c:when test="${post.category eq '질문'}"><span class="cat-badge cat-qna">질문</span></c:when>
                                            <c:when test="${post.category eq '후기'}"><span class="cat-badge cat-review">후기</span></c:when>
                                            <c:otherwise><span class="cat-badge cat-etc">${post.category}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <!-- 제목 -->
                                    <td class="fw-bold text-truncate" style="max-width: 300px;">
                                        ${post.title}
                                    </td>
                                    
                                    <!-- 날짜 -->
                                    <td class="text-center text-date">
                                        <fmt:formatDate value="${post.regdate}" pattern="MM-dd HH:mm"/>
                                    </td>
                                    
                                    <!-- 반응(조회/좋아요) -->
                                    <td class="text-end t-react text-secondary">
                                        <i class="fa-regular fa-eye"></i> ${post.viewcnt}
                                        <span class="mx-2"></span>
                                        <i class="fa-solid fa-heart text-danger"></i> ${post.likecnt}
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <!-- 데이터 없음 (Empty State) -->
                            <c:if test="${empty myRecentList}">
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-sub">
                                        <i class="fa-regular fa-folder-open fa-3x mb-3"></i><br>
                                        아직 작성한 게시글이 없습니다.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                     </table>
                 </div>
            </div>
            
        </div>
    </div>

</body>
</html>