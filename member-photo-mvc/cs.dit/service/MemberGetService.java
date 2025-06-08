package cs.dit.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cs.dit.member.MemberDAO;
import cs.dit.member.MemberDTO;

public class MemberGetService implements MemberService {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        // 쿼리스트링으로 넘어온 id 읽기
        String id = request.getParameter("id");
        
        // DAO에서 단일 회원 조회
        MemberDTO dto = new MemberDAO().get(id);
        
        // JSP에 "dto"로 전달
        request.setAttribute("dto", dto);
    }
}
