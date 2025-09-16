package cs.dit.board.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cs.dit.board.dao.BoardDAO;
import cs.dit.board.dto.BoardDTO;

public class BoardWriteService implements BoardService {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        String writer = request.getParameter("writer");

        BoardDTO dto = new BoardDTO();
        dto.setSubject(subject);
        dto.setContent(content);
        dto.setWriter(writer);

        BoardDAO dao = new BoardDAO();
        dao.insert(dto);
    }
}
