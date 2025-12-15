<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page isELIgnored="false" %>

<html>
<head>
    <title>RateGo - Travelers Community</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">

    <style>
        :root {
            --primary-gold: #FCD535;
            --primary-dark: #1E2329;
            --text-gray: #848e9c;
            --glass-bg: rgba(30, 35, 41, 0.75);
            --glass-border: rgba(255, 255, 255, 0.08);
            --neon-shadow: 0 0 10px rgba(252, 213, 53, 0.3);
        }

        body {
            height: 100vh;
            margin: 0;
            overflow: hidden;
            background: radial-gradient(circle at 50% -20%, #2b3139, #0b0e11 90%);
            color: #eaecef;
            font-family: 'Pretendard', sans-serif;
            display: flex;
            flex-direction: column;
        }

        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #474d57; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--primary-gold); }

        .text-gold { color: var(--primary-gold) !important; }
        .cursor-pointer { cursor: pointer; }
        .hover-white:hover { color: #ffffff !important; }

        /* 상단 네비 */
        .navbar {
            background: rgba(11, 14, 17, 0.9);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--glass-border);
            padding: 13px 0;
        }
        .brand-logo {
            color: var(--primary-gold);
            font-weight: 900;
            font-size: 1.6rem;
            letter-spacing: -1px;
            text-decoration: none;
        }

        .main-container {
            flex: 1;
            padding: 12px 0 10px 0;
            overflow: hidden;
        }
        .h-100-scroll {
            height: 100%;
            overflow-y: auto;
            padding-right: 5px;
        }

        /* 공통 카드 */
        .glass-box {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.5);
            overflow: hidden;
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .box-header {
            padding: 16px 20px;
            border-bottom: 1px solid var(--glass-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .box-title {
            font-weight: 700;
            font-size: 1.05rem;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* 게시판 */
        .hot-post-card {
            background: linear-gradient(145deg, rgba(255,255,255,0.05) 0%, rgba(0,0,0,0.2) 100%);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .hot-post-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary-gold);
            box-shadow: var(--neon-shadow);
        }
        .hot-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 0.7rem;
            background: rgba(246, 70, 93, 0.2);
            color: #f6465d;
            padding: 2px 8px;
            border-radius: 4px;
            border: 1px solid rgba(246, 70, 93, 0.3);
        }

        .board-list { display: flex; flex-direction: column; }
        .board-row {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.03);
            transition: background 0.2s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }
        .board-row:hover { background: rgba(255,255,255,0.05); }
        .board-cat {
            font-size: 0.75rem;
            padding: 3px 8px;
            border-radius: 4px;
            margin-right: 15px;
            font-weight: 600;
            width: 60px;
            text-align: center;
        }
        .cat-info { background: rgba(14, 203, 129, 0.15); color: #0ecb81; }
        .cat-talk { background: rgba(252, 213, 53, 0.15); color: #FCD535; }
        .board-title {
            flex: 1;
            font-weight: 500;
            font-size: 0.95rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .board-meta {
            font-size: 0.8rem;
            color: var(--text-gray);
            display: flex;
            gap: 15px;
            min-width: 150px;
            justify-content: flex-end;
        }

        /* 로그인 바 */
        .login-bar {
            background: rgba(252, 213, 53, 0.05);
            border: 1px solid rgba(252, 213, 53, 0.2);
            border-radius: 12px;
            padding: 15px 20px;
        }

        .input-dark, .input-dark option {
            background: #0b0e11 !important;
            border: 1px solid #474d57;
            color: white !important;
            border-radius: 6px;
            font-size: 0.9rem;
        }
        .input-dark::placeholder { color: #b7bdc6; opacity: 1; }
        .input-dark:focus {
            border-color: var(--primary-gold);
            outline: none;
            box-shadow: 0 0 5px rgba(252, 213, 53, 0.3);
        }

        .btn-gold {
            background: var(--primary-gold);
            color: black;
            font-weight: 800;
            border: none;
            padding: 8px 20px;
            border-radius: 6px;
            transition: all 0.2s;
        }
        .btn-gold:hover { background: #f0b90b; transform: scale(1.02); }

        /* 우측 사이드바 */
        .rate-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.1);
        }
        .rate-val {
            font-family: 'Roboto Mono', monospace;
            font-weight: 700;
            color: #fff;
        }
        .rate-unit {
            font-size: 0.75rem;
            margin-left: 4px;
            color: #b7bdc6;
            opacity: 0.8;
        }
        .text-up { color: #0ecb81; }
        .text-down { color: #f6465d; }

        .ticker-container {
            overflow: hidden;
            white-space: nowrap;
            width: 100%;
            margin-top: 5px;
        }
        .ticker-content {
            display: inline-block;
            animation: marquee 20s linear infinite;
            padding-left: 100%;
        }
        @keyframes marquee {
            0%   { transform: translateX(0%); }
            100% { transform: translateX(-150%); }
        }
        .ticker-item {
            display: inline-block;
            margin-right: 40px;
            font-size: 0.85rem;
            font-weight: 600;
            color: #fff;
        }
        .ticker-highlight {
            color: var(--primary-gold);
            font-weight: 800;
        }

        /* ───── World Time Footer (매우 작고 한 줄 고정) ───── */
        .world-clock-strip {
            background: rgba(0, 0, 0, 0.85);
            border-top: 1px solid var(--glass-border);
            padding: 4px 0;
            font-size: 0.7rem;
        }
        .world-clock-strip .container {
            display: flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
            overflow: hidden;
        }
        #world-clock-ticker {
            display: flex;
            flex-wrap: nowrap;
            flex-grow: 1;
            gap: 4px;
            min-width: 0;
            overflow: hidden;
        }
        .world-clock-item {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 2px 10px;
            border-radius: 999px;
            background: rgba(255,255,255,0.06);
            color: #f1f5f9;
            flex: 0 0 auto;
            white-space: nowrap;
        }
        .world-clock-time {
            font-family: 'Roboto Mono', monospace;
            font-weight: 700;
            color: var(--primary-gold);
        }
        .world-clock-title {
            white-space: nowrap;
        }
        .world-clock-strip * {
            color: rgba(255, 255, 255, 0.6) !important;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <a href="/" class="brand-logo"><i class="fa-solid fa-earth-asia"></i> RateGo</a>
            </div>
            
            <div class="d-flex align-items-center gap-4 text-secondary small fw-bold">
                <span><i class="fa-regular fa-clock me-1"></i> Current Time <span id="clock" class="text-white ms-1">00:00:00</span></span>
                
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span class="text-gold"><i class="fa-solid fa-user me-1"></i> ${sessionScope.user.userName}님</span>
                    </c:when>
                    <c:otherwise>
                        <span class="text-secondary"><i class="fa-solid fa-user-slash me-1"></i> Guest (비로그인)</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <div class="container main-container">
        <div class="row h-100 g-4">
            
            <div class="col-lg-9 d-flex flex-column h-100">
                
                <c:set var="isLoginSuccessRedirect" value="${param.msg eq 'loginSuccess'}" />
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div id="userDashboard" 
                             class="login-bar d-flex align-items-center justify-content-between mb-4 flex-shrink-0 
                             ${isLoginSuccessRedirect ? 'd-none' : ''}" 
                             style="background: var(--glass-bg); border: 1px solid var(--glass-border); padding: 20px 25px;">
                            
                            <div class="d-flex align-items-center gap-3">
                                <div class="rounded-circle bg-success d-flex align-items-center justify-content-center shadow-sm" style="width:45px; height:45px; color:black;">
                                    <i class="fa-solid fa-user fa-lg"></i>
                                </div>
                                
                                <div style="line-height: 1.3;">
                                    <span class="fw-bold text-white" style="font-size: 1.2rem;">${sessionScope.user.userName}님</span>
                                    
                                    <div class="text-secondary" style="font-size: 0.85rem;">
                                        포인트: <span class="text-warning fw-bold"><fmt:formatNumber value="${sessionScope.user.points}" pattern="#,###" /> P</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-flex gap-3 align-items-center">
                            <a href="ranking.do" class="btn btn-outline-warning btn-sm d-flex align-items-center justify-content-center" 
        style="font-size: 0.8rem; height: 38px; min-width: 110px; color: #FCD535; border-color: #FCD535;">
         <i class="fa-solid fa-trophy me-1"></i> 포인트 랭킹
     </a>
                                 <a href="mypage.do" class="btn btn-outline-light btn-sm d-flex align-items-center justify-content-center" 
                                    style="border-color: #474d57; font-size: 0.8rem; height: 38px; min-width: 110px;">
                                     <i class="fa-solid fa-user-gear me-1"></i> 마이페이지
                                 </a>
                                 <a href="logout.do" class="btn btn-danger btn-sm d-flex align-items-center justify-content-center" 
                                    style="font-size: 0.8rem; height: 38px; min-width: 100px;">
                                     <i class="fa-solid fa-right-from-bracket me-1"></i> 로그아웃
                                 </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="login-bar d-flex align-items-center justify-content-between mb-4 flex-shrink-0" style="padding: 20px 25px;">
                            <div class="d-flex align-items-center gap-3">
                                <div class="rounded-circle bg-warning d-flex align-items-center justify-content-center shadow-sm" style="width:45px; height:45px; color:black;">
                                    <i class="fa-solid fa-passport fa-lg"></i>
                                </div>
                                <div style="line-height: 1.3;">
                                    <div class="d-flex align-items-end gap-2">
                                        <span class="fw-bold text-white" style="font-size: 1.2rem;">Traveler Login</span>
                                        <a href="signupPage.do" class="text-decoration-none text-gold small fw-bold mb-1" style="font-size: 0.75rem;">
                                            회원가입 <i class="fa-solid fa-chevron-right" style="font-size: 0.6rem;"></i>
                                        </a>
                                    </div>
                                    <div class="text-secondary" style="font-size: 0.85rem;">나만의 환율 알림을 받아보세요</div>
                                </div>
                            </div>

                            <form class="d-flex gap-2 align-items-center" action="login.do" method="post">
                                <div class="position-relative">
                                    <i class="fa-regular fa-envelope position-absolute text-secondary" 
                                       style="left: 12px; top: 50%; transform: translateY(-50%); font-size: 0.9rem; z-index: 5;"></i>
                                    <input type="text" name="userId" class="form-control input-dark" placeholder="ID" 
                                           style="width: 160px; padding-left: 38px; height: 38px; background: #0b0e11;">
                                </div>
                                <div class="position-relative">
                                    <i class="fa-solid fa-lock position-absolute text-secondary" 
                                       style="left: 12px; top: 50%; transform: translateY(-50%); font-size: 0.9rem; z-index: 5;"></i>
                                    <input type="password" name="userPw" class="form-control input-dark" placeholder="PW" 
                                           style="width: 160px; padding-left: 38px; height: 38px; background: #0b0e11;">
                                </div>
                                <button class="btn btn-gold fw-bold shadow-sm" style="height: 38px; padding: 0 18px;">
                                    <i class="fa-solid fa-right-to-bracket"></i>
                                </button>
                            </form>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="glass-box flex-grow-1 d-flex flex-column">
                    <div class="box-header bg-transparent">
                        <div class="box-title">
                            <i class="fa-solid fa-comments text-gold"></i>
                            <span>여행자 커뮤니티 게시판</span>
                        </div>
                        <button onclick="checkAccess(event, 'board/register.do')" class="btn btn-outline-light btn-sm" style="border-color: #474d57; font-size: 0.8rem;">
                            <i class="fa-solid fa-pen"></i> 글쓰기
                        </button>
                    </div>

                    <div class="p-4 h-100-scroll flex-grow-1">
                        <div class="row g-3 mb-4">
                            <c:forEach items="${hotList}" var="hot">
    <div class="col-md-6">
        <div class="hot-post-card" onclick="checkAccess(event, 'board/get.do?bno=${hot.bno}')">
            <div class="hot-badge">HOT</div>
            <h6 class="fw-bold text-white mb-2 text-truncate">${hot.title}</h6>
            
            <p class="text-secondary small mb-0 text-truncate" style="opacity:0.8;">
                ${hot.content.replaceAll("<[^>]*>", "").trim()}
            </p>
            
            <div class="mt-2 text-secondary" style="font-size:0.7rem;">
                <i class="fa-regular fa-eye me-1"></i> ${hot.viewcnt}
                <span class="ms-2"><i class="fa-regular fa-thumbs-up me-1"></i> ${hot.likecnt}</span>
            </div>
        </div>
    </div>
</c:forEach>

<c:if test="${empty hotList}">
    <div class="col-12 text-center text-secondary small py-3">아직 인기글이 없습니다.</div>
</c:if>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-2 px-2">
                            <span class="text-secondary small fw-bold">최신 글</span>
                            <a href="#" onclick="checkAccess(event, 'board/list.do')" class="text-secondary small text-decoration-none hover-white cursor-pointer">
                                더보기 <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </div>

                        <div class="board-list">
                            <c:forEach items="${recentList}" var="recent">
    <a href="#" onclick="checkAccess(event, 'board/get.do?bno=${recent.bno}')" class="board-row">
        
        <span class="board-cat" style="
            <c:if test="${recent.category eq '정보'}">color:#0ecb81; background:rgba(14,203,129,0.15);</c:if>
            <c:if test="${recent.category eq '질문'}">color:#3b82f6; background:rgba(59,130,246,0.15);</c:if>
            <c:if test="${recent.category eq '후기'}">color:#f6465d; background:rgba(246,70,93,0.15);</c:if>
            <c:if test="${recent.category eq '잡담'}">color:#FCD535; background:rgba(252,213,53,0.15);</c:if>
        ">
            ${empty recent.category ? '기타' : recent.category}
        </span>

        <span class="board-title text-white">
            ${recent.title}
        </span>
        
        <span class="board-meta">
            <span><i class="fa-regular fa-user"></i> ${recent.writer}</span>
            <span><i class="fa-regular fa-clock"></i> <fmt:formatDate value="${recent.regdate}" pattern="MM-dd"/></span>
        </span>
    </a>
</c:forEach>

<c:if test="${empty recentList}">
    <div class="text-center text-secondary small py-4">등록된 게시글이 없습니다.</div>
</c:if>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 d-flex flex-column h-100">
                
                <div class="glass-box flex-shrink-0 p-3 mb-2">
                    <div class="fw-bold mb-2 small text-gold"><i class="fa-solid fa-bolt me-1"></i> 실시간 트래커</div>
                    <div class="ticker-container">
                        <div class="ticker-content">
                            <span class="ticker-item">🇯🇵 엔화 <span class="ticker-highlight">912.40</span></span>
                            <span class="ticker-item">🇺🇸 달러 <span class="ticker-highlight">1,395.50</span></span>
                            <span class="ticker-item">🇻🇳 다낭 환전 꿀팁 <i class="fa-solid fa-arrow-up text-up"></i></span>
                            <span class="ticker-item">📊 NASDAQ 3일 연속 상승 <span class="ticker-highlight text-up">▲ 1.2%</span></span>
                            <span class="ticker-item">🇪🇺 유럽 증시 혼조세 <span class="ticker-highlight text-down">▼ 0.5%</span></span>
                            <span class="ticker-item">KRW <span class="ticker-highlight">1,480.10</span> EUR</span>
                            <span class="ticker-item">🇯🇵 엔화 <span class="ticker-highlight">912.40</span></span>
                            <span class="ticker-item">🇺🇸 달러 <span class="ticker-highlight">1,395.50</span></span>
                            <span class="ticker-item">🇻🇳 다낭 환전 꿀팁 <i class="fa-solid fa-arrow-up text-up"></i></span>
                            <span class="ticker-item">📊 NASDAQ 3일 연속 상승 <span class="ticker-highlight text-up">▲ 1.2%</span></span>
                        </div>
                    </div>
                </div>

                <div class="glass-box flex-grow-1 d-flex flex-column mb-3" style="min-height: 0;">
                    <div class="box-header bg-transparent py-3">
                        <span class="box-title text-gold" style="font-size: 1rem;"><i class="fa-solid fa-money-bill-trend-up"></i> Live Rates</span>
                        <span class="badge bg-danger bg-opacity-25 text-danger border border-danger">LIVE</span>
                    </div>
                    <div class="p-3 h-100-scroll">
                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/US/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">USD</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    1,395.50 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-up">▲ 3.20</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/JP/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">JPY(100)</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    912.40 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-down">▼ 1.10</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/DE/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">EUR</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    1,480.10 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-up">▲ 2.50</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/CN/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">CNY</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    193.20 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-up">▲ 0.40</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/GB/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">GBP</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    1,780.30 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-down">▼ 4.10</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/CH/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">CHF</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    1,570.80 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-up">▲ 1.60</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/CA/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">CAD</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    1,030.50 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-down">▼ 0.80</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/AU/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">AUD</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    930.40 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-up">▲ 1.10</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/SG/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">SGD</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    1,040.30 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-up">▲ 0.90</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/HK/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">HKD</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    178.20 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-down">▼ 0.10</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/TH/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">THB</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    39.80 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-up">▲ 0.05</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/VN/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">VND(100)</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    5.60 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-up">▲ 0.02</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/MX/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">MXN</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    82.40 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-down">▼ 0.15</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/RU/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">RUB</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    15.30 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-down">▼ 0.05</span>
                                </div>
                            </div>
                        </div>

                        <div class="rate-row">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://flagsapi.com/SA/flat/32.png" style="width:20px;">
                                <span class="fw-bold text-white small">SAR</span>
                            </div>
                            <div class="text-end">
                                <div class="rate-val">
                                    372.20 <span class="rate-unit">KRW</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.7rem;">
                                    전일대비 <span class="text-up">▲ 0.80</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="glass-box flex-shrink-0" style="height: 250px;">
                    <ul class="nav nav-tabs nav-justified border-bottom-0" style="background: rgba(0,0,0,0.2);" id="weatherTabs">
                        <li class="nav-item">
                            <a class="nav-link active text-white small py-2 bg-transparent border-0 fw-bold" data-bs-toggle="tab" href="#tab-weather">
                                <i class="fa-solid fa-cloud-sun text-gold"></i> 현지 날씨
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-secondary small py-2 bg-transparent border-0 fw-bold" data-bs-toggle="tab" href="#tab-calc">
                                <i class="fa-solid fa-calculator"></i> 계산기
                            </a>
                        </li>
                    </ul>
                    <div class="tab-content p-3 h-100 position-relative">
                        <div class="tab-pane fade show active h-100" id="tab-weather">
                            <div class="d-flex justify-content-between mb-3">
                                <select id="countrySelect" class="form-select form-select-sm input-dark" style="width: 48%;" onchange="changeCountry()">
                                </select>
                                <select id="citySelect" class="form-select form-select-sm input-dark" style="width: 48%;" onchange="getWeather()">
                                </select>
                            </div>
                            <div class="text-center mt-2">
                                <h1 class="display-4 fw-bold text-white m-0" id="weather-temp">18°</h1>
                                <p class="text-secondary small" id="weather-desc">맑음, 습도 40%</p>
                            </div>
                        </div>

                        <div class="tab-pane fade h-100" id="tab-calc">
                            <div class="mt-2">
                                <div class="input-group mb-2">
                                    <span class="input-group-text bg-dark border-secondary text-secondary small">USD</span>
                                    <input type="number" id="calc-usd" class="form-control input-dark text-end fw-bold" value="100">
                                </div>
                                <div class="text-center text-gold my-1"><i class="fa-solid fa-arrow-down"></i></div>
                                <div class="input-group">
                                    <span class="input-group-text bg-dark border-secondary text-secondary small">KRW</span>
                                    <input type="text" id="calc-krw" class="form-control input-dark text-end fw-bold" value="139,550" readonly>
                                </div>
                                <button class="btn btn-gold w-100 btn-sm mt-3" onclick="runCalculator()">환율 적용 계산</button>
                            </div>
                        </div>
                    </div>
                </div>

            </div> 
        </div>
    </div>

    <div class="world-clock-strip">
        <div class="container">
            <span class="text-gold fw-bold world-clock-title">
                <i class="fa-solid fa-globe me-1"></i> World Time
            </span>
            <div id="world-clock-ticker"></div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
    // ★★★ 핵심 추가: 로그인 상태 체크 후 이동 함수 ★★★
    function checkAccess(event, url) {
        event.preventDefault(); // 일단 이동을 막습니다.

        // JSP 세션에 user가 있는지 확인 (true/false로 변환됨)
        const isLogin = ${not empty sessionScope.user};

        if(isLogin) {
            // 로그인 상태면 해당 주소로 이동
            location.href = url;
        } else {
            // 비로그인 상태면 경고창 표시
            Swal.fire({
                icon: 'warning',
                title: '로그인이 필요합니다',
                text: '게시글을 작성하거나 보려면 로그인이 필요합니다.',
                background: '#1E2329',
                color: '#ffffff',
                confirmButtonColor: '#FCD535',
                confirmButtonText: '<b style="color:black">확인</b>',
                backdrop: 'rgba(0, 0, 0, 0.85)'
            });
        }
    }

    // ===== 기존 시계/날씨/계산기 코드 유지 =====
    const WORLD_ZONES = [
        { city: "뉴욕 (NY)",   offset: -4, symbol: "🇺🇸" },
        { city: "런던 (GMT)",  offset:  1, symbol: "🇬🇧" },
        { city: "두바이 (DXB)", offset: 4, symbol: "🇦🇪" },
        { city: "싱가포르 (SIN)", offset: 8, symbol: "🇸🇬" },
        { city: "베이징 (PEK)",   offset: 8, symbol: "🇨🇳" },
        { city: "도쿄 (TYO)",  offset:  9, symbol: "🇯🇵" },
        { city: "시드니 (SYD)", offset: 11, symbol: "🇦🇺" }
    ];

    function updateWorldClocks() {
        const now = new Date();
        const utc = now.getTime() + (now.getTimezoneOffset() * 60000); 

        const ticker = document.getElementById('world-clock-ticker');
        if (!ticker) return;

        let html = '';
        WORLD_ZONES.forEach(function(zone) {
            const cityTime = new Date(utc + (3600000 * zone.offset)); 
            const timeString = cityTime.toLocaleTimeString('en-US', {
                hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true
            });

            html += '<div class="world-clock-item">';
            html +=   '<span>' + zone.symbol + '</span>';
            html +=   '<span>' + zone.city + '</span>';
            html +=   '<span class="world-clock-time">' + timeString + '</span>';
            html += '</div>';
        });

        ticker.innerHTML = html;
    }

    function updateMainClock() {
        const now = new Date();
        const clockEl = document.getElementById('clock');
        if (clockEl) {
            clockEl.innerText = now.toLocaleTimeString('ko-KR');
        }
    }

    function updateAllClocks() {
        updateMainClock();
        updateWorldClocks();
    }

    // ===== Weather & Calculator =====
    const cityMap = {
        "JP": ["Osaka", "Tokyo", "Fukuoka", "Sapporo", "Okinawa"],
        "VN": ["Da Nang", "Hanoi", "Ho Chi Minh", "Nha Trang"],
        "US": ["New York", "LA", "Chicago", "Hawaii", "Seattle"],
        "EU": ["Paris", "London", "Rome", "Berlin", "Prague", "Amsterdam", "Vienna"],
        "TH": ["Bangkok", "Phuket", "Chiang Mai", "Pattaya"],
        "TW": ["Taipei", "Kaohsiung", "Taichung"],
        "CN": ["Beijing", "Shanghai", "Qingdao", "Guangzhou"],
        "MX": ["Mexico City", "Cancun"], 
        "BR": ["Rio de Janeiro", "Sao Paulo"],
        "RU": ["Moscow", "St. Petersburg"],
        "AE": ["Dubai", "Abu Dhabi"]
    };
    const countryNames = {
        "JP": "일본", "VN": "베트남", "US": "미국", 
        "EU": "유럽", "TH": "태국", "TW": "대만", "CN": "중국",
        "MX": "멕시코", "BR": "브라질", "RU": "러시아", "AE": "UAE"
    };

    // 도시별 현실감 있는 기본 온도/습도
    const BASE_WEATHER = {
        "Osaka":        { temp: 18, humidity: 60 },
        "Tokyo":        { temp: 19, humidity: 58 },
        "Fukuoka":      { temp: 18, humidity: 65 },
        "Sapporo":      { temp: 10, humidity: 55 },
        "Okinawa":      { temp: 24, humidity: 70 },

        "Da Nang":      { temp: 27, humidity: 75 },
        "Hanoi":        { temp: 24, humidity: 72 },
        "Ho Chi Minh":  { temp: 28, humidity: 78 },
        "Nha Trang":    { temp: 27, humidity: 73 },

        "New York":     { temp: 12, humidity: 55 },
        "LA":           { temp: 20, humidity: 45 },
        "Chicago":      { temp: 10, humidity: 50 },
        "Hawaii":       { temp: 26, humidity: 70 },
        "Seattle":      { temp: 13, humidity: 65 },

        "Paris":        { temp: 15, humidity: 60 },
        "London":       { temp: 13, humidity: 65 },
        "Rome":         { temp: 18, humidity: 55 },
        "Berlin":       { temp: 12, humidity: 60 },
        "Prague":       { temp: 11, humidity: 62 },
        "Amsterdam":    { temp: 12, humidity: 70 },
        "Vienna":       { temp: 14, humidity: 58 },

        "Bangkok":      { temp: 30, humidity: 75 },
        "Phuket":       { temp: 30, humidity: 78 },
        "Chiang Mai":   { temp: 27, humidity: 70 },
        "Pattaya":      { temp: 29, humidity: 76 },

        "Taipei":       { temp: 22, humidity: 70 },
        "Kaohsiung":    { temp: 24, humidity: 72 },
        "Taichung":     { temp: 21, humidity: 68 },

        "Beijing":      { temp: 14, humidity: 40 },
        "Shanghai":     { temp: 17, humidity: 60 },
        "Qingdao":      { temp: 13, humidity: 55 },
        "Guangzhou":    { temp: 24, humidity: 70 },

        "Mexico City":  { temp: 20, humidity: 50 },
        "Cancun":       { temp: 28, humidity: 75 },

        "Rio de Janeiro": { temp: 26, humidity: 75 },
        "Sao Paulo":      { temp: 22, humidity: 70 },

        "Moscow":       { temp: 5,  humidity: 60 },
        "St. Petersburg": { temp: 4, humidity: 65 },

        "Dubai":        { temp: 30, humidity: 35 },
        "Abu Dhabi":    { temp: 31, humidity: 40 }
    };

    function initWeather() {
        const countrySelect = document.getElementById("countrySelect");
        if (!countrySelect) return;

        countrySelect.innerHTML = "";
        Object.keys(cityMap).forEach(code => {
            countrySelect.add(new Option(countryNames[code], code));
        });
        changeCountry();
    }

    function changeCountry() {
        const countrySelect = document.getElementById("countrySelect");
        const citySelect    = document.getElementById("citySelect");
        if (!countrySelect || !citySelect) return;

        const country = countrySelect.value;
        citySelect.innerHTML = "";
        if (cityMap[country]) {
            cityMap[country].forEach(c => citySelect.add(new Option(c, c)));
        }
        getWeather();
    }

    function getWeather() {
        const citySelect = document.getElementById("citySelect");
        if (!citySelect) return;

        const city = citySelect.value;
        const base = BASE_WEATHER[city] || { temp: 20, humidity: 55 };

        // 기본값 기준으로 ±2~3도, 습도 ±5% 정도 랜덤
        const temp = base.temp + (Math.floor(Math.random() * 5) - 2);  // -2 ~ +2
        let humidity = base.humidity + (Math.floor(Math.random() * 11) - 5); // -5 ~ +5
        humidity = Math.max(30, Math.min(90, humidity));

        const wind = (Math.random() * 5 + 1).toFixed(1); // 1.0 ~ 6.0 m/s

        const descs = ["맑음", "구름 조금", "구름 많음", "약한 비", "약한 안개"];
        const desc = descs[Math.floor(Math.random() * descs.length)];

        const visibilityOpts = ["매우 좋음", "좋음", "보통", "나쁨"];
        const visibility = visibilityOpts[Math.floor(Math.random() * visibilityOpts.length)];
        
        const tempEl = document.getElementById("weather-temp");
        const descEl = document.getElementById("weather-desc");
        if (tempEl) tempEl.innerText = temp + "°";
        if (descEl) {
            descEl.innerHTML =
                desc + ', 습도 ' + humidity + '% <br>' +
                '<i class="fa-solid fa-wind me-1"></i> ' + wind + ' m/s | ' +
                '<i class="fa-solid fa-eye me-1"></i> ' + visibility;
        }
    }

    function runCalculator() {
        const usdInput = document.getElementById('calc-usd');
        const krwOutput = document.getElementById('calc-krw');
        if (!usdInput || !krwOutput) return;

        const usdValue = parseFloat(usdInput.value || "0");
        const rate = 1395.5; // 위에서 사용한 USD 기준
        const result = usdValue * rate;
        krwOutput.value = Math.floor(result).toLocaleString('ko-KR');
    }

    // ===== SweetAlert 공통 =====
    const fireSwal = (icon, title, text, confirmColor) => {
        return Swal.fire({ 
            icon: icon,
            title: title,
            text: text,
            background: '#1E2329',
            color: '#ffffff',
            confirmButtonColor: confirmColor,
            confirmButtonText: '<b style="color:black">확인</b>',
            backdrop: 'rgba(0, 0, 0, 0.85)'
        });
    };

    // ===== 초기화 =====
    document.addEventListener('DOMContentLoaded', function () {
        // 시계/월드타임
        updateAllClocks();
        setInterval(updateAllClocks, 1000);

        // 날씨
        initWeather();

        // SweetAlert 메시지 처리
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');

        if (!msg) return;

        if (msg === 'signupSuccess') {
            fireSwal('success', '회원가입 완료! 🎉', 'RateGo의 회원이 되신 것을 환영합니다.', '#FCD535')
            .then(() => {
                history.replaceState({}, document.title, window.location.pathname);
            });
        } 
        else if (msg === 'loginSuccess') {
            const userName = "${sessionScope.user.userName}";
            
            fireSwal('success', '로그인 성공!', userName + '님, 환영합니다!', '#0ecb81')
            .then(() => {
                const dash = document.getElementById('userDashboard');
                if (dash) dash.classList.remove('d-none');
                history.replaceState({}, document.title, window.location.pathname);
            });
        }
        else if (msg === 'loginFail') {
            fireSwal('error', '로그인 실패', '아이디 또는 비밀번호를 확인해주세요.', '#F6465D')
            .then(() => {
                history.replaceState({}, document.title, window.location.pathname);
            });
        }
    });
    </script>
</body>
</html>