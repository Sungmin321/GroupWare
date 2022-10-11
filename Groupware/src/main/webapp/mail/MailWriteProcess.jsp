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
// 첨부파일 처리할 idx를 저장할 변수
int idx1 = 0; // status = 1일떄 idx
int idx3 = 0; // status = 3일떄 idx
int idx4 = 0; // status = 4일떄 idx

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
String idxValue = mr.getParameter("idxValue");

int idx = 0;
if(idxValue != null && !idxValue.equals("") && !idxValue.equals("null")){
// 	System.out.println("idxValue != null");
// 	System.out.println(mr.getParameter("idxValue"));
	System.out.println("idxValue : " + idxValue);
	
	idx = Integer.parseInt(mr.getParameter("idxValue"));
}
String fileName = mr.getParameter("fileName");
// System.out.println("fileName : " + fileName);

int status = Integer.parseInt(mr.getParameter("statusValue"));
// System.out.println("Process page status : " + status);

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

if(submitValue.equals("보내기") && status == 1 && (content != null && !content.equals(""))){
	System.out.println("if문");
	vo.setStatus(3);
	result = dao.inputMail(vo);
	idx3 = dao.getLastIdx();
// 	System.out.println("idx3 : " + idx3);
	if(result == 1){
		vo.setStatus(1);
		result = dao.inputMail(vo);
		idx1 = dao.getLastIdx();
// 		System.out.println("idx1 : " + idx1);
	}
	
}else if(submitValue.equals("보내기") && status == 1 && (content == null || content.equals(""))){
	System.out.println("첫번째 else if문");
	vo.setStatus(3);
	result = dao.inputMailContentNull(vo);
	idx3 = dao.getLastIdx();
// 	System.out.println("idx3 : " + idx3);
	if(result == 1){
		vo.setStatus(1);
		result = dao.inputMailContentNull(vo);
		idx1 = dao.getLastIdx();
// 		System.out.println("idx1 : " + idx1);
	}
	
}else if(submitValue.equals("보내기") && status == 4 && (content != null && !content.equals(""))){
	System.out.println("두번째 else if문");
	vo.setIdx(idx);
	vo.setStatus(3);
	result = dao.update(vo);
	idx3 = idx;
// 	System.out.println("idx3 : " + idx3);
	if(result == 1){
		vo.setStatus(1);
		result = dao.inputMail(vo);
		idx1 = dao.getLastIdx();
// 		System.out.println("idx1 : " + idx1);
	}

}else if(submitValue.equals("보내기") && status == 4 && (content == null || content.equals(""))){
	System.out.println("세번째 else if문");
	vo.setIdx(idx);
	vo.setStatus(3);
	result = dao.updateContentNull(vo);
	idx3 = idx;
// 	System.out.println("idx3 : " + idx3);
	if(result == 1){
		vo.setStatus(1);
		result = dao.inputMailContentNull(vo);
		idx1 = dao.getLastIdx();
// 		System.out.println("idx1 : " + idx1);
	}
	
}else if(submitValue.equals("임시저장") && status == 1 && (content != null && !content.equals(""))){
	System.out.println("네번째 else if문");
	vo.setStatus(4);
	result = dao.inputMail(vo);
	idx4 = dao.getLastIdx();
// 	System.out.println("idx4 : " + idx4);

}else if(submitValue.equals("임시저장") && status == 1 && (content == null || content.equals(""))){
	System.out.println("다섯번째 else if문");
	vo.setStatus(4);
	result = dao.inputMailContentNull(vo);
	idx4 = dao.getLastIdx();
// 	System.out.println("idx4 : " + idx4);
	
}else if(submitValue.equals("임시저장") && status == 4 && (content != null && !content.equals(""))){
	System.out.println("여섯번째 else if문");
	vo.setStatus(4);
	vo.setIdx(idx);
	result = dao.update(vo);
	idx4 = dao.getLastIdx();
// 	System.out.println("idx4 : " + idx4);
	
}else if(submitValue.equals("임시저장") && status == 4 && (content == null || content.equals(""))){
	System.out.println("일곱번째 else if문");
	vo.setStatus(4);
	vo.setIdx(idx);
	result = dao.updateContentNull(vo);
	idx4 = dao.getLastIdx();
// 	System.out.println("idx4 : " + idx4);
}

dao.close();

if(result == 1){

}else{
%>
<script>
	alert("메일 전송에 실패하였습니다.");
	history.back();
</script>
<%
}



//file input
int uploadFileResult = 0;

