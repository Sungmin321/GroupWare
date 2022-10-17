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
uDao.close();

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
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>메일쓰기</title>
</head>
<body>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript">
var childWindow = null;

window.onload = function(){
	var status = <%=request.getParameter("status")%>;
	var fileName = "<%=fVo.getOfile()%>";
	
	if(status == 4 && fileName != null && fileName != "null"){
		console.log("if문 실행");
		$('#attachedFile').hide();
		$('#deleteFileBtn').hide();
	}

	var childValue = " " + <%= request.getParameter("recipientsValue") %> + " ";

	if(childValue != null && childValue != " null "){
		var str = childValue.trim();
		var sliceStr = "";
		for(var i=1; i<=str.length/9; i++){
			if(i == str.length/9){
				sliceStr += str.slice((i-1)*9, i*9);
			}else{
				sliceStr += str.slice((i-1)*9, i*9);
				sliceStr += ",";
			}
		}
		if(status == 1){
			document.getElementById('recipients1').value = sliceStr;
		}else if(status == 4){
			document.getElementById('recipients4').value = sliceStr;
		}
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

function search_btn(){
	childWindow = window.open("<%= request.getContextPath() %>/mail/AddRecipient.jsp?status=<%= request.getParameter("status")%>", "받는사람 추가", "width=600, height=550");
};

</script>

	<h3>메일쓰기</h3>
	
	<input type="hidden" id="childSelected" name="childSelected"/>

	<form name="writeFrm" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);" action="MailWriteProcess.jsp">

	<table class="table table-hover" width="90%">
		<tr>
			<td style="border-bottom:none;">
				<input type="hidden" name="statusValue" value="<%= request.getParameter("status") %>"/>
				<input type="hidden" name="idxValue" value="<%= request.getParameter("idx")%>"/>
				<input type="submit" class="btn btn-primary" name="submitValue" value="보내기"/>
				<input type="submit" class="btn btn-primary" name="submitValue" value="임시저장"/>
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
	<table class="table table-hover" width="90%">
		<tr>
			<td width="15%" style="vertical-align:middle;">보내는사람</td>
			<td>
				<input type="text" class="form-control" name="sender" value="<%= user_code %>" style="width: 30%;" readonly/>
			</td>
		</tr>
		<tr>
			<td width="15%" style="vertical-align:middle;">받는사람</td>
			<td width="85%">
			<div class="form-group" style="float:left; margin-right:10px; width=50%;">
				<input type="text" class="form-control" name="recipients1" id="recipients1" style="width: 100%;" readonly/>
			</div>
			<div class="form-group" style="float:left;">
				<input type="button" class="btn btn-dark" value="찾기" onclick="search_btn();"/>
			</div>
			</td>
		</tr>
		<tr>
			<td width="15%" style="vertical-align:middle;">제목</td>
			<td>
				<input type="text" class="form-control" name="title" style="width: 90%;"/>
			</td>
		</tr>
		<tr>
			<td width="15%" style="vertical-align:middle;">첨부파일</td>
			<td width="85%">
			<div class="form-group" style="float:left; margin-right:10px;">
				<input type="file" class="form-control" id="attachedFile" name="attachedFile" style="width: 100%;"/>
			</div>
			<div class="form-group" style="float:left;">
				<Button type="button" class="btn btn-dark" id="deleteFileBtn" name="deleteFileBtn" onclick="deleteFile();">업로드 취소</Button>
			</div>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<textarea class="form-control" name="content" style="width: 100%; height: 300px;"></textarea>
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
	<table class="table table-hover" width="90%">
		<tr>
			<td width="15%" style="vertical-align:middle;">보내는사람</td>
			<td>
				<input type="text" class="form-control" name="sender" value="<%= vo.getSender() %>" style="width: 30%;" readonly/>
			</td>
		</tr>
		<tr>
			<td width="15%" style="vertical-align:middle;">받는사람</td>
			<td width="85%">
			<div class="form-group" style="float:left; margin-right:10px; width=50%;">
				<input type="text" class="form-control" name="recipients4" id="recipients4" value="<%= vo.getRecipients() %>" style="width: 100%;" readonly/>
			</div>
			<div class="form-group" style="float:left;">
				<input type="button" class="btn btn-dark" value="찾기" onclick="search_btn();"/>
			</div>
			</td>
		</tr>
		<tr>
			<td width="15%" style="vertical-align:middle;">제목</td>
			<td>
				<input type="text" class="form-control" name="title" value="<%= vo.getTitle() %>" style="width: 90%;"/>
			</td>
		</tr>
		<tr>
			<td width="15%" style="vertical-align:middle;">첨부파일</td>
			<td width="85%">
<%
	if(fVo.getOfile() != null){
%>
			<div class="form-group" style="float:left; margin-right:10px; width=50%;">
				<input type="text" class="form-control" id="fileName" name="fileName" value="<%= fVo.getOfile() %>" readonly/>
			</div>
			<div class="form-group" style="float:left; margin-right:10px; width=20%;">
				<input type="button" class="btn btn-dark" id="upload_btn" name="upload_btn" value="다시 업로드" onclick="btn_click();"/>
			</div>
			<div class="form-group" style="float:left; width=10%;">
				<input type="button" class="btn btn-dark" id="delete_btn" name="delete_btn" value="삭제" onclick="delete_btn_click();"/>
			</div>
			<div class="form-group" style="float:left; width=20%;">
			</div>
<%
	}
%>
			<div class="form-group" style="float:left; margin-right:10px;">
				<input type="file" class="form-control" id="attachedFile" name="attachedFile" style="width: 100%;"/>
			</div>
			<div class="form-group" style="float:left;">
				<Button type="button" class="btn btn-dark" id="deleteFileBtn" name="deleteFileBtn" onclick="deleteFile();">업로드 취소</Button>
			</div>
			</td>
		</tr>
		<tr>
			<td colspan="2">
<%
	if(vo.getContent() != null){
%>
				<textarea class="form-control" name="content" style="width: 100%; height: 300px;"><%= vo.getContent().replace("\r\n", "<br/>") %></textarea>
<%
	}else{
%>
				<textarea class="form-control" name="content" style="width: 100%; height: 300px;"></textarea>
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