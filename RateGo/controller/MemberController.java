package com.ratego.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.ratego.model.BoardVO;
import com.ratego.model.Criteria;
import com.ratego.model.MemberMapper;
import com.ratego.model.MemberVO;
import com.ratego.model.PageDTO;
import com.ratego.model.PointVO;
import com.ratego.service.BoardService;

/*******************************************************************************
 * [MemberController]
 * 설명 : 회원 관련 전반적인 기능(인증, 마이페이지, 포인트, 랭킹) 제어
 * 프로젝트 : RateGo Project
 *******************************************************************************/
@Controller
public class MemberController {

    /* =================================================================
     * DEPENDENCY INJECTION
     * ================================================================= */
    @Autowired
    private MemberMapper memberMapper; 

    @Autowired
    private BoardService boardService;

    /*******************************************************************************
     * 1. [MAIN & HOME] 메인 화면 진입
     * - home() : 세션 최신화 및 인기/최신 게시글 로드
     *******************************************************************************/
    
    // 1. 홈 화면 (세션 갱신 로직 포함)
    @RequestMapping(value = {"/", "/home.do"}, method = RequestMethod.GET)
    public String home(HttpServletRequest request, HttpSession session) {
        MemberVO user = (MemberVO) session.getAttribute("user");
        
        // 로그인 상태라면 DB에서 최신 정보 다시 긁어와서 세션 덮어쓰기 (포인트 등 변동사항 반영)
        if (user != null) {
            MemberVO freshUser = memberMapper.read(user.getUserId());
            if (freshUser != null) {
                session.setAttribute("user", freshUser);
            }
        }
        
        // 메인 화면에 뿌려줄 데이터 (인기글, 최신글)
        request.setAttribute("hotList", boardService.getHotList());
        request.setAttribute("recentList", boardService.getRecentList());
        
        return "home"; 
    }

    /*******************************************************************************
     * 2. [AUTHENTICATION] 인증 관련 (회원가입 / 로그인 / 로그아웃)
     *******************************************************************************/

    // 2-1. 회원가입 페이지 이동
    @RequestMapping(value = "/signupPage.do", method = RequestMethod.GET)
    public String viewSignupPage() { 
        return "signup"; 
    }

    // 2-2. 회원가입 처리
    @RequestMapping(value = "/join.do", method = RequestMethod.POST)
    public String joinMember(MemberVO vo) {
        memberMapper.join(vo); 
        return "redirect:/?msg=signupSuccess";
    }
    
    // 2-3. 로그인 처리
    @RequestMapping(value = "/login.do", method = RequestMethod.POST)
    public String loginMember(MemberVO vo, HttpSession session) {
        MemberVO loginMember = memberMapper.login(vo);
        
        if(loginMember != null) {
            session.setAttribute("user", loginMember);
            session.setMaxInactiveInterval(60 * 30); // 세션 유지 30분
            return "redirect:/?msg=loginSuccess";
        } else {
            return "redirect:/?msg=loginFail";
        }
    }
    
    // 2-4. 로그아웃 처리
    @RequestMapping(value = "/logout.do")
    public String logoutMember(HttpSession session) {
        session.invalidate(); // 세션 전체 날리기
        return "redirect:/";
    }
    
    /*******************************************************************************
     * 3. [MY PAGE - DASHBOARD] 마이페이지 메인 및 비밀번호 검증
     * - summary : 내 정보 요약
     * - checkPw : 정보 수정 전 비밀번호 재확인
     *******************************************************************************/

    // 3-1. 마이페이지 요약 (대시보드)
    @RequestMapping(value = "/mypage.do", method = RequestMethod.GET)
    public String myPageSummary(HttpSession session, HttpServletRequest request) {
        if (session.getAttribute("user") == null) return "redirect:/"; 

        // 정보 최신화
        MemberVO user = (MemberVO) session.getAttribute("user");
        String userId = user.getUserId();
        
        MemberVO freshUser = memberMapper.read(userId);
        session.setAttribute("user", freshUser);
        
        // 통계 데이터 가져오기 (작성글 수, 받은 좋아요 등)
        int postCount = memberMapper.countMyPosts(userId);
        int likesReceived = memberMapper.countLikesReceived(userId);
        List<BoardVO> myRecentList = memberMapper.getMyRecentPosts(userId);
        
        request.setAttribute("postCount", postCount);
        request.setAttribute("likesReceived", likesReceived);
        request.setAttribute("myRecentList", myRecentList);
        
        return "mypage/summary";
    }

    // 3-2. 비밀번호 확인 페이지 (수정 페이지 진입 전 단계)
    @RequestMapping(value = "/mypage/checkPw.do", method = RequestMethod.GET)
    public String checkPasswordPage(HttpSession session) {
        if (session.getAttribute("user") == null) return "redirect:/"; 
        return "mypage/check_pw";
    }
    
