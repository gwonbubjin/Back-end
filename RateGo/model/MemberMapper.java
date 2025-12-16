package com.ratego.model;

import java.util.List;
import org.apache.ibatis.annotations.Param;

/*******************************************************************************
 * [MemberMapper Interface]
 * 설명 : 회원 정보, 포인트, 활동 내역 등 유저와 관련된 모든 DB 접근 처리
 * 특이사항 : 포인트 변동과 로그 기록은 보통 트랜잭션으로 묶여야 함
 * 프로젝트 : RateGo Project
 *******************************************************************************/
public interface MemberMapper {
    
    /*******************************************************************************
     * 1. [ACCOUNT] 계정 관리 (가입/로그인/수정/보안)
     *******************************************************************************/

    // 1-1. 회원가입
    public int join(MemberVO vo);
    
    // 1-2. 로그인 (ID/PW 일치 여부 확인 후 정보 반환)
    public MemberVO login(MemberVO vo);
    
    // 1-3. 회원 정보 단건 조회 (세션 최신화 용도)
    public MemberVO read(String userId);
    
    // 1-4. 비밀번호 일치 확인
    // ★ 주의 : XML의 #{userPw}와 이름 일치시키기 위해 @Param 사용 필수
    public boolean checkPassword(@Param("userId") String userId, @Param("userPw") String userPw);
    
    // 1-5. 기존 비밀번호 조회 (암호화된 비번 가져올 때 사용)
    public String getPassword(String userId);

    // 1-6. 개인정보(비번, 닉네임 등) 업데이트
    public int updateMember(MemberVO vo);
    

    /*******************************************************************************
     * 2. [POINT SYSTEM] 포인트 관리 & 랭킹
     * - 포인트 증감, 로그 기록, 랭킹 조회
     *******************************************************************************/

    // 2-1. 포인트 잔액 업데이트 (amount: 양수면 획득, 음수면 차감)
    public void updatePoints(@Param("userId") String userId, @Param("amount") int amount);

    // 2-2. 포인트 변동 로그 저장 (어떤 사유로 포인트가 변했는지 기록)
    public void insertPointLog(@Param("userId") String userId, @Param("amount") int amount, @Param("reason") String reason);
    
    // 2-3. 나의 포인트 변동 내역 조회
    public List<PointVO> getPointHistory(String userId);
    
    // 2-4. 전체 유저 포인트 랭킹 조회
    public List<MemberVO> getPointRanking();
    

    /*******************************************************************************
     * 3. [ACTIVITY STATS] 마이페이지 대시보드 (통계)
     *******************************************************************************/
    
    // 내가 쓴 게시글 총 개수
    public int countMyPosts(String userId);
    
    // 내가 받은 총 좋아요 수
    public int countLikesReceived(String userId);
    
    // 마이페이지 메인 요약용 (최신글 5~10개만)
    public List<BoardVO> getMyRecentPosts(String userId);
    

    /*******************************************************************************
     * 4. [ACTIVITY LIST] 상세 활동 내역 (페이징 포함)
     *******************************************************************************/
    
    // [작성글] 내 모든 글 가져오기 (페이징 Criteria 적용)
    // @Param("cri")를 사용하여 XML에서 #{cri.pageNum} 등으로 접근
    public List<BoardVO> getAllMyPosts(@Param("userId") String userId, @Param("cri") Criteria cri);
    
    // [작성글] 페이징 계산을 위한 내 글 전체 개수 (위의 countMyPosts와 용도 구분)
    public int getTotalMyPosts(@Param("userId") String userId);
    
    // [댓글] 내가 쓴 댓글 목록
    public List<ReplyVO> getMyComments(String userId);
    
    // [좋아요] 내가 좋아요 누른 글 목록
    public List<BoardVO> getMyLikedPosts(String userId);
    
}