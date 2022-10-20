<%@page import="java.io.File"%>
<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="attachedfile.AttachedFileVO"%>
<%@page import="board.BoardVO"%>
<%@page import="board.BoardDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../Login/IsLoggedIn.jsp" %>
<%
request.setCharacterEncoding("utf-8");

// String saveDirectory = application.getRealPath("/Uploads");
String saveDirectory = "C:/Program Files/Apache Software Foundation/Tomcat 9.0/webapps/ROOT/Uploads";
int maxPostSize = 1024 * 1000 * 10; // 10MB
String encoding = "UTF-8";

MultipartRequest mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding);

// board2 테이블 insert
String cate = mr.getParameter("cate");
String user_code = mr.getParameter("user_code");
String title = mr.getParameter("title");
String content = mr.getParameter("content");

BoardVO bVo = new BoardVO();
bVo.setCate(cate);
bVo.setUsercode(user_code);
bVo.setTitle(title);
bVo.setContent(content);

String edmsFile = "";
// BoardDAO bDao = new BoardDAO(edmsFile);
BoardDAO bDao = BoardDAO.getInstance();
int edmsResult = bDao.insertWrite(bVo);


if(edmsResult == 1){

}else{
%>
<script>
	alert("글쓰기에 실패하였습니다.");
	history.back();
</script>
<%
}



// attachedFile 테이블 insert
String ofile = mr.getFilesystemName("attachedFile");

int fileResult = 0;

if(ofile != null){ // 첨부파일이 있을때
	int idx = 0; // 위에서 borad2 테이블에 insert할때 생성된 idx값을 구한다
	idx = bDao.getLastIdx();
	
	AttachedFileVO fVo = new AttachedFileVO();
// 	AttachedFileDAO fDao = new AttachedFileDAO();
	AttachedFileDAO fDao = AttachedFileDAO.getInstance();
	
	try {
		String ext = ofile.substring(ofile.lastIndexOf("."));
		String sfile = idx + ext; // 새로운 파일 이름("idx.확장자")
		
		File oldFile = new File(saveDirectory + File.separator + ofile);
		File newFile = new File(saveDirectory + File.separator + sfile);
		oldFile.renameTo(newFile);

		fVo.setIdx(idx);
		fVo.setOfile(ofile);
		fVo.setSfile(sfile);
		
		fileResult = fDao.inputFile(fVo);
// 		fDao.close();
		
	} catch (Exception e) {
		e.printStackTrace();
	}
}

// bDao.close();

if(ofile == null){ // 첨부파일이 없는 경우
%>
<script>
	alert("등록되었습니다.");
	location.href = "EdmsFileList.jsp";
// 	response.sendRedirect("EdmsFileList.jsp");
</script>
<%
}else if(ofile != null && fileResult == 1){ // 첨부파일이 있고 업로드 성공한 경우
%>
<script>
	alert("등록되었습니다.");
	location.href = "EdmsFileList.jsp";
// 	response.sendRedirect("EdmsFileList.jsp");
</script>
<%
}else{	
%>
<script>
	alert("파일 업로드에 실패하였습니다.");
	history.back();
</script>
<%
}
%>