    // 3-3. 비밀번호 확인 처리 로직
    @RequestMapping(value = "/mypage/checkPw.do", method = RequestMethod.POST)
    public String processPasswordCheck(HttpSession session, String currentPw) {
        MemberVO user = (MemberVO) session.getAttribute("user");
        if (user == null) return "redirect:/";

        // DB 비밀번호와 일치하면 수정 페이지로 이동
        if (memberMapper.checkPassword(user.getUserId(), currentPw)) {
            return "redirect:/mypage/edit.do";
        } else {
            return "redirect:/mypage/checkPw.do?error=fail";
        }
    }
    
    /*******************************************************************************
     * 4. [MY PAGE - EDIT] 회원 정보 수정
     * - edit.do (GET/POST)
     *******************************************************************************/

    // 4-1. 정보 수정 폼으로 이동
    @RequestMapping(value = "/mypage/edit.do", method = RequestMethod.GET)
    public String loadEditForm(HttpSession session) {
        if (session.getAttribute("user") == null) return "redirect:/";
        return "mypage/edit_form";
    }
    
    // 4-2. 정보 수정 실제 처리
    @RequestMapping(value = "/mypage/update.do", method = RequestMethod.POST)
    public String processUpdate(HttpSession session, MemberVO vo) {
        MemberVO oldUser = (MemberVO) session.getAttribute("user");
        if (oldUser == null) return "redirect:/";

        String currentUserId = oldUser.getUserId();

        // [비밀번호 로직] 입력값이 없으면 기존 비번 유지, 있으면 새 비번 적용
        if (vo.getUserPw() == null || vo.getUserPw().isEmpty()) {
            String oldPw = memberMapper.getPassword(currentUserId); 
            vo.setUserPw(oldPw); 
        } else {
            vo.setUserPw(vo.getUserPw().trim());
        }
        
        vo.setUserId(currentUserId);
        
        int result = memberMapper.updateMember(vo);
        
        if (result > 0) {
             // 수정 성공 시 세션 정보도 업데이트
             MemberVO updatedUser = memberMapper.login(vo); 
             session.setAttribute("user", updatedUser); 
             return "redirect:/mypage.do?msg=updateSuccess";
        } else {
             return "redirect:/mypage/edit.do?error=fail";
        }
    }
    
    /*******************************************************************************
     * 5. [ACTIVITY & POINTS] 활동 내역 및 포인트/랭킹 관리
     *******************************************************************************/

    // 5-1. 내 전체 활동 내역 (게시글, 댓글, 좋아요한 글)
    @RequestMapping(value = "/mypage/activity.do", method = RequestMethod.GET)
    public String myActivity(Criteria cri, HttpSession session, HttpServletRequest request) {
        if (session.getAttribute("user") == null) return "redirect:/";

        MemberVO user = (MemberVO) session.getAttribute("user");
        String userId = user.getUserId();

        // 세션 최신화
        MemberVO freshUser = memberMapper.read(userId);
        session.setAttribute("user", freshUser);
        
        // 작성글 목록 (페이징 포함)
        List<BoardVO> allMyList = memberMapper.getAllMyPosts(userId, cri);
        request.setAttribute("activityList", allMyList);
        
        int total = memberMapper.getTotalMyPosts(userId);
        request.setAttribute("pageMaker", new PageDTO(cri, total));
        
        // 댓글 및 좋아요한 글 목록
        request.setAttribute("commentList", memberMapper.getMyComments(userId));
        request.setAttribute("likedList", memberMapper.getMyLikedPosts(userId));
        
        return "mypage/activity";
    }
    
    // 5-2. 포인트 관리 페이지
    @RequestMapping(value = "/mypage/points.do", method = RequestMethod.GET)
    public String myPoints(HttpSession session, HttpServletRequest request) {
        if (session.getAttribute("user") == null) return "redirect:/";
        
        MemberVO user = (MemberVO) session.getAttribute("user");
        
        // 세션 최신화 (포인트 변동 확인용)
        MemberVO freshUser = memberMapper.read(user.getUserId());
        session.setAttribute("user", freshUser);
        
        List<PointVO> pointList = memberMapper.getPointHistory(user.getUserId());
        request.setAttribute("pointList", pointList);
        
        return "mypage/points";
    }
    
    // 5-3. 포인트 랭킹 페이지
    @RequestMapping(value = "/ranking.do", method = RequestMethod.GET)
    public String myRanking(HttpSession session, HttpServletRequest request) {
        
        if (session.getAttribute("user") == null) return "redirect:/";
        
        MemberVO user = (MemberVO) session.getAttribute("user");
        
        // 세션 최신화
        MemberVO freshUser = memberMapper.read(user.getUserId());
        session.setAttribute("user", freshUser);
        
        // ★ 랭킹 데이터 로드 (충돌 해결됨)
        java.util.List<MemberVO> rankingList = memberMapper.getPointRanking();
        request.setAttribute("rankingList", rankingList);
        
        return "ranking";
    }
}