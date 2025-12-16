package com.ratego.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ratego.model.BoardMapper;
import com.ratego.model.MemberMapper;
import com.ratego.model.ReplyMapper;
import com.ratego.model.ReplyVO;
import com.ratego.service.ReplyService;

/*******************************************************************************
 * [ReplyServiceImpl]
 * 설명 : 댓글 비즈니스 로직 구현체
 * 핵심 기능 : 댓글 작성/삭제 시 게시글의 댓글 수(replyCnt) 동기화 + 포인트 지급
 * 특이사항 : 2개 이상의 테이블(Board, Member, Reply)을 건드리기 때문에 @Transactional 필수
 * 프로젝트 : RateGo Project
 *******************************************************************************/
@Service
public class ReplyServiceImpl implements ReplyService {

    /* =================================================================
     * DEPENDENCY INJECTION
     * ================================================================= */
    @Autowired
    private ReplyMapper replyMapper;

    @Autowired
    private BoardMapper boardMapper;  // 게시글 댓글 수(replyCnt) 갱신용
    
    @Autowired
    private MemberMapper memberMapper; // 포인트 지급용


    /*******************************************************************************
     * 1. [CREATE] 댓글 등록
     * - 트랜잭션 : 댓글 수 증가 + 포인트 지급 + 로그 기록 + 댓글 저장
     *******************************************************************************/
    @Transactional
    @Override
    public int register(ReplyVO vo) {
        
        // Step 1. 게시판 테이블(tbl_board)의 댓글 수 +1 증가
        boardMapper.updateReplyCnt((long)vo.getBno(), 1);
        
        // Step 2. 댓글 작성자에게 포인트 5점 지급
        memberMapper.updatePoints(vo.getReplyer(), 5);
        
        // Step 3. 포인트 로그 기록 (장부 기록)
        // "누가 / 얼마를 / 왜" 받았는지 확실히 남김
        memberMapper.insertPointLog(vo.getReplyer(), 5, "댓글 작성");
        
        // Step 4. 댓글 테이블(tbl_reply)에 실제 데이터 저장
        return replyMapper.insert(vo);
    }


    /*******************************************************************************
     * 2. [READ] 댓글 목록 조회
     *******************************************************************************/
    @Override
    public List<ReplyVO> getList(Long bno) {
        // 특정 게시글(bno)에 달린 모든 댓글 반환
        return replyMapper.getList(bno);
    }
    

    /*******************************************************************************
     * 3. [UPDATE & DELETE] 댓글 수정 및 삭제
     * - remove : 댓글 삭제 시 게시글의 댓글 수도 -1 감소시켜야 함 (트랜잭션)
     *******************************************************************************/
    
    // 댓글 삭제
    @Transactional
    @Override
    public int remove(int rno) {
        
        // Step 1. 삭제하기 전에, 이 댓글이 '어떤 게시글(bno)' 소속인지 먼저 조회
        ReplyVO vo = replyMapper.read(rno);
        
        // Step 2. 게시판 테이블의 댓글 수 -1 감소
        boardMapper.updateReplyCnt((long)vo.getBno(), -1);
        
        // (선택사항) 댓글 지우면 줬던 포인트 뺏을까?
        // 지금은 주석 처리됨 (필요하면 주석 해제하여 사용)
        /*
        memberMapper.updatePoints(vo.getReplyer(), -5);
        memberMapper.insertPointLog(vo.getReplyer(), -5, "댓글 삭제됨");
        */
        
        // Step 3. 댓글 테이블에서 진짜 삭제
        return replyMapper.delete(rno);
    }

    // 댓글 수정
    @Override
    public int modify(ReplyVO vo) {
        return replyMapper.update(vo);
    }
}