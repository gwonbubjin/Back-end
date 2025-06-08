package cs.dit.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cs.dit.member.MemberDAO;
import cs.dit.member.MemberDTO;

public class MemberUpdateService implements MemberService {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        // 폼으로부터 넘어온 파라미터 읽기
        String id    = request.getParameter("id");
        String name  = request.getParameter("name");
        String pwd   = request.getParameter("pwd");
        // 파일 업로드 서블릿에서 처리된 photo 파라미터
        String photo = request.getParameter("photo");
        
        // DTO 생성 및 DAO 호출
        MemberDTO dto = new MemberDTO(id, name, pwd, photo);
        new MemberDAO().update(dto);
    }
}