AttachedFileVO fVo = new AttachedFileVO();
AttachedFileDAO fDao = new AttachedFileDAO();

// int newIdx = 0;
// newIdx = dao.getLastIdx(); // 위에서 시퀀스로 생성된 idx 값 가져오기
// dao.close();

int fileIdx = 0; // idx1 또는 idx3 또는 idx4의 값을 대입

if(ofile != null){
	System.out.println("ofile != null");
	boolean insertIdx1 = false;
	if(submitValue.equals("보내기") && status == 1){ // insert(idx3) & insert(idx1)
		System.out.println("첨부파일 if문");
		System.out.println("idx3 : " + idx3);
		fileIdx = idx3;
		insertIdx1 = true;
	}else if(submitValue.equals("보내기") && status == 4){ // update or insert(idx3) & insert(idx1)
		System.out.println("첨부파일 첫번째 else if문");
		System.out.println("idx3 : " + idx3);
		fileIdx = idx3;
		insertIdx1 = true;
	}else if(submitValue.equals("임시저장") && status == 1){ // updqte or insert(idx4)
		System.out.println("첨부파일 두번째 else if문");
		System.out.println("idx4 : " + idx4);
		fileIdx = idx4;
	}else if(submitValue.equals("임시저장") && status == 4){ // update or insert(idx4)
		System.out.println("첨부파일 세번째 else if문");
		System.out.println("idx4 : " + idx4);
		fileIdx = idx4;
	}

	try {
		String ext = ofile.substring(ofile.lastIndexOf("."));
		// 조건 1 (idx 1 or idx 3 or idx 4)
		String sfile = fileIdx + ext; // 새로운 파일 이름("idx.확장자")
		//
		
		File oldFile = new File(saveDirectory + File.separator + ofile);
		File newFile = new File(saveDirectory + File.separator + sfile);
		oldFile.renameTo(newFile);

		// 조건 2 (idx 1 or idx 3 or idx 4)
		fVo.setIdx(fileIdx);
		//
		fVo.setOfile(ofile);
		fVo.setSfile(sfile);

		// 조건 3 (insert or updqte)
		if(fDao.selectView(fileIdx) == null){
			System.out.println("fDao.selectView(fileIdx) == null)");
		}
		
		if(fDao.selectView(fileIdx).getOfile() != null){ // db에 첨부파일이 이미 있을때
			System.out.println("fDao.selectView(fileIdx) != null");
			uploadFileResult = fDao.update(fVo);
		}else{ /// db에 첨부파일이 없을때
			System.out.println("fDao.selectView(fileIdx) == null");
			uploadFileResult = fDao.inputFile(fVo);
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	if(insertIdx1 == true){
		System.out.println("insertIdx1 == true if문 실행");
		System.out.println("idx1 : " + idx1);
		fileIdx = idx1;
		try {
			String ext = ofile.substring(ofile.lastIndexOf("."));
			String sfile = fileIdx + ext; // 새로운 파일 이름("idx.확장자")
			
			File oldFile = new File(saveDirectory + File.separator + ofile);
			File newFile = new File(saveDirectory + File.separator + sfile);
			oldFile.renameTo(newFile);

			fVo.setIdx(fileIdx);
			fVo.setOfile(ofile);
			fVo.setSfile(sfile);

			uploadFileResult = fDao.inputFile(fVo);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		insertIdx1 = false;
	}
	
}else{ // ofile == null
	System.out.println("ofile == null");
	if(submitValue.equals("보내기") && status == 4){
		if(fileName == null || fileName.equals("") || fileName.equals("null")){
			System.out.println("ofile == null 의 if문");
			System.out.println("idx3 : " + idx3);
			fileIdx = idx3;
			uploadFileResult = fDao.delete(fileIdx);
		}
	}else if(submitValue.equals("임시저장") && status == 4){
		if(fileName == null || fileName.equals("") || fileName.equals("null")){
			System.out.println("ofile == null 의 else if문");
			System.out.println("idx4 : " + idx4);
			fileIdx = idx4;
			uploadFileResult = fDao.delete(fileIdx);
		}
	}
}

fDao.close();



if(submitValue.equals("보내기")){
	status = 2; // 보낸메일함으로 가기 위해 status 2로 변경
}else if(submitValue.equals("임시저장")){
	status = 4; // 임시보관함으로 가기 위해 status 4로 변경
}
request.setAttribute("idx", idxValue);
request.setAttribute("idx4", idx4);
request.setAttribute("status", status);
request.setAttribute("submitValue", submitValue);

// System.out.println("Process Page Changed status : " + status);


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