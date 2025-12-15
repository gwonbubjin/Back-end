<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%--
*******************************************************************************
* [points.jsp]
* 설명 : 마이페이지 - 포인트 관리 및 내역 조회 화면
* 주요 기능 :
* 1. 현재 보유 포인트 총액 조회 (상단 히어로 카드)
* 2. 포인트 변동 내역(History Log) 리스트 출력
* 3. 획득(+)과 차감(-)에 따른 조건부 스타일링 (초록색/빨간색)
*******************************************************************************
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>RateGo - My Points</title>
    
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

        /* [LAYOUT] */
        body { 
            background-color: var(--bg-body); 
            background-image: radial-gradient(circle at 0% 0%, #161b22 0%, #0d1117 60%); 
            color: var(--text-main); 
            font-family: 'Pretendard', sans-serif; 
            height: 100vh; margin: 0; overflow: hidden; display: flex; 
        }
        
        .dashboard-container { 
            display: flex; width: 100%; height: 100%; padding: 20px; gap: 20px; 
        }
        
        /* [SIDEBAR] 좌측 메뉴 (공통 스타일) */
        .sidebar { 
            width: 280px; background: var(--glass-bg); border: 1px solid var(--glass-border); 
            border-radius: 20px; display: flex; flex-direction: column; padding: 30px 20px; flex-shrink: 0; 
        }
        .home-btn { 
            text-decoration: none; color: var(--primary-gold); font-weight: 800; font-size: 1.2rem; 
            margin-bottom: 40px; display: flex; align-items: center; gap: 10px; 
        }
        .profile-section { text-align: center; margin-bottom: 40px; }
        .profile-img { 
            width: 100px; height: 100px; border-radius: 50%; background: #161b22; 
            border: 2px solid var(--primary-gold); display: flex; align-items: center; justify-content: center; 
            font-size: 3rem; color: var(--primary-gold); margin: 0 auto 15px; 
            box-shadow: 0 0 15px rgba(252, 213, 53, 0.2); 
        }
        .user-name { font-size: 1.4rem; font-weight: 700; color: white; }
        .user-id { 
            color: var(--primary-gold); font-size: 1rem; font-weight: 700; letter-spacing: 1px; 
            text-shadow: 0 0 10px rgba(252, 213, 53, 0.3); margin-top: 5px; 
        }
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
            flex: 1; display: flex; flex-direction: column; gap: 20px; 
            height: 100%; overflow: hidden; 
        }
        
        /* [HERO CARD] 총 보유 포인트 강조 카드 */
        .point-hero-card {
            background: linear-gradient(135deg, rgba(252, 213, 53, 0.15), rgba(0,0,0,0));
            border: 1px solid var(--primary-gold); border-radius: 20px;
            padding: 30px; display: flex; align-items: center; justify-content: space-between;
            box-shadow: 0 0 20px rgba(252, 213, 53, 0.1);
            flex-shrink: 0;
        }
        .point-display h2 { 
            font-size: 2.5rem; font-weight: 800; color: var(--primary-gold); margin: 0; 
            font-family: 'Roboto Mono'; text-shadow: 0 0 10px rgba(252, 213, 53, 0.4); 
        }
        .point-display p { margin: 0; color: var(--text-sub); font-size: 1rem; }
        .point-icon { font-size: 3rem; color: var(--primary-gold); opacity: 0.8; }

        /* [HISTORY LIST] 내역 리스트 테이블 */
        .history-section { 
            flex: 1; background: var(--glass-bg); border: 1px solid var(--glass-border); 
            border-radius: 20px; display: flex; flex-direction: column; overflow: hidden; padding: 25px; 
        }
        .section-title { font-size: 1.3rem; font-weight: 700; color: white; margin-bottom: 20px; }

        .table-wrapper { flex: 1; overflow-y: auto; }
        .custom-table { width: 100%; border-collapse: collapse; }
        
        /* Sticky Header */
        .custom-table th { 
            text-align: left; color: var(--text-sub); font-size: 0.8rem; padding: 15px 20px; 
            font-weight: 600; text-transform: uppercase; position: sticky; top: 0; 
            background: #0d1117; z-index: 1; border-bottom: 1px solid var(--glass-border); 
        }
        .custom-table td { 
            padding: 16px 20px; border-bottom: 1px solid rgba(255,255,255,0.03); 
            vertical-align: middle; color: var(--text-main); font-size: 0.95rem; 
        }
        .custom-table tr:hover { background: var(--table-hover); }
        
        /* [AMOUNT COLORS] 금액 색상 구분 */
        .amount-plus { color: #0ecb81; font-weight: 700; font-family: 'Roboto Mono'; } /* 초록색 */
        .amount-minus { color: #f6465d; font-weight: 700; font-family: 'Roboto Mono'; } /* 빨간색 */
        .text-date { font-family: 'Roboto Mono'; font-size: 0.85rem; color: var(--text-sub); }
    </style>
</head>
<body>

    <div class="dashboard-container">
        
        <!-- 
        =================================================================
          [LEFT SIDEBAR] 네비게이션 메뉴
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
                <a href="/mypage/activity.do"><i class="fa-solid fa-clock-rotate-left"></i> 전체 활동</a>
                <!-- 현재 페이지 활성화 -->
                <a href="/mypage/points.do" class="active"><i class="fa-solid fa-wallet"></i> 포인트 관리</a> 
                <a href="/logout.do" class="menu-logout"><i class="fa-solid fa-right-from-bracket"></i> 로그아웃</a>
            </div>
        </div>

        <!-- 
        =================================================================
          [MAIN CONTENT] 포인트 대시보드
        =================================================================
        -->
        <div class="main-content">
            
            <!-- 1. 총 포인트 요약 카드 -->
            <div class="point-hero-card">
                <div class="point-display">
                    <p>TOTAL POINTS</p>
                    <!-- 숫자 포맷팅 (예: 1,234 P) -->
                    <h2><fmt:formatNumber value="${sessionScope.user.points}" pattern="#,###" /> P</h2>
                </div>
                <div class="point-icon"><i class="fa-solid fa-coins"></i></div>
            </div>

            <!-- 2. 포인트 상세 내역 리스트 -->
            <div class="history-section">
                <div class="section-title">History Log</div>
                
                <div class="table-wrapper">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th width="50%">Description</th>
                                <th width="25%" class="text-end">Amount</th>
                                <th width="25%" class="text-center">Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- 포인트 내역 반복 출력 -->
                            <c:forEach items="${pointList}" var="log">
                                <tr>
                                    <!-- 변동 사유 (예: 게시글 작성, 좋아요 등) -->
                                    <td>
                                        <div class="fw-bold text-white">${log.reason}</div>
                                    </td>
                                    
                                    <!-- 변동 액수 (조건부 스타일링) -->
                                    <td class="text-end">
                                        <c:choose>
                                            <c:when test="${log.amount > 0}">
                                                <!-- 양수일 때: 초록색 + 기호 -->
                                                <span class="amount-plus">+ <fmt:formatNumber value="${log.amount}" pattern="#,###"/></span>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- 음수일 때: 빨간색 (기호는 숫자에 포함됨) -->
                                                <span class="amount-minus"><fmt:formatNumber value="${log.amount}" pattern="#,###"/></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <!-- 날짜 -->
                                    <td class="text-center text-date">
                                        <fmt:formatDate value="${log.regdate}" pattern="yyyy-MM-dd HH:mm"/>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <!-- 데이터가 없을 경우 (Empty State) -->
                            <c:if test="${empty pointList}">
                                <tr>
                                    <td colspan="3" class="text-center py-5" style="color: #8b949e;">
                                        <i class="fa-solid fa-receipt fa-3x mb-3"></i><br>
                                        포인트 내역이 없습니다.
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