package com.ratego.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/*******************************************************************************
 * [DBManager]
 * 설명 : 순수 JDBC 방식을 이용하여 DB 연결 및 해제를 담당하는 유틸리티 클래스
 * 용도 : MyBatis를 거치지 않고 직접 SQL을 실행해야 할 때 사용 (테스트용 등)
 * 프로젝트 : RateGo Project
 *******************************************************************************/
public class DBManager {

    /* =================================================================
     * 1. DATABASE CONFIGURATION (설정 정보)
     * ================================================================= */
    // JDBC URL : MySQL 8.0 이상은 CJ 드라이버 및 타임존 설정 필수
    private static String url = "jdbc:mysql://localhost:3306/ratego?serverTimezone=UTC";
    
    private static String uid = "root";       // DB 아이디
    private static String upw = "1111";       // ★ 보안 주의: 실제 서비스 시 암호화 필요


    /*******************************************************************************
     * 2. [CONNECTION] DB 연결 객체 생성
     * - 드라이버 로드 -> DB 로그인 -> Connection 반환
     *******************************************************************************/
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // 1) MySQL 드라이버 클래스 로딩 (메모리에 올림)
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 2) URL, ID, PW로 DB 연결 시도
            conn = DriverManager.getConnection(url, uid, upw);
            
        } catch (Exception e) {
            e.printStackTrace(); // 연결 실패 시 에러 로그 출력
        }
        return conn;
    }


    /*******************************************************************************
     * 3. [CLEANUP] 자원 해제 (Close)
     * - 중요 : 자원은 생성된 순서의 '역순'으로 닫아야 함
     * - 순서 : ResultSet -> PreparedStatement -> Connection
     *******************************************************************************/

    // 3-1. SELECT 실행 후 닫기 (ResultSet 포함)
    public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if(rs != null) rs.close();       // 결과셋 반납
            if(pstmt != null) pstmt.close(); // 실행객체 반납
            if(conn != null) conn.close();   // 연결 끊기
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // 3-2. INSERT/UPDATE/DELETE 실행 후 닫기 (ResultSet 없음)
    public static void close(Connection conn, PreparedStatement pstmt) {
        try {
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}