package cs.dit.controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cs.dit.service.MemberDeleteService;
import cs.dit.service.MemberGetService;
import cs.dit.service.MemberInsertService;
import cs.dit.service.MemberListService;
import cs.dit.service.MemberService;
import cs.dit.service.MemberUpdateService;

@WebServlet("*.do")
public class MemberController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String uri = request.getRequestURI();
        String com = uri.substring(uri.lastIndexOf('/') + 1, uri.lastIndexOf(".do"));
        String viewPage = null;
        MemberService service = null;

        if ("list".equals(com)) {
            service = new MemberListService();
            service.execute(request, response);
            viewPage = "list.jsp";

        } else if ("insertForm".equals(com)) {
            viewPage = "insertForm.jsp";

        } else if ("insert".equals(com)) {
            service = new MemberInsertService();
            service.execute(request, response);
            response.sendRedirect("list.do");
            return;

        } else if ("get".equals(com)) {
            service = new MemberGetService();
            service.execute(request, response);
            viewPage = "updateForm.jsp";

        } else if ("update".equals(com)) {
            service = new MemberUpdateService();
            service.execute(request, response);
            viewPage = "updatePro.jsp";

        } else if ("delete".equals(com)) {
            service = new MemberDeleteService();
            service.execute(request, response);
            viewPage = "delete.jsp";

        } else if ("index".equals(com)) {
            viewPage = "index.jsp";

        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        RequestDispatcher rd = request.getRequestDispatcher(viewPage);
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
