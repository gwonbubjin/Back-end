package cs.dit.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface MemberService {
    void execute(HttpServletRequest request, HttpServletResponse response);
}
