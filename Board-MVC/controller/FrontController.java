package cs.dit.board.controller;

import cs.dit.board.dao.BoardDAO;
import cs.dit.board.dto.BoardDTO;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.util.List;

@WebServlet("*.do") // *.do 요청을 이 컨트롤러가 받음 (web.xml에 중복 매핑하지 않도록 주의)
public class FrontController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 라우팅 확인 로그
        System.out.println(">>> IN uri=" + req.getRequestURI());

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        final String ctx = req.getContextPath();   // /board-mvc
        final String uri = req.getRequestURI();    // /board-mvc/list.do
        final String cmd = uri.substring(ctx.length()); // /list.do

        switch (cmd) {
            // -------------------- 홈/인덱스 --------------------
            case "/":
            case "/index.do": {
                forward(req, resp, "/WEB-INF/view/board/index.jsp"); // 파일 경로 존재 확인
                break;
            }

            // -------------------- 목록 --------------------
            case "/list.do": {
                // (선택) JNDI/DB 연결 확인
                try {
                    Context init = new InitialContext();
                    Context env  = (Context) init.lookup("java:comp/env");
                    DataSource ds = (DataSource) env.lookup("jdbc/jskim");
                    try (Connection c = ds.getConnection()) {
                        System.out.println(">>> JNDI OK, DB connected. catalog=" + c.getCatalog());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                int p = parseIntOrDefault(req.getParameter("p"), 1);
                final int pageSize = 10;
                final int numOfPages = 5;

                List<BoardDTO> list = null;
                int totalCount = 0;
                try {
                    BoardDAO dao = new BoardDAO();
                    totalCount = dao.count();
                    int totalPage = Math.max(1, (int) Math.ceil(totalCount / (double) pageSize));
                    if (p < 1) p = 1;
                    if (p > totalPage) p = totalPage;

                    int offset = (p - 1) * pageSize;
                    list = dao.list(offset, pageSize);

                    // 페이지네이션 계산
                    int startNum = p - ((p - 1) % numOfPages);
                    int lastNum  = Math.min(startNum + numOfPages - 1, totalPage);

                    // JSP 전달
                    req.setAttribute("list", list);
                    req.setAttribute("totalCount", totalCount);
                    req.setAttribute("p", p);
                    req.setAttribute("pageSize", pageSize);
                    req.setAttribute("numOfPages", numOfPages);
                    req.setAttribute("startNum", startNum);
                    req.setAttribute("lastNum", lastNum);
                    req.setAttribute("hasPrev", startNum > 1);
                    req.setAttribute("hasNext", lastNum < totalPage);

                } catch (Exception e) {
                    e.printStackTrace();
                    // 실패 시 기본값 세팅
                    req.setAttribute("list", list);
                    req.setAttribute("totalCount", totalCount);
                    req.setAttribute("p", 1);
                    req.setAttribute("pageSize", pageSize);
                    req.setAttribute("numOfPages", numOfPages);
                    req.setAttribute("startNum", 1);
                    req.setAttribute("lastNum", 1);
                    req.setAttribute("hasPrev", false);
                    req.setAttribute("hasNext", false);
                }

                forward(req, resp, "/WEB-INF/view/board/list.jsp");
                break;
            }

            // -------------------- 상세 --------------------
            case "/detail.do": {
                int bcode = requiredInt(req, "bcode");
                try {
                    BoardDAO dao = new BoardDAO();
                    BoardDTO dto = dao.find(bcode);
                    if (dto == null) {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "게시글을 찾을 수 없습니다.");
                        return;
                    }
                    req.setAttribute("dto", dto);
                    forward(req, resp, "/WEB-INF/view/board/detail.jsp");
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "상세 조회 중 오류");
                }
                break;
            }

            // -------------------- 글쓰기 폼 --------------------
            case "/insertForm.do": {
                forward(req, resp, "/WEB-INF/view/board/write.jsp");
                break;
            }

            // -------------------- 글쓰기 처리 --------------------
            case "/write.do": {
                // POST만 허용
                if (!"POST".equalsIgnoreCase(req.getMethod())) {
                    resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                    return;
                }

                String subject = trimOrNull(req.getParameter("subject"));
                String writer  = trimOrNull(req.getParameter("writer"));
                String content = trimOrNull(req.getParameter("content"));

                if (isAnyBlank(subject, writer, content)) {
                    req.setAttribute("errorMessage", "제목/작성자/내용은 필수입니다.");
                    forward(req, resp, "/WEB-INF/view/board/write.jsp");
                    return;
                }

                try {
                    BoardDAO dao = new BoardDAO();
                    BoardDTO dto = new BoardDTO(0, subject, content, writer, (Date) null);
                    dao.insert(dto);
                    // PRG 패턴
                    resp.sendRedirect(ctx + "/list.do");
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("errorMessage", "등록 중 오류가 발생했습니다.");
                    forward(req, resp, "/WEB-INF/view/board/write.jsp");
                }
                break;
            }

            // -------------------- 수정 폼 --------------------
            case "/editForm.do": {
                int bcode = requiredInt(req, "bcode");
                try {
                    BoardDAO dao = new BoardDAO();
                    BoardDTO dto = dao.find(bcode);
                    if (dto == null) {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "게시글을 찾을 수 없습니다.");
                        return;
                    }
                    req.setAttribute("dto", dto);
                    forward(req, resp, "/WEB-INF/view/board/edit.jsp");
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "수정 폼 로딩 중 오류");
                }
                break;
            }

            // -------------------- 수정 처리 --------------------
            case "/edit.do": {
                if (!"POST".equalsIgnoreCase(req.getMethod())) {
                    resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                    return;
                }

                int bcode = requiredInt(req, "bcode");
                String subject = trimOrNull(req.getParameter("subject"));
                String writer  = trimOrNull(req.getParameter("writer"));
                String content = trimOrNull(req.getParameter("content"));

                if (isAnyBlank(subject, writer, content)) {
                    req.setAttribute("errorMessage", "제목/작성자/내용은 필수입니다.");
                    // 원본 다시 로딩해 폼으로
                    try {
                        BoardDAO dao = new BoardDAO();
                        BoardDTO dto = dao.find(bcode);
                        req.setAttribute("dto", dto);
                    } catch (Exception ignore) {}
                    forward(req, resp, "/WEB-INF/view/board/edit.jsp");
                    return;
                }

                try {
                    BoardDAO dao = new BoardDAO();
                    BoardDTO dto = new BoardDTO(bcode, subject, content, writer, (Date) null);
                    dao.update(dto);
                    resp.sendRedirect(ctx + "/detail.do?bcode=" + bcode);
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("errorMessage", "수정 중 오류가 발생했습니다.");
                    try {
                        BoardDAO dao = new BoardDAO();
                        BoardDTO dto = dao.find(bcode);
                        req.setAttribute("dto", dto);
                    } catch (Exception ignore) {}
                    forward(req, resp, "/WEB-INF/view/board/edit.jsp");
                }
                break;
            }

            // -------------------- 삭제 처리 --------------------
            case "/delete.do": {
                if (!"POST".equalsIgnoreCase(req.getMethod())) {
                    resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                    return;
                }
                int bcode = requiredInt(req, "bcode");
                try {
                    BoardDAO dao = new BoardDAO();
                    dao.delete(bcode);
                    resp.sendRedirect(ctx + "/list.do");
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "삭제 중 오류");
                }
                break;
            }

            // -------------------- 기타 --------------------
            default: {
                // 알 수 없는 경로는 목록으로
                resp.sendRedirect(ctx + "/list.do");
            }
        }
    }

    // ==================== helpers ====================
    private void forward(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher(path);
        rd.forward(req, resp); // WEB-INF 아래는 forward로만 접근 가능
    }

    private int parseIntOrDefault(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private int requiredInt(HttpServletRequest req, String name) throws IOException {
        String v = req.getParameter(name);
        try {
            return Integer.parseInt(v);
        } catch (Exception e) {
            throw new IOException("필수 정수 파라미터 누락 또는 형식 오류: " + name);
        }
    }

    private String trimOrNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private boolean isAnyBlank(String... arr) {
        if (arr == null) return true;
        for (String s : arr) {
            if (s == null || s.trim().isEmpty()) return true;
        }
        return false;
    }
}
