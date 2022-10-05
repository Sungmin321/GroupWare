<%@page import="userinfo.UserInfoDAO"%>
<%@page import="userinfo.UserInfoVO"%>
<%@page import="mail.MailVO"%>
<%@page import="mail.MailDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../Login/IsLoggedIn.jsp" %>    
<%
request.setCharacterEncoding("utf-8");

int status = Integer.parseInt(request.getParameter("status"));
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메일쓰기</title>
</head>
<body>

<script>
function validateForm(form){
	if(!form.sender.value){
		alert("보내는사람을 입력하세요.");
		return false;
	}
	if(!form.recipients.value){
		alert("받는사람을 한명 이상 입력하세요.");
		return false;
	}
	if(!form.title.value){
		var result = confirm("제목이 없습니다. 제목 없이 메일을 발송하시겠습니까?");
		if(result){
			form.title.value = "제목없음";
		}else{
			return false;
		}
	}
};

function deleteFile(){
	document.getElementById("attachedFile").value = "";
};
</script>

	<h2>메일쓰기</h2>

	<form name="writeFrm" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);" action="MailWriteProcess.jsp">

	<table width="90%">
		<tr>
			<td>
				<input type="hidden" name="statusValue" value="<%= request.getParameter("status") %>"/>
				<input type="submit" name="submitValue" value="보내기"/>
				<input type="submit" name="submitValue" value="임시저장"/>
			</td>
		</tr>
	</table>
	
	
<%
if(status == 1){ // 메일쓰기 버튼을 클릭하여 처음 메일을 작성하는 경우
	String user_id = session.getAttribute("user_id").toString();
	UserInfoDAO uDao = new UserInfoDAO();
	UserInfoVO uVo = uDao.getUserInfoVO(user_id);
	int user_code = uVo.getUser_code();
%>
	<table border="1" width="90%">
		<tr>
			<td width="15%">보내는사람</td>
			<td>
				<input type="text" name="sender" value="<%= user_code %>" style="width: 90%;" readonly/>
			</td>
		</tr>
		<tr>
			<td width="15%">받는사람</td>
			<td>
				<input type="text" name="recipients" style="width: 90%;"/>
			</td>
		</tr>
		<tr>
			<td width="15%">제목</td>
			<td>
				<input type="text" name="title" style="width: 90%;"/>
			</td>
		</tr>
		<tr>
			<td width="15%">첨부파일</td>
			<td>
				<input type="file" id="attachedFile" name="attachedFile" style="width: 90%;"/>
				<Button type="button" id="deleteFileBtn" name="deleteFileBtn" onclick="deleteFile();">업로드 취소</Button>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<textarea name="content" style="width: 100%; height: 300px;"></textarea>
			</td>
		</tr>
	</table>
<%
}else if(status == 4){ // 임시보관함에서 상세보기로 넘어온 경우
	int idx = Integer.parseInt(request.getParameter("idx"));
	MailDAO dao = new MailDAO();	
	MailVO vo = dao.selectView(idx);
	dao.close();
%>
	<table border="1" width="90%">
		<tr>
			<td width="15%">보내는사람</td>
			<td>
				<input type="text" name="sender" value="<%= vo.getSender() %>" style="width: 90%;" readonly/>
			</td>
		</tr>
		<tr>
			<td width="15%">받는사람</td>
			<td>
				<input type="text" name="recipients" value="<%= vo.getRecipients() %>" style="width: 90%;"/>
			</td>
		</tr>
		<tr>
			<td width="15%">제목</td>
			<td>
				<input type="text" name="title" value="<%= vo.getTitle() %>" style="width: 90%;"/>
			</td>
		</tr>
		<tr>
			<td width="15%">첨부파일</td>
			<td>
				<input type="file" id="attachedFile" name="attachedFile" style="width: 90%;"/>
				<Button type="button" id="deleteFileBtn" name="deleteFileBtn" onclick="deleteFile();">업로드 취소</Button>
			</td>
		</tr>
		<tr>
			<td colspan="2">
<%
	if(vo.getContent() != null){
%>
				<textarea name="content" style="width: 100%; height: 300px;"><%= vo.getContent().replace("\r\n", "<br/>") %></textarea>
<%
	}else{
%>
				<textarea name="content" style="width: 100%; height: 300px;"></textarea>
<%
	}
%>			
			</td>
		</tr>
	</table>
<%
}
%>	
	</form>

</body>
</html>