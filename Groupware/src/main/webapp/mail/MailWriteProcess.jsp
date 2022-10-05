<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="attachedfile.AttachedFileVO"%>
<%@page import="mail.MailDAO"%>
<%@page import="mail.MailVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%
// mail input
request.setCharacterEncoding("utf-8");

// Request와 MultipartRequest 객체를 동시에 사용할 수 없으므로 MultipartRequest 객체 생성
String saveDirectory = application.getRealPath("/Uploads");
int maxPostSize = 1024 * 1000 * 10; // 10MB
String encoding = "UTF-8";

MultipartRequest mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding);

String ofile = mr.getFilesystemName("attachedFile");
String submitValue = mr.getParameter("submitValue"); // 보내기 or 임시저장
String title = mr.getParameter("title");
String content = mr.getParameter("content");
String sender = mr.getParameter("sender");
String recipients = mr.getParameter("recipients");

int status = Integer.parseInt(mr.getParameter("statusValue"));

// int status = 0;
// if(submitValue.equals("보내기")){
// 	status = 1; // 안 읽은 메일
// }else if(submitValue.equals("임시저장")){
// 	status = 4; // 임시보관 메일
// }

MailVO vo = new MailVO();

vo.setTitle(title);
if(content != null){
	vo.setContent(content);
}
vo.setStatus(status);
vo.setSender(sender);
vo.setRecipients(recipients);

MailDAO dao = new MailDAO();

int result = 0;

// if(content != null){
// 	result = dao.inputMail(vo);	
// }else{
// 	result = dao.inputMailContentNull(vo);
// }

if(submitValue.equals("보내기") && status == 1 && content != null){
	result = dao.inputMail(vo);
	if(result == 1){
		vo.setStatus(3);
		result = dao.inputMail(vo);
	}
	
}else if(submitValue.equals("보내기") && status == 1 && content == null){
	result = dao.inputMailContentNull(vo);
	if(result == 1){
		vo.setStatus(3);
		result = dao.inputMailContentNull(vo);
	}
	
}else if(submitValue.equals("보내기") && status == 4 && content != null){
	result = dao.update(vo);
	if(result == 1){
		vo.setStatus(3);
		result = dao.inputMail(vo);
	}

}else if(submitValue.equals("보내기") && status == 4 && content == null){
	result = dao.updateContentNull(vo);
	if(result == 1){
		vo.setStatus(3);
		result = dao.inputMailContentNull(vo);
	}
	
}else if(submitValue.equals("임시저장") && status == 1 && content != null){
	vo.setStatus(4);
	result = dao.inputMail(vo);

}else if(submitValue.equals("임시저장") && status == 11 && content == null){
	vo.setStatus(4);
	result = dao.inputMailContentNull(vo);
	
}else if(submitValue.equals("임시저장") && status == 4 && content != null){
	vo.setStatus(4);
	result = dao.update(vo);
	
}else if(submitValue.equals("임시저장") && status == 41 && content == null){
	vo.setStatus(4);
	result = dao.updateContentNull(vo);
}

if(result == 1){
	if(submitValue.equals("보내기")){
		status = 2; // 보낸메일함으로 가기 위해 status 2로 변경
	}else if(submitValue.equals("임시저장")){
		status = 4; // 임시보관함으로 가기 위해 status 4로 변경
	}	
	request.setAttribute("status", status);
	request.setAttribute("submitValue", submitValue);
}else{
%>
<script>
	alert("메일 전송에 실패하였습니다.");
	history.back();
</script>
<%
}

// file input
int uploadFileResult = 0;

if(ofile != null){
	int idx = dao.getFileIdx(); // 위에서 시퀀스로 생성된 idx 값 가져오기
	dao.close();

	try {
		String ext = ofile.substring(ofile.lastIndexOf("."));
		String sfile = idx + ext; // 새로운 파일 이름("idx.확장자")

		File oldFile = new File(saveDirectory + File.separator + ofile);
		File newFile = new File(saveDirectory + File.separator + sfile);
		oldFile.renameTo(newFile);

		AttachedFileVO fVo = new AttachedFileVO();
		fVo.setIdx(idx);
		fVo.setOfile(ofile);
		fVo.setSfile(sfile);

		AttachedFileDAO fDao = new AttachedFileDAO();
		uploadFileResult = fDao.inputFile(fVo);
		fDao.close();

	} catch (Exception e) {
		e.printStackTrace();
	}
}

if (ofile == null) { // 첨부파일이 없는 경우
	request.getRequestDispatcher("MailWriteSuccess.jsp").forward(request, response);
} else if (ofile != null && uploadFileResult == 1) { // 첨부파일이 있고 업로드 성공한 경우
	request.getRequestDispatcher("MailWriteSuccess.jsp").forward(request, response);
} else { // 첨부파일이 있고 업로드 실패한 경우
%>
<script>
	alert("파일 업로드에 실패하였습니다.");
	history.back();
</script>
<% 
}
%>