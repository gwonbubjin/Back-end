package com.ratego.model;

import java.util.Date;

/*******************************************************************************
 * [MemberVO]
 * 설명 : 회원 테이블(tbl_member)의 데이터를 담는 객체
 * 특징 : Lombok(@Data) 미사용 -> 직접 Getter/Setter 구현 (디버깅 용이성)
 * 프로젝트 : RateGo Project
 *******************************************************************************/
public class MemberVO {

    /* =================================================================
     * 1. 계정 및 인증 정보 (Essential)
     * ================================================================= */
    private String userId;     // 아이디 (PK)
    private String userPw;     // 비밀번호 (암호화 저장 권장)

    /* =================================================================
     * 2. 프로필 정보 (Profile)
     * ================================================================= */
    private String userName;   // 이름 (닉네임)
    private String userEmail;  // 이메일 (연락처)

    /* =================================================================
     * 3. 시스템 및 상태 정보 (System & Status)
     * ================================================================= */
    private int points;        // 보유 포인트 (기본값 0)
    
    // ★ 변경됨: 기존 String -> Date 타입으로 변경 (DB의 TIMESTAMP와 매핑)
    private Date joinDate;     


    /*******************************************************************************
     * [CONSTRUCTORS] 생성자
     *******************************************************************************/
    public MemberVO() {
        // 기본 생성자 (MyBatis가 객체 생성할 때 필수)
    }


    /*******************************************************************************
     * [ACCESSOR METHODS] Getter & Setter
     * - 캡슐화된 필드에 접근하기 위한 메서드 모음
     *******************************************************************************/

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUserPw() { return userPw; }
    public void setUserPw(String userPw) { this.userPw = userPw; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }

    public Date getJoinDate() { return joinDate; }
    public void setJoinDate(Date joinDate) { this.joinDate = joinDate; }

}