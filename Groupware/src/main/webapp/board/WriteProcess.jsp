<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.apache.catalina.tribes.util.Arrays"%>
<%@page import="board.*"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="attachedfile.AttachedFileVO"%>
<%@ include file="../Login/IsLoggedIn.jsp" %>
<% 
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	BoardDAO dao = BoardDAO.getInstance();
	
	String saveDirectory = application.getRealPath("/Uploads");
	
	int maxPostSize = 1024 * 1000 * 10; // 10MB
	String encoding = "UTF-8";
	
	MultipartRequest multipartrequest = new MultipartRequest(request, saveDirectory, maxPostSize, encoding);
	
	String ofile = multipartrequest.getFilesystemName("ofile");
	//폼값 받기
	String title = multipartrequest.getParameter("title");
	String content = multipartrequest.getParameter("content");

	// 폼값을 VO 객체에 저장
	BoardVO vo = new BoardVO();
	vo.setTitle(title);
	vo.setContent(content);
	vo.setUsercode(session.getAttribute("user_code").toString());
	vo.setCate(session.getAttribute("cate").toString());
	
//DAO 객체를 통해 DB에 DTO 저장
int iResult = dao.insertWrite(vo);

// 성공 or 실패?
if (iResult == 1) {
	
	if(ofile == null){ //파일첨부가 안되있으면.
		
	%>
	<script>
		alert('글이 작성되었습니다.');
		location.href= "List.jsp";
	</script>
	<%
	
	}
	
	int uploadFileResult = 0;
	int idx = dao.getIdx(vo);
	if(ofile != null ){
	// 파일이 있다면 파일까지 첨부하기.
	
		try{
			
			String ext = ofile.substring(ofile.lastIndexOf("."));
			String sfile = idx + ext; // 새로운 파일 이름("idx.확장자")

			File oldFile = new File(saveDirectory + File.separator + ofile);
			File newFile = new File(saveDirectory + File.separator + sfile);
			oldFile.renameTo(newFile);

			AttachedFileVO fVo = new AttachedFileVO();
			fVo.setIdx(idx);
			fVo.setOfile(ofile);
			fVo.setSfile(sfile);

// 			AttachedFileDAO fDao = new AttachedFileDAO();
			AttachedFileDAO fDao = AttachedFileDAO.getInstance();
			uploadFileResult = fDao.inputFile(fVo);
// 			fDao.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	 	//	request.getRequestDispatcher("EdmsList.jsp").forward(request, response);
	} 
	if (ofile != null && uploadFileResult == 1){ // 첨부파일이 있고 업로드 성공한 경우
		//request.getRequestDispatcher("EdmsList.jsp").forward(request, response);
		%>
		<script>
			alert("글이 작성되었습니다.(file)");
			location.href= "List.jsp";
			</script>
		<%
		//response.sendRedirect("EdmsList.jsp");
	}else {
		%>
		<script>
			alert("파일업로드실패");
			location.href= "List.jsp";
		</script>
		<%
	}
}
else{
	%>
	<script>
	alert('글쓰기가 실패하였습니다.');
	location.href= "Write.jsp";
	</script>
	<%
	}
%>
