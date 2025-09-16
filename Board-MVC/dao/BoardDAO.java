package cs.dit.board.dao;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.DataSource;

import cs.dit.board.dto.BoardDTO;

public class BoardDAO {
    private static DataSource ds;

    static {
        try {
            Context init = new InitialContext();
            Context env  = (Context) init.lookup("java:comp/env");
            ds = (DataSource) env.lookup("jdbc/jskim"); // JNDI 이름과 일치
            if (ds == null) throw new IllegalStateException("DataSource lookup 결과가 null");
        } catch (Exception e) {
            // 서블릿 초기화 단계에서 바로 실패시켜 원인 보이게
            throw new ExceptionInInitializerError("JNDI(DataSource) 초기화 실패: " + e);
        }
    }

    private Connection getConnection() throws SQLException {
        return ds.getConnection();
    }

    // 1) 개수
    public int count() {
        String sql = "SELECT COUNT(*) FROM board";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            throw new RuntimeException("count() 쿼리 실패", e);
        }
    }

    // 2) 목록
    public List<BoardDTO> list(int offset, int limit) {
        String sql = "SELECT bcode, subject, content, writer, regdate " +
                     "FROM board ORDER BY bcode DESC LIMIT ? OFFSET ?";
        List<BoardDTO> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BoardDTO dto = new BoardDTO();
                    dto.setBcode(rs.getInt("bcode"));
                    dto.setSubject(rs.getString("subject"));
                    dto.setContent(rs.getString("content"));
                    dto.setWriter(rs.getString("writer"));
                    dto.setRegdate(rs.getDate("regdate")); // DATETIME이면 getTimestamp 권장
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("list() 쿼리 실패", e);
        }
        return list;
    }

    // 3) 상세
    public BoardDTO find(int bcode) {
        String sql = "SELECT bcode, subject, content, writer, regdate FROM board WHERE bcode=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bcode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BoardDTO dto = new BoardDTO();
                    dto.setBcode(rs.getInt("bcode"));
                    dto.setSubject(rs.getString("subject"));
                    dto.setContent(rs.getString("content"));
                    dto.setWriter(rs.getString("writer"));
                    dto.setRegdate(rs.getDate("regdate"));
                    return dto;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("find() 쿼리 실패", e);
        }
        return null;
    }

    // 4) 작성
    public int insert(BoardDTO dto) {
        String sql = "INSERT INTO board(subject, content, writer, regdate) VALUES(?, ?, ?, NOW())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dto.getSubject());
            ps.setString(2, dto.getContent());
            ps.setString(3, dto.getWriter());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("insert() 실패", e);
        }
    }

    // 5) 수정
    public int update(BoardDTO dto) {
        String sql = "UPDATE board SET subject=?, content=?, writer=? WHERE bcode=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dto.getSubject());
            ps.setString(2, dto.getContent());
            ps.setString(3, dto.getWriter());
            ps.setInt(4, dto.getBcode());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("update() 실패", e);
        }
    }

    // 6) 삭제
    public int delete(int bcode) {
        String sql = "DELETE FROM board WHERE bcode=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bcode);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("delete() 실패", e);
        }
    }
}
