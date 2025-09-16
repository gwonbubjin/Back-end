package cs.dit.board.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cs.dit.board.dao.BoardDAO;
import cs.dit.board.dto.BoardDTO;

public class BoardDetailService implements BoardService {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        String bcode_ = request.getParameter("bcode");
        int bcode = (bcode_ != null) ? Integer.parseInt(bcode_) : 0;

        BoardDAO dao = new BoardDAO();
        BoardDTO dto = dao.find(bcode);

        request.setAttribute("dto", dto);
    }
}
