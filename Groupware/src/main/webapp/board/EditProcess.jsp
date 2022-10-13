<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.apache.catalina.tribes.util.Arrays"%>
<%@page import="board.*"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="attachedfile.AttachedFileVO"%>
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
	
	String idx = multipartrequest.getParameter("idx");
//DAO 객체를 통해 DB에 VO 저장
int iResult = dao.updateEdit(vo, idx);

// 성공 or 실패?
if (iResult == 1) {
	
	if(ofile == null){ //파일첨부가 안되있으면.
		
	%>
	<script>
		alert('글이 수정되었습니다.');
		location.href= "List.jsp";
	</script>
	<%
	
	}
	
	int uploadFileResult = 0;
	
	if(ofile != null ){
	// 파일이 있다면 파일까지 첨부하기.
	
		try{
			
			String ext = ofile.substring(ofile.lastIndexOf("."));
			String sfile = idx + ext; // 새로운 파일 이름("idx.확장자")

			File oldFile = new File(saveDirectory + File.separator + ofile);
			File newFile = new File(saveDirectory + File.separator + sfile);
			oldFile.renameTo(newFile);

			AttachedFileVO fVo = new AttachedFileVO();
			fVo.setIdx(Integer.parseInt(idx));
			fVo.setOfile(ofile);
			fVo.setSfile(sfile);
			
			//파일이 있는거면 업데이트를 하고 없는거면 새로 인서트를 넣어야된다.
			AttachedFileDAO fDao = new AttachedFileDAO();
			
			boolean flag = fDao.findFile(Integer.parseInt(idx));
			// 파일이 있으면 true가 반환되고, 없으면 false가 반환된다.
			if (flag){ //true 일때
				uploadFileResult = fDao.update(fVo);
			}else{
				uploadFileResult = fDao.inputFile(fVo);
			}
			fDao.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	 	//	request.getRequestDispatcher("EdmsList.jsp").forward(request, response);
	}else{
		AttachedFileDAO fDao = new AttachedFileDAO();
		fDao.delete(Integer.parseInt(idx));
		fDao.close();
	}
	
	if (ofile != null && uploadFileResult == 1){ // 첨부파일이 있고 업로드 성공한 경우
		//request.getRequestDispatcher("EdmsList.jsp").forward(request, response);
		%>
		<script>
			alert("글이 수정되었습니다.(file)");
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
	alert('글 수정에 실패하였습니다.');
	location.href= "Edit.jsp";
	</script>
	<%
	}
%>
