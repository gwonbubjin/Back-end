package cs.dit.board.dto;

import java.sql.Date;

public class BoardDTO {
    private int bcode;        // 글 번호
    private String subject;   // 제목
    private String content;   // 내용
    private String writer;    // 작성자
    private Date regdate;     // 작성일 (java.sql.Date)

    // 기본 생성자
    public BoardDTO() {}

    // 전체 필드 생성자
    public BoardDTO(int bcode, String subject, String content, String writer, Date regdate) {
        this.bcode = bcode;
        this.subject = subject;
        this.content = content;
        this.writer = writer;
        this.regdate = regdate;
    }

    // Getter & Setter
    public int getBcode() {
        return bcode;
    }
    public void setBcode(int bcode) {
        this.bcode = bcode;
    }

    public String getSubject() {
        return subject;
    }
    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    public String getWriter() {
        return writer;
    }
    public void setWriter(String writer) {
        this.writer = writer;
    }

    public Date getRegdate() {
        return regdate;
    }
    public void setRegdate(Date regdate) {
        this.regdate = regdate;
    }

    @Override
    public String toString() {
        return "BoardDTO [bcode=" + bcode + ", subject=" + subject + ", content=" + content 
               + ", writer=" + writer + ", regdate=" + regdate + "]";
    }
}
