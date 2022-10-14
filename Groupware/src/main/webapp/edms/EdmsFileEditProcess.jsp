<%@page import="java.io.File"%>
<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="attachedfile.AttachedFileVO"%>
<%@page import="board.BoardDAO"%>
<%@page import="board.BoardVO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");

// String saveDirectory = application.getRealPath("/Uploads");
String saveDirectory = "C:/Program Files/Apache Software Foundation/Tomcat 9.0/webapps/ROOT/Uploads";
int maxPostSize = 1024 * 1000 * 10; // 10MB
String encoding = "UTF-8";

MultipartRequest mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding);

// board2 테이블 update
String title = mr.getParameter("title");
String content = mr.getParameter("content");
String idx = mr.getParameter("idx");

BoardVO bVo = new BoardVO();
bVo.setTitle(title);
bVo.setContent(content);

String edmsFile = "";
// BoardDAO bDao = new BoardDAO(edmsFile);
BoardDAO bDao = BoardDAO.getInstance();
int edmsResult = bDao.updateEdit(bVo, idx);

if(edmsResult == 1){

}else{
%>
<script>
	alert("게시물 수정에 실패하였습니다.");
	history.back();
</script>
<%
}



// attachedFile 테이블 insert
String ofile = mr.getFilesystemName("attachedFile");
String fileName = mr.getParameter("fileName");

int fileResult = 0;
int fileIdx = Integer.parseInt(idx);

AttachedFileVO fVo = new AttachedFileVO();
AttachedFileDAO fDao = new AttachedFileDAO();

if(fDao.selectView(fileIdx).getOfile() != null){ // 기존 첨부파일이 있을때
	if((fileName == null || fileName.equals("") || fileName.equals("null"))){ // 유 -> 무 (삭제 - delete) V
		fileResult = fDao.delete(fileIdx);
	}else if (ofile != null) { // 유 -> 유 (수정 있음 - update) V
		try {
			String ext = ofile.substring(ofile.lastIndexOf("."));
			String sfile = idx + ext; // 새로운 파일 이름("idx.확장자")

			File oldFile = new File(saveDirectory + File.separator + ofile);
			File newFile = new File(saveDirectory + File.separator + sfile);
			oldFile.renameTo(newFile);

			fVo.setIdx(fileIdx);
			fVo.setOfile(ofile);
			fVo.setSfile(sfile);

			fileResult = fDao.update(fVo);

		} catch (Exception e) {
			e.printStackTrace();
		}
	} else if (fileName != null && (ofile == null || ofile.equals("") || ofile.equals("null"))) { // 유 -> 유 (수정 없음 - 아무것도 수행하지않음) V
	
	}

} else if (fDao.selectView(fileIdx).getOfile() == null) { // 기존 첨부파일이 없을때
	if (ofile == null || ofile.equals("") || ofile.equals("null")) { // 무 -> 무 (아무것도 수행하지않음) V
	
	}else if (ofile != null) { // 무 -> 유 (추가 - insert)
		try {
			String ext = ofile.substring(ofile.lastIndexOf("."));
			String sfile = idx + ext; // 새로운 파일 이름("idx.확장자") V

			File oldFile = new File(saveDirectory + File.separator + ofile);
			File newFile = new File(saveDirectory + File.separator + sfile);
			oldFile.renameTo(newFile);

			fVo.setIdx(fileIdx);
			fVo.setOfile(ofile);
			fVo.setSfile(sfile);

			fileResult = fDao.inputFile(fVo);

		} catch (Exception e) {
			e.printStackTrace();
		}
	} 
}

// bDao.close();
fDao.close();

if (ofile == null) { // 첨부파일이 없는 경우
%>
<script>
	alert("수정되었습니다.");
	location.href = "EdmsFileList.jsp";
// 	response.sendRedirect("EdmsFileList.jsp");
</script>
<%
}else if(ofile != null && fileResult == 1){ // 첨부파일이 있고 업로드 성공한 경우
%>
<script>
	alert("수정되었습니다.");
	location.href = "EdmsFileList.jsp";
// 	response.sendRedirect("EdmsFileList.jsp");
</script>
<%
}else{	
%>
<script>
	alert("파일 업로드에 실패하였씁니다.");
	history.back();
</script>
<%
}
%>