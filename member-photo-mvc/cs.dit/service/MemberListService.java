package cs.dit.service;

import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cs.dit.member.MemberDAO;
import cs.dit.member.MemberDTO;

public class MemberListService implements MemberService {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        // DAO의 list() 메서드를 호출해서 전체 회원 목록을 가져오고,
        // "dtos"라는 이름으로 JSP에 전달합니다.
        ArrayList<MemberDTO> dtos = new MemberDAO().list();
        request.setAttribute("dtos", dtos);
    }
}
