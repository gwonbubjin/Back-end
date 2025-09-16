package cs.dit.board.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cs.dit.board.dao.BoardDAO;

public class BoardDeleteService implements BoardService {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        int bcode = Integer.parseInt(request.getParameter("bcode"));
        BoardDAO dao = new BoardDAO();
        dao.delete(bcode);
    }
}
