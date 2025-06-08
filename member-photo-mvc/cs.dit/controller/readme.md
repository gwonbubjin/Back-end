# MemberController README

**파일 위치**

```
src/main/java/cs/dit/controller/MemberController.java
```

---

## 📌 역할

* 모든 `*.do` 요청을 한 곳에서 처리합니다.
* URI 끝 부분(예: `list.do` → `list`)을 추출해 서비스 로직을 분기 호출합니다.
* 서비스(Service) 계층을 통해 비즈니스 로직을 실행하고, JSP 뷰로 `forward` 또는 `sendRedirect`합니다.

---

## 🔧 주요 기능

1. **리스트 호출** (`list.do`)

   * `MemberListService` 실행 → `list.jsp` 포워드
2. **입력 폼** (`insertForm.do`)

   * `insertForm.jsp` 포워드
3. **입력 처리** (`insert.do`)

   * `MemberInsertService` 실행 → `list.do` 리다이렉트
4. **단일 조회** (`get.do?id={id}`)

   * `MemberGetService` 실행 → `updateForm.jsp` 포워드
5. **수정 처리** (`update.do`)

   * `MemberUpdateService` 실행 → `updatePro.jsp` 포워드
6. **삭제 처리** (`delete.do?id={id}`)

   * `MemberDeleteService` 실행 → `delete.jsp` 포워드
7. **메인 화면** (`index.do`)

   * `index.jsp` 포워드

---

## 📋 전체 코드

```java
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
        String cmd = uri.substring(uri.lastIndexOf('/') + 1, uri.lastIndexOf(".do"));
        MemberService service = null;
        String viewPage = null;

        switch (cmd) {
            case "list":
                service = new MemberListService();
                service.execute(request, response);
                viewPage = "list.jsp";
                break;
            case "insertForm":
                viewPage = "insertForm.jsp";
                break;
            case "insert":
                service = new MemberInsertService();
                service.execute(request, response);
                response.sendRedirect("list.do");
                return;
            case "get":
                service = new MemberGetService();
                service.execute(request, response);
                viewPage = "updateForm.jsp";
                break;
            case "update":
                service = new MemberUpdateService();
                service.execute(request, response);
                viewPage = "updatePro.jsp";
                break;
            case "delete":
                service = new MemberDeleteService();
                service.execute(request, response);
                viewPage = "delete.jsp";
                break;
            case "index":
                viewPage = "index.jsp";
                break;
            default:
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
```

---

## ▶ 사용법

1. 프로젝트 배포 후 브라우저에서 `index.do` 접속
2. 각 버튼 클릭으로 `list.do`, `insertForm.do` 등 기능 동작 확인
3. 필요 시 서비스 로직 및 JSP 위치 변경하여 커스터마이징 가능



