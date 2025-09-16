package cs.dit.board.service;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cs.dit.board.dao.BoardDAO;
import cs.dit.board.dto.BoardDTO;

public class BoardListService implements BoardService {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) {

        BoardDAO dao = new BoardDAO();

        // 1) 총 게시글 수
        int totalCount = dao.count();

        // 2) 현재 페이지 p (기본 1)
        String p_ = request.getParameter("p");
        int p = 1;
        if (p_ != null && p_.matches("\\d+")) {
            p = Integer.parseInt(p_);
        }

        // 3) 페이지/블록 설정
        int pageSize  = 10; // 페이지당 글 수
        int blockSize = 5;  // 페이지 번호 몇 칸 보여줄지

        // 4) 마지막 페이지
        int lastPage = (int) Math.ceil(totalCount / (double) pageSize);
        if (lastPage == 0) lastPage = 1; // 글 없을 때도 1페이지로

        // p 보정
        if (p < 1) p = 1;
        if (p > lastPage) p = lastPage;

        // 5) DB 페이징 offset
        int offset = (p - 1) * pageSize;

        // 6) 목록
        List<BoardDTO> list = dao.list(offset, pageSize);

        // 7) 페이지네이션 블록 시작 번호 (교수님 스타일)
        int startNum = p - ((p - 1) % blockSize);

        // 8) JSP 전달
        request.setAttribute("list", list);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("p", p);

        request.setAttribute("numOfPages", blockSize);
        request.setAttribute("lastNum", lastPage);
        request.setAttribute("startNum", startNum);
    }
}
