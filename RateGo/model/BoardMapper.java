package com.ratego.model;

import java.util.List;
import org.apache.ibatis.annotations.Param; 

/*******************************************************************************
 * [BoardMapper Interface]
 * 설명 : 게시판 관련 SQL 쿼리(XML)를 호출하는 매퍼 인터페이스
 * 특징 : @Param을 사용하여 XML로 파라미터를 명시적으로 전달
 * 프로젝트 : RateGo Project
 *******************************************************************************/
public interface BoardMapper {
    
    /*******************************************************************************
     * 1. [BASIC CRUD] 게시글 기본 관리
     * - 조회(List, Read), 등록(Insert), 수정(Update), 삭제(Delete)
     *******************************************************************************/

    // 1-1. 게시글 목록 조회 (페이징 + 검색 조건 Criteria 적용)
    public List<BoardVO> getList(Criteria cri);
    
    // 1-2. 전체 게시글 수 구하기 (페이징 계산을 위해 필수)
    public int getTotal(Criteria cri);
    
    // 2. 게시글 등록
    public void insert(BoardVO board); 
    
    // 3. 게시글 상세 조회 (하나만 가져오기)
    public BoardVO read(Long bno);
    
    // 4. 게시글 수정
    public int update(BoardVO board);

    // 5. 게시글 삭제
    public int delete(Long bno);
    

    /*******************************************************************************
     * 2. [METRICS] 카운트 자동 업데이트
     * - 댓글 수(replyCnt), 조회수(viewCnt) 관리
     *******************************************************************************/
    
    // 6. 댓글 수 증감 (댓글이 달리거나 삭제될 때 호출)
    // @Param("amount") : 1이면 증가, -1이면 감소
    public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
    
    // 7. 조회수 증가 (글 읽을 때 호출)
    public void updateViewCnt(Long bno);
    

    /*******************************************************************************
     * 3. [INTERACTION] 좋아요 (Like) 시스템
     * - 로직 순서 : 중복체크 -> (없으면)추가/(있으면)삭제 -> 카운트 갱신
     *******************************************************************************/
    
    // 좋아요 여부 확인 (1: 누름, 0: 안누름)
    public int checkLike(@Param("bno") Long bno, @Param("userId") String userId);
    
    // 좋아요 추가 (INSERT)
    public void insertLike(@Param("bno") Long bno, @Param("userId") String userId);
    
    // 좋아요 취소 (DELETE)
    public void deleteLike(@Param("bno") Long bno, @Param("userId") String userId);
    
    // 게시글 테이블(tbl_board)의 like_cnt 컬럼 최신화
    public void updateLikeCount(Long bno);


    /*******************************************************************************
     * 4. [INTERACTION] 싫어요 (Dislike) 시스템
     * - 좋아요와 로직 동일
     *******************************************************************************/
    
    // 싫어요 여부 확인
    public int checkDislike(@Param("bno") Long bno, @Param("userId") String userId);
    
    // 싫어요 추가
    public void insertDislike(@Param("bno") Long bno, @Param("userId") String userId);
    
    // 싫어요 취소
    public void deleteDislike(@Param("bno") Long bno, @Param("userId") String userId);
    
    // 게시글 테이블의 dislike_cnt 컬럼 최신화
    public void updateDislikeCount(Long bno);
    

    /*******************************************************************************
     * 5. [DASHBOARD] 메인 화면 위젯용 데이터
     *******************************************************************************/
    
    // 인기 게시글 (조회수 or 좋아요 높은 순)
    public List<BoardVO> getHotList();
    
    // 최신 게시글 (작성일 순)
    public List<BoardVO> getRecentList();
    
}