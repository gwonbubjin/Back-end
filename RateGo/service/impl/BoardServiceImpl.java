package com.ratego.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ratego.model.BoardMapper;
import com.ratego.model.BoardVO;
import com.ratego.model.Criteria;
import com.ratego.model.MemberMapper; 
import com.ratego.service.BoardService;

/*******************************************************************************
 * [BoardServiceImpl]
 * 설명 : 게시판 비즈니스 로직 구현체
 * 핵심 기능 : 게시글 CRUD + 포인트 시스템 연동 (글 작성/좋아요 시 포인트 지급)
 * 프로젝트 : RateGo Project
 *******************************************************************************/
@Service
public class BoardServiceImpl implements BoardService {

    /* =================================================================
     * DEPENDENCY INJECTION
     * ================================================================= */
    @Autowired
    private BoardMapper boardMapper;
    
    @Autowired
    private MemberMapper memberMapper; // 포인트 처리를 위해 추가됨


    /*******************************************************************************
     * 1. [READ] 게시글 조회 관련
     *******************************************************************************/

    // 1-1. 목록 조회 (페이징 적용)
    @Override
    public List<BoardVO> getList(Criteria cri) {
        return boardMapper.getList(cri);
    }

    // 1-2. 전체 글 개수 조회 (페이징 계산용)
    @Override
    public int getTotal(Criteria cri) {
        return boardMapper.getTotal(cri);
    }
    
    // 1-3. 상세 조회 (조회수 증가 포함)
    @Override
    public BoardVO get(Long bno) {
        // 조회수 +1 증가시키고, 데이터 반환
        boardMapper.updateViewCnt(bno); 
        return boardMapper.read(bno);
    }


    /*******************************************************************************
     * 2. [CREATE] 게시글 등록
     * - 트랜잭션 성격 : 글 등록 + 포인트 지급 + 로그 기록
     *******************************************************************************/
    @Override
    public void register(BoardVO board) {
        // 1) 게시글 DB 저장
        boardMapper.insert(board);
        
        // 2) 작성자에게 포인트 지급 (+10점)
        memberMapper.updatePoints(board.getWriter(), 10);
        
        // 3) 포인트 변동 로그 기록
        memberMapper.insertPointLog(board.getWriter(), 10, "게시글 작성");
    }


    /*******************************************************************************
     * 3. [INTERACTION] 좋아요 (Like) 로직
     * - 복잡도 : 높음 (기존 상태에 따라 포인트 지급/회수/복구 로직이 섞임)
     *******************************************************************************/
    @Override
    public int like(Long bno, String userId) {
        BoardVO board = boardMapper.read(bno);
        String authorId = board.getWriterId(); // 작성자 ID (포인트 대상)

        // Step 1. 만약 '싫어요'가 눌려있던 상태라면? -> 싫어요 취소 및 포인트 복구
        if (boardMapper.checkDislike(bno, userId) > 0) {
            boardMapper.deleteDislike(bno, userId);     // 싫어요 삭제
            boardMapper.updateDislikeCount(bno);        // 카운트 갱신
            
            memberMapper.updatePoints(authorId, 5);     // 깎였던 5점 복구
            memberMapper.insertPointLog(authorId, 5, "싫어요 취소됨");
        }

        // Step 2. 좋아요 토글 (ON/OFF)
        if (boardMapper.checkLike(bno, userId) > 0) {
            // [CASE A] 이미 좋아요 누름 -> 취소 처리
            boardMapper.deleteLike(bno, userId);
            
            // 줬던 포인트 회수 (-5점)
            memberMapper.updatePoints(authorId, -5);
            memberMapper.insertPointLog(authorId, -5, "좋아요 취소됨");
            
        } else {
            // [CASE B] 안 눌렀음 -> 좋아요 처리
            boardMapper.insertLike(bno, userId);
            
            // 포인트 지급 (+5점)
            memberMapper.updatePoints(authorId, 5);
            memberMapper.insertPointLog(authorId, 5, "게시글 좋아요 받음");
        }
        
        // Step 3. 최신 좋아요 카운트 갱신 및 반환
        boardMapper.updateLikeCount(bno); 
        return boardMapper.read(bno).getLikecnt();
    }


    /*******************************************************************************
     * 4. [INTERACTION] 싫어요 (Dislike) 로직
     * - 좋아요 로직의 반대 개념 (포인트 차감)
     *******************************************************************************/
    @Override
    public int dislike(Long bno, String userId) {
        BoardVO board = boardMapper.read(bno);
        String authorId = board.getWriterId();

        // Step 1. 만약 '좋아요'가 눌려있던 상태라면? -> 좋아요 취소 및 포인트 회수
        if (boardMapper.checkLike(bno, userId) > 0) {
            boardMapper.deleteLike(bno, userId);
            boardMapper.updateLikeCount(bno);
            
            memberMapper.updatePoints(authorId, -5);    // 받았던 5점 회수
            memberMapper.insertPointLog(authorId, -5, "좋아요 취소됨");
        }

        // Step 2. 싫어요 토글 (ON/OFF)
        if (boardMapper.checkDislike(bno, userId) > 0) {
            // [CASE A] 이미 싫어요 누름 -> 취소 처리
            boardMapper.deleteDislike(bno, userId);
            
            // 깎았던 포인트 복구 (+5점)
            memberMapper.updatePoints(authorId, 5);
            memberMapper.insertPointLog(authorId, 5, "싫어요 취소됨");
            
        } else {
            // [CASE B] 안 눌렀음 -> 싫어요 처리
            boardMapper.insertDislike(bno, userId);
            
            // 포인트 차감 (-5점)
            memberMapper.updatePoints(authorId, -5);
            memberMapper.insertPointLog(authorId, -5, "게시글 싫어요 받음");
        }
        
        boardMapper.updateDislikeCount(bno); 
        return boardMapper.read(bno).getDislikecnt();
    }


    /*******************************************************************************
     * 5. [UPDATE & DELETE] 수정 및 삭제
     *******************************************************************************/
    
    // 글 수정
    @Override
    public boolean modify(BoardVO board) {
        return boardMapper.update(board) == 1;
    }

    // 글 삭제
    @Override
    public boolean remove(Long bno) {
        return boardMapper.delete(bno) == 1;
    }


    /*******************************************************************************
     * 6. [DASHBOARD] 메인 화면 데이터
     *******************************************************************************/
    @Override
    public List<BoardVO> getHotList() {
        return boardMapper.getHotList();
    }

    @Override
    public List<BoardVO> getRecentList() {
        return boardMapper.getRecentList();
    }
}