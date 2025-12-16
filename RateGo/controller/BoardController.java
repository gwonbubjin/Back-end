package com.ratego.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ratego.model.BoardVO;
import com.ratego.model.Criteria;
import com.ratego.model.MemberVO;
import com.ratego.model.PageDTO;
import com.ratego.service.BoardService;

/*******************************************************************************
 * [BoardController]
 * 설명 : 게시판 관련 모든 기능(CRUD + 좋아요/싫어요)을 제어하는 컨트롤러
 * 프로젝트 : RateGo Project
 *******************************************************************************/
@Controller
@RequestMapping("/board")
public class BoardController {

    /* =================================================================
     * DEPENDENCY INJECTION (의존성 주입)
     * ================================================================= */
    @Autowired
    private BoardService boardService;


    /*******************************************************************************
     * 1. [READ] 게시글 목록 조회 및 상세 보기
     * - list() : 페이징 및 검색 포함 목록 조회
     * - get()  : 게시글 상세 내용 조회
     *******************************************************************************/

    // 1-1. 게시판 목록 (페이징 + 검색)
    @RequestMapping(value = "/list.do", method = RequestMethod.GET)
    public String list(Criteria cri, Model model) {
        
        // 카테고리 null 방지 처리
        if (cri.getCategory() == null) cri.setCategory("");

        // 1) 페이징된 리스트 데이터 가져오기
        model.addAttribute("list", boardService.getList(cri));
        
        // 2) 페이지 버튼(Pagination) 계산
        int total = boardService.getTotal(cri);
        model.addAttribute("pageMaker", new PageDTO(cri, total));
        model.addAttribute("pageCategory", cri.getCategory());
        
        return "board/list"; 
    }

    // 1-2. 게시글 상세 보기
    @GetMapping("/get.do")
    public String get(@RequestParam("bno") Long bno, Model model) {
        // 서비스에서 게시글 정보 가져와서 뷰로 전달
        model.addAttribute("board", boardService.get(bno));
        return "board/get";
    }


    /*******************************************************************************
     * 2. [CREATE] 게시글 작성
     * - register(GET)  : 글쓰기 폼 페이지 이동
     * - register(POST) : DB에 글 저장 (작성자 ID 자동 주입)
     *******************************************************************************/

    // 2-1. 글쓰기 페이지 이동 (로그인 체크)
    @GetMapping("/register.do")
    public String register(HttpSession session) {
        // 로그인 안 되어 있으면 메인으로 쫓아냄
        if(session.getAttribute("user") == null) {
            return "redirect:/"; 
        }
        return "board/register";
    }

    // 2-2. 글 저장 (★ 500 에러 해결: 작성자 ID 강제 주입 로직 포함 ★)
    @PostMapping("/register.do")
    public String register(BoardVO board, HttpSession session) {
        MemberVO user = (MemberVO) session.getAttribute("user");
        
        // 세션 만료 시 저장 불가 -> 메인으로 리다이렉트
        if(user == null) {
            return "redirect:/"; 
        }
        
        // [핵심] 클라이언트 조작 방지: 세션의 실제 ID를 작성자로 설정
        board.setWriter(user.getUserId());
        
        boardService.register(board);
        return "redirect:/board/list.do";
    }


    /*******************************************************************************
     * 3. [UPDATE & DELETE] 게시글 수정 및 삭제
     * - modify(GET)  : 수정 페이지 이동
     * - modify(POST) : 실제 수정 처리
     * - remove(POST) : 삭제 처리
     *******************************************************************************/

    // 3-1. 수정 페이지 이동
    @GetMapping("/modify.do")
    public String modify(@RequestParam("bno") Long bno, HttpSession session, Model model) {
        // 로그인 체크
        if(session.getAttribute("user") == null) return "redirect:/";
        
        // 기존 글 내용 불러오기
        model.addAttribute("board", boardService.get(bno));
        return "board/modify";
    }

    // 3-2. 수정 처리
    @PostMapping("/modify.do")
    public String modify(BoardVO board, @RequestParam("bno") Long bno, RedirectAttributes rttr) {
        // 수정 성공 시 일회성 메시지(result) 전달
        if (boardService.modify(board)) {
            rttr.addFlashAttribute("result", "success");
        }
        return "redirect:/board/list.do";
    }

    // 3-3. 삭제 처리
    @PostMapping("/remove.do")
    public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
        if (boardService.remove(bno)) {
            rttr.addFlashAttribute("result", "success");
        }
        return "redirect:/board/list.do";
    }


    /*******************************************************************************
     * 4. [AJAX] 상호작용 기능 (좋아요 / 싫어요)
     * - @ResponseBody 사용 : JSON 데이터 반환
     *******************************************************************************/

    // 4-1. 좋아요
    @PostMapping("/like")
    @ResponseBody 
    public int like(@RequestParam("bno") Long bno, HttpSession session) {
        MemberVO user = (MemberVO) session.getAttribute("user");
        
        // 비로그인 상태면 -1 반환 (프론트엔드 처리용)
        if(user == null) return -1; 
        
        return boardService.like(bno, user.getUserId());
    }
    
    // 4-2. 싫어요
    @PostMapping("/dislike")
    @ResponseBody
    public int dislike(@RequestParam("bno") Long bno, HttpSession session) {
        MemberVO user = (MemberVO) session.getAttribute("user");
        
        // 비로그인 상태면 -1 반환
        if(user == null) return -1; 
        
        return boardService.dislike(bno, user.getUserId());
    }

}