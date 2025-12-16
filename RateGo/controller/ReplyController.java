package com.ratego.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.ratego.model.ReplyVO;
import com.ratego.service.ReplyService;

/*******************************************************************************
 * [ReplyController]
 * 설명 : 댓글 관련 비동기 통신(AJAX/REST) 처리 컨트롤러
 * 특이사항 : @RestController 사용 -> 모든 메서드가 View 대신 데이터를 반환함
 * 프로젝트 : RateGo Project
 *******************************************************************************/
@RestController
@RequestMapping("/replies")
public class ReplyController {

    /* =================================================================
     * DEPENDENCY INJECTION
     * ================================================================= */
    @Autowired
    private ReplyService service; // (구) Mapper -> (신) Service 계층 적용 완료


    /*******************************************************************************
     * 1. [CREATE] 댓글 등록
     * - URL : /replies/new (POST)
     * - Data : JSON 데이터 (@RequestBody)
     *******************************************************************************/
    @PostMapping("/new")
    public String create(@RequestBody ReplyVO vo) {
        // @RequestBody : JSON 데이터를 Java 객체(VO)로 변환
        int count = service.register(vo);
        
        // 삼항 연산자 : 성공 시 "success", 실패 시 "fail" 문자열 반환
        return count == 1 ? "success" : "fail";
    }


    /*******************************************************************************
     * 2. [READ] 댓글 목록 조회
     * - URL : /replies/pages/{bno} (GET)
     * - Return : 댓글 리스트 (JSON Array)
     *******************************************************************************/
    @GetMapping("/pages/{bno}")
    public List<ReplyVO> getList(@PathVariable("bno") Long bno) {
        // 특정 게시글(bno)에 달린 모든 댓글 가져오기
        return service.getList(bno);
    }


    /*******************************************************************************
     * 3. [DELETE] 댓글 삭제
     * - URL : /replies/{rno} (DELETE)
     * - Method : DELETE 방식 사용
     *******************************************************************************/
    @DeleteMapping("/{rno}")
    public String remove(@PathVariable("rno") int rno) {
        int count = service.remove(rno);
        return count == 1 ? "success" : "fail";
    }


    /*******************************************************************************
     * 4. [UPDATE] 댓글 수정
     * - URL : /replies/{rno} (PUT / PATCH)
     * - 특이사항 : PUT(전체 수정)과 PATCH(일부 수정) 둘 다 처리
     *******************************************************************************/
    @RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH }, value = "/{rno}")
    public String modify(@RequestBody ReplyVO vo, @PathVariable("rno") int rno) {
        
        // URL 경로에 있는 댓글 번호(rno)를 VO 객체에 안전하게 주입
        vo.setRno(rno); 
        
        int count = service.modify(vo);
        return count == 1 ? "success" : "fail";
    }
}