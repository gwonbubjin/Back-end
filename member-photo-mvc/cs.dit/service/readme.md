# Service Layer README

**패키지 위치**

```
src/main/java/cs/dit/service/
```

---

## 📋 구성 파일

| 파일명                        | 역할                                             |
| -------------------------- | ---------------------------------------------- |
| `MemberService.java`       | 서비스 계층 공통 인터페이스 (`execute` 메서드 선언)             |
| `MemberListService.java`   | 전체 회원 목록 조회 로직 (DAO.list 호출 및 결과 저장)           |
| `MemberInsertService.java` | 회원 등록 로직 (폼 파라미터 받아 DTO 생성 → DAO.insert)       |
| `MemberGetService.java`    | 단일 회원 조회 로직 (쿼리스트링 id → DAO.get → request 바인딩) |
| `MemberUpdateService.java` | 회원 정보 수정 로직 (폼 데이터 → DTO → DAO.update)         |
| `MemberDeleteService.java` | 회원 삭제 로직 (쿼리스트링 id → DAO.delete)               |

---

## 🔍 상세 설명

### 1. `MemberService.java`

서비스 계층의 공통 규약을 정의하는 인터페이스입니다.

```java
public interface MemberService {
    void execute(HttpServletRequest request, HttpServletResponse response);
}
```

* 모든 서비스 클래스는 `execute` 메서드를 구현하여, 컨트롤러 호출 시 일관된 방식으로 동작합니다.

### 2. `MemberListService.java`

전체 회원 목록을 DB에서 조회하고, `request.setAttribute("dtos", list)`로 JSP에 전달합니다.

```java
public class MemberListService implements MemberService {
    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) {
        ArrayList<MemberDTO> dtos = new MemberDAO().list();
        req.setAttribute("dtos", dtos);
    }
}
```

### 3. `MemberInsertService.java`

사용자 등록 폼에서 전달된 파라미터(`id`, `name`, `pwd`, `photo`)를 읽어 DTO 생성 후 `MemberDAO.insert()` 호출합니다.

```java
public class MemberInsertService implements MemberService {
    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) {
        MemberDTO dto = new MemberDTO(
            req.getParameter("id"),
            req.getParameter("name"),
            req.getParameter("pwd"),
            req.getParameter("photo")
        );
        new MemberDAO().insert(dto);
    }
}
```

### 4. `MemberGetService.java`

수정할 회원의 `id`를 파라미터로 받아 `MemberDAO.get(id)` 호출, 결과 DTO를 `request.setAttribute("dto", dto)`로 바인딩합니다.

```java
public class MemberGetService implements MemberService {
    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) {
        String id = req.getParameter("id");
        MemberDTO dto = new MemberDAO().get(id);
        req.setAttribute("dto", dto);
    }
}
```

### 5. `MemberUpdateService.java`

수정 폼에서 전송된 데이터를 DTO로 만든 후 `MemberDAO.update(dto)` 호출합니다.

```java
public class MemberUpdateService implements MemberService {
    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) {
        MemberDTO dto = new MemberDTO(
            req.getParameter("id"),
            req.getParameter("name"),
            req.getParameter("pwd"),
            req.getParameter("photo")
        );
        new MemberDAO().update(dto);
    }
}
```

### 6. `MemberDeleteService.java`

`id` 파라미터를 받아 `MemberDAO.delete(id)` 호출로 회원 삭제를 수행합니다.

```java
public class MemberDeleteService implements MemberService {
    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) {
        String id = req.getParameter("id");
        new MemberDAO().delete(id);
    }
}
```

---

## 🚀 사용 시 흐름

1. **Controller**에서 `cmd`에 따라 해당 Service 선택
2. `service.execute(request, response)` 호출하여 비즈니스 로직 수행
3. Service에서 DAO 호출 및 `request` 속성 바인딩
4. Controller가 지정한 JSP로 `forward` 또는 `redirect`


