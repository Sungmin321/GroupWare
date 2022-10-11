<%@ include file="../Sidebar1.jsp" %>
<%@page import="attachedfile.AttachedFileVO"%>
<%@page import="attachedfile.AttachedFileDAO"%>
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
System.out.println("write 페이지 14행 status : " + status);

// status == 1
String user_id = session.getAttribute("user_id").toString();
UserInfoDAO uDao = new UserInfoDAO();
UserInfoVO uVo = uDao.getUserInfoVO(user_id);
int user_code = uVo.getUser_code();

// status == 4
int idx = 0;
if(status == 4){
	idx = Integer.parseInt(request.getParameter("idx"));
}
MailDAO dao = new MailDAO();	
MailVO vo = dao.selectView(idx);

AttachedFileDAO fDao = new AttachedFileDAO();
AttachedFileVO fVo = fDao.selectView(idx);

fDao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메일쓰기</title>
</head>
<body>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript">
window.onload = function(){
	var status = <%=request.getParameter("status")%>;
	var fileName = "<%=fVo.getOfile()%>";
	
	if(status == 4 && fileName != null && fileName != "null"){
		console.log("if문 실행");
		$('#attachedFile').hide();
		$('#deleteFileBtn').hide();
	}
};

function btn_click(){
	$('#upload_btn').hide();
	$('#fileName').hide();
	$('#delete_btn').hide();
	$('#attachedFile').show();
	$('#deleteFileBtn').show();
	document.getElementById("attachedFile").value = "아무 의미 없는 값";
};
</script>

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

function delete_btn_click(){
	document.getElementById("fileName").value = "";
};

</script>

	<h2>메일쓰기</h2>

	<form name="writeFrm" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);" action="MailWriteProcess.jsp">

	<table width="90%">
		<tr>
			<td>
				<input type="hidden" name="statusValue" value="<%= request.getParameter("status") %>"/>
				<input type="hidden" name="idxValue" value="<%= request.getParameter("idx")%>"/>
				<input type="submit" name="submitValue" value="보내기"/>
				<input type="submit" name="submitValue" value="임시저장"/>
			</td>
		</tr>
	</table>
	
<%
if(status == 1){ // 메일쓰기 버튼을 클릭하여 처음 메일을 작성하는 경우
// 	String user_id = session.getAttribute("user_id").toString();
// 	UserInfoDAO uDao = new UserInfoDAO();
// 	UserInfoVO uVo = uDao.getUserInfoVO(user_id);
// 	int user_code = uVo.getUser_code();
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
}else if(status == 4){ // 임시보관함에서 메일보기로 넘어온 경우
// 	int idx = Integer.parseInt(request.getParameter("idx"));
// 	MailDAO dao = new MailDAO();	
// 	MailVO vo = dao.selectView(idx);
// 	dao.close();
	
// 	AttachedFileDAO fDao = new AttachedFileDAO();
// 	AttachedFileVO fVo = fDao.selectView(idx);

// 	System.out.println("write 페이지 137행 idx : " + idx);
// 	System.out.println("fVo.getOfile() : " + fVo.getOfile());

// 	fDao.close();
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
<%
	if(fVo.getOfile() != null){
%>
				<input type="button" id="upload_btn" name="upload_btn" value="다시 업로드" onclick="btn_click();"/>
				<input type="button" id="delete_btn" name="delete_btn" value="삭제" onclick="delete_btn_click();"/>
				<input type="text" id="fileName" name="fileName" value="<%= fVo.getOfile() %>" readonly/>
<%
	}
%>
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
<%@ include file="../Sidebar2.jsp" %>