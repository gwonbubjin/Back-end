package cs.dit.member;

/**
 * 패키지명 : cs.dit.member
 * 파일명 : MemberDTO.java
 * 작성일 : 2025. 4. 16.
 * 작성자 : 김진숙
 * 변경이력 :
 * 프로그램 설명 : Member 테이블의 데이터를 담는 용기 
 *
 */
public class MemberDTO {
	
	private String id;
	private String name;
	private String pwd;
	private String photo;
	
	public String getPhoto() {
		return photo;
	}
	public void setPhoto(String photo) {
		this.photo = photo;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public MemberDTO(String id, String name, String pwd, String photo) {
		this.id = id;
		this.name = name;
		this.pwd = pwd;
		this.photo = photo;
	}
	public MemberDTO() {}

	
}
