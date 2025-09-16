package cs.dit.board.controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cs.dit.board.service.BoardDeleteService;
import cs.dit.board.service.BoardDetailService;
import cs.dit.board.service.BoardEditService;
import cs.dit.board.service.BoardListService;
import cs.dit.board.service.BoardService;
import cs.dit.board.service.BoardWriteService;

public class BoardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // e.g. /board-mvc/list.do  ->  list
        String cmd = extractCommand(request);

        // 기본 이동 목적지 (forward 대상)
        String viewPage = null;

        try {
            switch (cmd) {
                case "list": {
                    BoardService svc = new BoardListService();
                    svc.execute(request, response);
                    viewPage = "/WEB-INF/view/board/list.jsp";
                    break;
                }
                case "detail": {
                    BoardService svc = new BoardDetailService();
                    svc.execute(request, response);
                    viewPage = "/WEB-INF/view/board/detail.jsp";
                    break;
                }
                case "writeForm": {
                    viewPage = "/WEB-INF/view/board/write.jsp";
                    break;
                }
                case "write": {
                    BoardService svc = new BoardWriteService();
                    svc.execute(request, response);
                    // 중복 등록 방지: PRG 패턴(redirect)
                    response.sendRedirect(request.getContextPath() + "/list.do");
                    return;
                }
                case "editForm": {
                    // 수정 폼에 기존 데이터 필요하면 detail 재사용
                    BoardService svc = new BoardDetailService();
                    svc.execute(request, response);
                    viewPage = "/WEB-INF/view/board/edit.jsp";
                    break;
                }
                case "edit": {
                    BoardService svc = new BoardEditService();
                    svc.execute(request, response);
                    response.sendRedirect(request.getContextPath() + "/list.do");
                    return;
                }
                case "delete": {
                    BoardService svc = new BoardDeleteService();
                    svc.execute(request, response);
                    response.sendRedirect(request.getContextPath() + "/list.do");
                    return;
                }
                case "index": {
                    // 필요 시 프로젝트 루트에서 index.do로 들어왔을 때
                    viewPage = "/WEB-INF/view/index.jsp"; // 존재할 때만
                    break;
                }
                default: {
                    // 정의되지 않은 경우 목록으로
                    BoardService svc = new BoardListService();
                    svc.execute(request, response);
                    viewPage = "/WEB-INF/view/board/list.jsp";
                    break;
                }
            }

            // forward 공통 처리
            forward(request, response, viewPage);

        } catch (Exception e) {
            // 에러 페이지로 넘기거나 콘솔 로그
            request.setAttribute("error", e);
            forward(request, response, "/WEB-INF/view/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST도 동일 로직 처리
        doGet(request, response);
    }

    // === helpers ===
    private String extractCommand(HttpServletRequest request) {
        String uri = request.getRequestURI();        // /board-mvc/list.do
        String ctx = request.getContextPath();       // /board-mvc
        String path = uri.substring(ctx.length());   // /list.do
        int slash = path.lastIndexOf('/');
        int dot = path.lastIndexOf(".do");
        if (slash == -1 || dot == -1 || dot <= slash) return "";
        return path.substring(slash + 1, dot);       // list
    }

    private void forward(HttpServletRequest request, HttpServletResponse response, String viewPage)
            throws ServletException, IOException {
        if (viewPage == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        RequestDispatcher rd = request.getRequestDispatcher(viewPage);
        rd.forward(request, response);
    }
}
