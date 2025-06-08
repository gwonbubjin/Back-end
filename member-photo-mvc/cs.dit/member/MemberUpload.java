package cs.dit.member;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;


@WebServlet("*.do")
@MultipartConfig(
	location = "C:/tmp",
	maxFileSize = -1,
	maxRequestSize = -1
)
public class MemberUpload extends HttpServlet {
	private static final long serialVersionUID = 1L; 

	private String photo = "";
	private String filePath = "";
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		String contentType = request.getContentType();
		String viewPage = "";
		String uri = request.getRequestURI();
		String com = uri.substring(uri.lastIndexOf("/")+1, uri.lastIndexOf(".do"));
		
		if(com!=null && com.equals("insertForm")) {
			viewPage = "insertForm.jsp";
			
		}else if(com!=null && com.equals("insert")) {
			if(contentType!=null && contentType.toLowerCase().startsWith("multipart/")) {
				uploadfile(request,response);
			}
			String id = request.getParameter("id");
			String name = request.getParameter("name");
			String pwd = request.getParameter("pwd");
			
			MemberDTO dto = new MemberDTO(id, name, pwd, photo);
			MemberDAO dao = new MemberDAO();
			dao.insert(dto);
			viewPage = "list.do";
			
		}else if(com!=null && com.equals("list")) {
			MemberDAO dao = new MemberDAO();
			ArrayList<MemberDTO> dtos = dao.list();
			request.setAttribute("dtos", dtos);
			viewPage = "list.jsp";
			
		}else if(com!=null && com.equals("get")) {
			String id = request.getParameter("id");
			MemberDTO dto = new MemberDTO();
			MemberDAO dao = new MemberDAO();
			
			dto = dao.get(id);
			request.setAttribute("dto", dto);
			
			viewPage = "updateForm.jsp";
			
		}else if(com!=null && com.equals("update")) {
			String id = request.getParameter("id");
			String name = request.getParameter("name");
			String pwd = request.getParameter("pwd");
			photo = request.getParameter("photo");
			
			uploadfile(request,response);
			
			MemberDTO dto = new MemberDTO(id, name, pwd, photo);
			MemberDAO dao = new MemberDAO();
			dao.update(dto);
			viewPage = "list.do";
			
		}else if(com!=null && com.equals("delete")) {
			String id = request.getParameter("id");

			MemberDAO dao = new MemberDAO();
			dao.delete(id);
			viewPage = "list.do";
		}
		RequestDispatcher rd = request.getRequestDispatcher(viewPage);
		rd.forward(request, response);
	}
	
	private void uploadfile(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String dir = request.getServletContext().getRealPath("/photos");
		
		File f = new File(dir);
		if(!f.exists()) {
			f.mkdirs();
		}
		
		Collection<Part> parts = request.getParts();

		for(Part p : parts) {
			if(p.getHeader("Content-Disposition").contains("filename=")) {

				if(p.getSize()>0) {
					photo = p.getSubmittedFileName();
					filePath = dir + File.separator + photo;
					p.write(filePath);
					p.delete();
				}
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}