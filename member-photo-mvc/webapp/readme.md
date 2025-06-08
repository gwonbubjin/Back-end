# Member Photo MVC

이 저장소는 **MVC 패턴**에 따라 구성된 JSP 웹 애플리케이션 예제입니다.

특히 View 계층(JSP) 파일들을 컨트롤러(`*.do`) 호출에 맞게 수정·정리한 내용을 담고 있습니다.

---

## 📁 프로젝트 구조

```
member-photo-mvc
├─ src/main/java/cs/dit/controller/MemberController.java
├─ src/main/java/cs/dit/service/       (Service 인터페이스·구현체)
├─ src/main/java/cs/dit/member/        (DAO · DTO · Upload 서블릿)
└─ src/main/webapp/WEB-INF/views/     (모든 화면용 JSP)
   ├─ index.jsp
   ├─ list.jsp
   ├─ insertForm.jsp
   ├─ updateForm.jsp
   ├─ updatePro.jsp
   └─ delete.jsp
```

---

## 📄 View(JSP) 파일 수정 내역

### 1. `index.jsp`

* **경로:** `WEB-INF/views/index.jsp`
* 홈 화면 → 컨트롤러 호출(`index.do`, `list.do`, `insertForm.do`)
* Bootstrap 내비게이션과 버튼 링크를 MVC 패턴에 맞게 `.do` 경로로 수정

```jsp
<a href="list.do" class="btn btn-primary">멤버 목록</a>
<a href="insertForm.do" class="btn btn-secondary">멤버 입력</a>
```

---

### 2. `insertForm.jsp`

* **경로:** `WEB-INF/views/insertForm.jsp`
* `<form action="insert.do" method="post" enctype="multipart/form-data">` 설정
* JSP 내 불필요한 scriptlet 제거, 오로지 EL/폼 태그만 사용

```jsp
<form action="insert.do" method="post" enctype="multipart/form-data">
  <!-- id, name, pwd, photo 필드 -->
</form>
```

---

### 3. `list.jsp`

* **경로:** `WEB-INF/views/list.jsp`
* DAO 호출 스크립틀릿 제거 → Controller → Service → DAO 흐름 유지
* JSTL `<c:forEach items="${dtos}">` 로 `dtos` 반복 출력
* 삭제·수정 링크를 각각 `delete.do?id=${dto.id}`, `get.do?id=${dto.id}`로 변경

```jsp
<table>
  <c:forEach var="dto" items="${dtos}">
    <tr>
      <td><a href="get.do?id=${dto.id}">${dto.id}</a></td>
      <td>${dto.name}</td>
      <td>${dto.pwd}</td>
      <td><img src="photos/${dto.photo}" /></td>
      <td><a href="delete.do?id=${dto.id}" onclick="return confirm('삭제?');">삭제</a></td>
      <td><a href="get.do?id=${dto.id}">수정</a></td>
    </tr>
  </c:forEach>
</table>
```

---

### 4. `updateForm.jsp`

* **경로:** `WEB-INF/views/updateForm.jsp`
* Controller에서 request.setAttribute("dto", …)로 넘긴 데이터를 `${dto.*}`로 바인딩
* 폼 `action="update.do"`로 변경

```jsp
<input name="id" value="${dto.id}" readonly />
<input name="name" value="${dto.name}" />
<input type="file" name="photo" />
```

---

### 5. `updatePro.jsp`

* **경로:** `WEB-INF/views/updatePro.jsp`
* 서버 로직없이 단순 알림 후 `list.do`로 리다이렉트

```jsp
<script>
  alert("변경되었습니다!");
  location.href = 'list.do';
</script>
```

---

### 6. `delete.jsp`

* **경로:** `WEB-INF/views/delete.jsp`
* 알림 후 `list.do` 리다이렉트

```jsp
<script>
  alert("삭제되었습니다!");
  location.href = 'list.do';
</script>
```

---

## 🚀 실행 방법

1. Maven/Tomcat 설정 확인
2. `MemberController`가 맵핑된 `*.do` URL로 접속

   * 예: `http://localhost:8080/member-photo-mvc/index.do`
3. 각 버튼 클릭하여 목록/List → 입력/Form → 수정 → 삭제 기능 테스트

---


