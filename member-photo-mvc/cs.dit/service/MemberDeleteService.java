package cs.dit.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cs.dit.member.MemberDAO;

public class MemberDeleteService implements MemberService {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        // 쿼리스트링으로 넘어온 id 읽기
        String id = request.getParameter("id");
        
        // DAO를 통해 회원 삭제
        new MemberDAO().delete(id);
    }
}
