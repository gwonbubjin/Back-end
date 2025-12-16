package com.ratego.service;

import java.util.List;
import com.ratego.model.BoardVO;
import com.ratego.model.Criteria; // ★ 페이징 처리를 위해 필수 Import!

/*******************************************************************************
 * [BoardService Interface]
 * 설명 : 게시판의 핵심 비즈니스 로직을 정의하는 인터페이스
 * 역할 : Controller와 Mapper 사이의 다리 역할 (트랜잭션 처리 등)
 * 프로젝트 : RateGo Project
 *******************************************************************************/
public interface BoardService {
    
    /*******************************************************************************
     * 1. [READ] 게시글 조회
     * - getList  : 페이징과 검색 조건(Criteria)이 적용된 목록 조회
     * - getTotal : 페이징 계산(PageDTO)을 위해 전체 글 개수 조회
     * - get      : 게시글 상세 내용 조회 (조회수 증가 로직 포함 예상)
     *******************************************************************************/
    
    // 목록 조회 (페이징 + 검색)
    public List<BoardVO> getList(Criteria cri);

    // 전체 글 개수 (페이징 계산용)
    public int getTotal(Criteria cri);
    
    // 글 상세 조회
    public BoardVO get(Long bno);
    

    /*******************************************************************************
     * 2. [CUD] 게시글 등록 / 수정 / 삭제
     * - register : 반환값 없음 (void)
     * - modify, remove : 성공 여부를 알리기 위해 boolean 반환
     *******************************************************************************/
    
    // 글 등록
    public void register(BoardVO board);
    
    // 글 수정 (성공 시 true)
    public boolean modify(BoardVO board);
    
    // 글 삭제 (성공 시 true)
    public boolean remove(Long bno);
    

    /*******************************************************************************
     * 3. [INTERACTION] 상호작용 (좋아요 / 싫어요)
     * - 비즈니스 로직 : 중복 체크 -> DB 반영 -> 최신 카운트 반환
     *******************************************************************************/
    
    // 좋아요 처리
    public int like(Long bno, String userId);
    
    // 싫어요 처리
    public int dislike(Long bno, String userId);
    

    /*******************************************************************************
     * 4. [DASHBOARD] 메인 화면 위젯용 데이터
     *******************************************************************************/
    
    // 인기 게시글 (HOT)
    public List<BoardVO> getHotList();
    
    // 최신 게시글 (New)
    public List<BoardVO> getRecentList();

}