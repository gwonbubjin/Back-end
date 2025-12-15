<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page isELIgnored="false" %>

<%--
*******************************************************************************
* [ranking.jsp]
* 설명 : 포인트 랭킹(명예의 전당) 조회 화면
* 주요 기능 :
* 1. 전체 유저 중 포인트 상위 10명 조회 (Controller에서 rankingList 전달)
* 2. TOP 3 유저를 위한 시상대(Podium) 디자인 강조
* 3. 4위~10위 유저 리스트 테이블 출력
* 4. 내 랭킹(My Rank) 하이라이트 표시
* 디자인 : 배경 파티클 애니메이션 + Glassmorphism 적용
*******************************************************************************
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>RateGo - Hall of Fame</title>
    
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
      CUSTOM CSS (Ranking Theme)
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
            --scrollbar-thumb: rgba(255, 255, 255, 0.1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        /* [LAYOUT] */
        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            font-family: 'Pretendard', sans-serif;
            height: 100vh;
            margin: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden; /* 배경 애니메이션을 위해 스크롤 숨김 */
            position: relative;
        }

        /* [SCROLLBAR] 커스텀 스크롤바 */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: var(--scrollbar-thumb); border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: rgba(255, 255, 255, 0.2); }

        /* [BACKGROUND ANIMATION] 배경 파티클 효과 */
        .animated-bg { 
            position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 0; 
            background: radial-gradient(circle at 50% -20%, #2b3139, #0b0e11 90%); 
        }
        .bg-particle { 
            position: absolute; border-radius: 50%; 
            background: radial-gradient(circle, rgba(252, 213, 53, 0.4), transparent); 
            animation: float-particle linear infinite; pointer-events: none; 
        }
        @keyframes float-particle { 
            0% { transform: translateY(100vh) scale(0); opacity: 0; } 
            100% { transform: translateY(-100px) scale(1); opacity: 0; } 
        }
        
        /* [NAVBAR] */
        .navbar {
            background: rgba(11, 14, 17, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--glass-border);
            padding: 12px 0;
            flex-shrink: 0;
            position: relative;
            z-index: 100;
        }
        .brand-logo { color: var(--primary-gold); font-weight: 900; font-size: 1.4rem; text-decoration: none; text-shadow: 0 0 20px rgba(252, 213, 53, 0.3); }

        /* [MAIN CONTAINER] 좌우 분할 레이아웃 */
        .ranking-container {
            flex: 1;
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
            position: relative;
            z-index: 10;
            display: flex;
            gap: 30px;
            align-items: stretch; 
            height: 90vh;
            max-height: 800px;
        }

        /* [LEFT SECTION] TOP 3 시상대 영역 */
        .left-section {
            flex: 0 0 340px;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        /* [RIGHT SECTION] 전체 랭킹 리스트 영역 */
        .right-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100%;
            min-width: 0;
        }

        /* [RANK HEADER] 타이틀 */
        .rank-header {
            text-align: center;
            margin-bottom: 20px;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .trophy-icon { font-size: 2rem; color: var(--primary-gold); margin-bottom: 5px; text-shadow: 0 0 30px rgba(252, 213, 53, 0.5); }
        .rank-title { font-size: 1.5rem; font-weight: 900; color: white; margin: 0; letter-spacing: 1px; }
        .rank-subtitle { color: var(--text-sub); font-size: 0.8rem; margin-top: 5px; }

        /* [PODIUM] 시상대 스타일 (1, 2, 3위) */
        .podium-container {
            flex: 1;
            overflow-y: auto;
            padding-right: 5px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .podium-item {
            display: flex;
            align-items: center;
            gap: 12px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 12px 15px;
            backdrop-filter: blur(20px);
            transition: all 0.2s;
            width: 100%;
        }

        /* 순위 뱃지 (금/은/동) */
        .rank-badge { width: 28px; height: 28px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.9rem; flex-shrink: 0; }
        .rank-1-badge { background: #FFD700; color: #000; box-shadow: 0 0 10px rgba(255, 215, 0, 0.4); }
        .rank-2-badge { background: #C0C0C0; color: #000; }
        .rank-3-badge { background: #CD7F32; color: #fff; }

        /* 아바타 (1등은 왕관 추가) */
        .podium-avatar { width: 40px; height: 40px; border-radius: 50%; background: #21262d; border: 2px solid rgba(255,255,255,0.1); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; position: relative; }
        .rank-1-podium .podium-avatar { border-color: #FFD700; box-shadow: 0 0 10px rgba(255, 215, 0, 0.3); }
        .crown { position: absolute; top: -15px; left: 50%; transform: translateX(-50%); font-size: 1rem; }
        
        .podium-info { flex: 1; display: flex; flex-direction: column; justify-content: center; }
        .podium-name { font-weight: 700; color: white; font-size: 0.9rem; }
        .podium-id { color: var(--text-sub); font-size: 0.75rem; }
        .podium-points { font-family: 'Roboto Mono', monospace; font-weight: 700; color: var(--primary-gold); font-size: 0.95rem; }

        /* [MY RANK] 내 순위 하이라이트 박스 */
        .my-rank-wrapper { margin-top: auto; padding-top: 15px; }
        .my-rank-box { background: rgba(252, 213, 53, 0.08); border: 1px solid var(--primary-gold); border-radius: 12px; padding: 15px; backdrop-filter: blur(20px); box-shadow: 0 0 20px rgba(252, 213, 53, 0.1); display: flex; align-items: center; gap: 12px; width: 100%; position: relative; }
        .my-rank-label { position: absolute; top: -10px; left: 15px; background: var(--primary-gold); color: #000; padding: 1px 8px; border-radius: 20px; font-size: 0.65rem; font-weight: 800; letter-spacing: 1px; box-shadow: 0 2px 5px rgba(0,0,0,0.3); }

        /* [RANK TABLE] 우측 순위 테이블 */
        .rank-box {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 0;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            backdrop-filter: blur(20px);
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden; 
            margin-top: 20px;
            height: 100%;
        }

        .rank-table-wrapper {
            overflow-y: auto;
            flex: 1;
            padding: 0; 
        }
        
        .rank-table { width: 100%; border-collapse: collapse; }
        
        /* Sticky Header */
        .rank-table th {
            position: sticky; 
            top: 0; 
            background: #191f26; 
            color: var(--text-sub); 
            font-size: 0.75rem; 
            padding: 15px 20px; 
            text-align: left; 
            border-bottom: 1px solid var(--glass-border); 
            z-index: 20; 
        }
        
        .rank-table td { padding: 12px 20px; border-bottom: 1px solid rgba(255,255,255,0.03); font-size: 0.9rem; vertical-align: middle; }
        .rank-table tr:hover { background: var(--table-hover); }

        .rank-num { font-family: 'Roboto Mono', monospace; font-weight: 700; color: var(--text-sub); width: 25px; text-align: center; font-size: 0.9rem; }
        .top-rank-num { color: var(--primary-gold); font-size: 1rem; }

        .user-info { display: flex; align-items: center; gap: 10px; }
        .table-avatar { width: 32px; height: 32px; border-radius: 50%; background: #30363d; display: flex; align-items: center; justify-content: center; color: #8b949e; font-size: 0.8rem; }
        .rank-1-row .table-avatar { border: 1.5px solid #FFD700; color: #FFD700; }
        
        /* 내 순위 행 강조 */
        .my-rank-row { background: rgba(252, 213, 53, 0.1) !important; }
        .my-rank-row td { border-bottom: 1px solid rgba(252, 213, 53, 0.2); }

        .back-btn { position: absolute; top: 20px; left: 0; color: var(--text-sub); text-decoration: none; font-weight: 600; font-size: 0.85rem; display: flex; align-items: center; gap: 5px; transition: 0.2s; background: rgba(255,255,255,0.05); padding: 6px 12px; border-radius: 20px; }
        .back-btn:hover { color: white; background: rgba(255,255,255,0.1); }

        /* [RESPONSIVE] 모바일 대응 */
        @media (max-width: 900px) {
            .ranking-container { flex-direction: column; height: auto; padding: 20px; overflow: visible; max-height: none; }
            .left-section { height: auto; flex: 0 0 auto; width: 100%; margin-bottom: 20px; }
            .right-section { height: 500px; }
            .rank-header { height: auto; margin-bottom: 15px; }
            .rank-box { margin-top: 0; }
            .my-rank-wrapper { margin-top: 20px; }
            .back-btn { position: static; margin-bottom: 15px; width: fit-content; }
        }
    </style>
</head>
<body>

    <!-- 배경 애니메이션 컨테이너 -->
    <div class="animated-bg" id="animatedBg"></div>

    <!-- 
    =================================================================
      NAVBAR HEADER
    =================================================================
    -->
    <nav class="navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="/" class="brand-logo"><i class="fa-solid fa-earth-asia"></i> RateGo</a>
            <div class="d-flex align-items-center gap-4 text-secondary small fw-bold">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span style="color: var(--primary-gold);"><i class="fa-solid fa-user me-1"></i> ${sessionScope.user.userName}님</span>
                    </c:when>
                    <c:otherwise><span>Guest</span></c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <!-- 
    =================================================================
      MAIN CONTAINER (RANKING)
    =================================================================
    -->
    <div class="ranking-container">
        
        <!-- 
        =================================================================
          [LEFT SECTION] 명예의 전당 헤더 & TOP 3 & 내 랭킹
        =================================================================
        -->
        <div class="left-section">
            <a href="/" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Home</a>

            <div class="rank-header">
                <div class="d-flex align-items-center justify-content-center gap-2">
                    <i class="fa-solid fa-trophy" style="color:var(--primary-gold); font-size:1.6rem;"></i>
                    <h1 class="rank-title">HALL OF FAME</h1>
                </div>
                <p class="rank-subtitle text-center">명예의 전당 TOP 10</p>
            </div>

            <!-- TOP 3 리스트 (Podium Style) -->
            <div class="podium-container">
                <!-- 1위 -->
                <c:if test="${not empty rankingList && rankingList.size() >= 1}">
                    <div class="podium-item rank-1-podium">
                        <div class="rank-badge rank-1-badge">1</div>
                        <div class="podium-avatar">
                            <span class="crown">👑</span>
                            <!-- DiceBear Avatar API: 유저 ID 기반 랜덤 아바타 생성 -->
                            <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=${rankingList[0].userId}" width="100%" height="100%" style="border-radius:50%;" alt="avatar">
                        </div>
                        <div class="podium-info">
                            <div class="podium-name">${rankingList[0].userName}</div>
                            <div class="podium-id">@${rankingList[0].userId}</div>
                        </div>
                        <div class="podium-points"><fmt:formatNumber value="${rankingList[0].points}" pattern="#,###" /> P</div>
                    </div>
                </c:if>
                
                <!-- 2위 -->
                <c:if test="${not empty rankingList && rankingList.size() >= 2}">
                    <div class="podium-item">
                        <div class="rank-badge rank-2-badge">2</div>
                        <div class="podium-avatar">
                             <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=${rankingList[1].userId}" width="100%" height="100%" style="border-radius:50%;" alt="avatar">
                        </div>
                        <div class="podium-info">
                            <div class="podium-name">${rankingList[1].userName}</div>
                            <div class="podium-id">@${rankingList[1].userId}</div>
                        </div>
                        <div class="podium-points"><fmt:formatNumber value="${rankingList[1].points}" pattern="#,###" /> P</div>
                    </div>
                </c:if>

                <!-- 3위 -->
                <c:if test="${not empty rankingList && rankingList.size() >= 3}">
                    <div class="podium-item">
                        <div class="rank-badge rank-3-badge">3</div>
                        <div class="podium-avatar">
                             <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=${rankingList[2].userId}" width="100%" height="100%" style="border-radius:50%;" alt="avatar">
                        </div>
                        <div class="podium-info">
                            <div class="podium-name">${rankingList[2].userName}</div>
                            <div class="podium-id">@${rankingList[2].userId}</div>
                        </div>
                        <div class="podium-points"><fmt:formatNumber value="${rankingList[2].points}" pattern="#,###" /> P</div>
                    </div>
                </c:if>
            </div>

            <!-- 내 랭킹 정보 (로그인 시 표시) -->
            <c:if test="${not empty sessionScope.user}">
                <%-- 내 순위 계산 로직 --%>
                <c:set var="myRank" value="0" />
                <c:set var="myPoint" value="0" />
                <c:forEach items="${rankingList}" var="rank" varStatus="status">
                    <c:if test="${sessionScope.user.userId eq rank.userId}">
                        <c:set var="myRank" value="${status.index + 1}" />
                        <c:set var="myPoint" value="${rank.points}" />
                    </c:if>
                </c:forEach>

                <div class="my-rank-wrapper">
                    <div class="my-rank-box">
                        <div class="my-rank-label">MY RANK</div>
                        <div class="rank-badge" style="background:#fff; color:#000;">${myRank > 0 ? myRank : '-'}</div>
                        <div class="podium-avatar" style="border-color:var(--primary-gold);">
                            <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=${sessionScope.user.userId}" width="100%" height="100%" style="border-radius:50%;" alt="avatar">
                        </div>
                        <div class="podium-info">
                            <div class="podium-name">${sessionScope.user.userName}</div>
                            <div class="podium-id">@${sessionScope.user.userId}</div>
                        </div>
                        <div class="podium-points">
                            <fmt:formatNumber value="${myPoint > 0 ? myPoint : sessionScope.user.points}" pattern="#,###" /> P
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- 
        =================================================================
          [RIGHT SECTION] 전체 순위 리스트 테이블
        =================================================================
        -->
        <div class="right-section">
            <div class="rank-box">
                <div class="rank-table-wrapper">
                    <table class="rank-table">
                        <thead>
                            <tr>
                                <th width="12%" class="text-center">#</th>
                                <th width="63%">User</th>
                                <th width="25%" class="text-end">Points</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${rankingList}" var="rank" varStatus="status">
                                <!-- 내 랭킹 하이라이트 처리 -->
                                <tr class="${sessionScope.user.userId eq rank.userId ? 'my-rank-row rank-1-row' : (status.index == 0 ? 'rank-1-row' : '')}">
                                    <td class="text-center">
                                        <div class="rank-num ${status.index < 3 ? 'top-rank-num' : ''}">
                                            <!-- 1등은 왕관 아이콘 표시 -->
                                            <c:choose>
                                                <c:when test="${status.index == 0}"><i class="fa-solid fa-crown"></i></c:when>
                                                <c:otherwise>${status.index + 1}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="user-info">
                                            <div class="table-avatar">
                                                <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=${rank.userId}" width="100%" height="100%" style="border-radius:50%;" alt="avatar">
                                            </div>
                                            <div>
                                                <div style="font-weight:700; color:white;">
                                                    ${rank.userName}
                                                    <c:if test="${sessionScope.user.userId eq rank.userId}">
                                                        <span class="badge bg-warning text-dark ms-1" style="font-size:0.6rem;">ME</span>
                                                    </c:if>
                                                </div>
                                                <div style="font-size:0.75rem; color:var(--text-sub);">@${rank.userId}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-end">
                                        <div style="font-family:'Roboto Mono'; font-weight:700; color:var(--primary-gold); font-size:0.9rem;">
                                            <fmt:formatNumber value="${rank.points}" pattern="#,###" />
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- 
    =================================================================
      JAVASCRIPT ANIMATION
    =================================================================
    -->
    <script>
        const bg = document.getElementById('animatedBg');
        
        // [ANIMATION] 배경 파티클 생성 함수
        function createParticle() {
            const p = document.createElement('div');
            p.className = 'bg-particle';
            
            // 랜덤 크기 및 위치 설정
            const size = Math.random() * 80 + 20;
            p.style.width = size + 'px'; p.style.height = size + 'px';
            p.style.left = Math.random() * 100 + '%';
            
            // 랜덤 속도 설정
            p.style.animationDuration = (Math.random() * 10 + 15) + 's';
            
            bg.appendChild(p);
            
            // 일정 시간 후 제거 (메모리 관리)
            setTimeout(() => p.remove(), 25000);
        }
        
        // 3초마다 파티클 생성
        setInterval(createParticle, 3000);
    </script>
</body>
</html>