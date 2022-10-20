<%@page import="userinfo.UserInfoVO"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../Login/IsLoggedIn.jsp" %>
<%
request.setCharacterEncoding("utf-8");

String user_id = session.getAttribute("user_id").toString();
// UserInfoDAO uDao = new UserInfoDAO();
UserInfoDAO uDao = UserInfoDAO.getInstance();
UserInfoVO uVo = uDao.getUserInfoVO(user_id);
int user_code = uVo.getUser_code();
String user_name = uVo.getUser_name();
// uDao.close();
%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>전자결재 - 자료실 글쓰기</title>
</head>
<body>
<script>
function validateForm(form){
	if(!form.title.value){
		alert("제목을 입력하세요.");
		return false;
	}
	if(!form.content.value){
		alert("내용을 입력하세요.");
		return false;
	}
};

function deleteFile(){
	document.getElementById("attachedFile").value = "";
};
</script>
	<h2>글쓰기</h2>
	
	<form name="writeFrm" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);" action="EdmsFileWriteProcess.jsp">
	
	<input type="hidden" name="user_code" value="<%= user_code %>"/>
	<input type="hidden" name="cate" value="3"/>
	
	<table class="table table-hover" width="90%">
		<tr>
			<td width="15%" style="vertical-align:middle;">작성자</td>
			<td>
				<input type="text" class="form-control" name="user_name" value="<%= user_name %>" style="width:90%;" readonly/>
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
				<input type="file" class="form-control" id="attachedFile" name="attachedFile" style="width:100%;"/>
			</div>
			<div class="form-group" style="float:left;">
				<Button type="button" class="btn btn-dark" id="deleteFileBtn" name="deleteFileBtn" onclick="deleteFile();">업로드 취소</Button>
			</div>
			</td>
		<tr>
		</tr>
			<td width="15%" style="vertical-align:middle;">내용</td>
			<td>
				<textarea class="form-control" name="content" style="width: 100%; height: 300px;"></textarea>
			</td>
		</tr>
	</table>
	
	<table class="table table-hover" width="90%">
		<tr>
			<td align="center" style="border-bottom:none;">
				<input type="submit" class="btn btn-primary" name="submitValue" value="작성완료"/>
				<button type="reset" class="btn btn-primary">다시 입력</button>
				<button type="button" class="btn btn-primary" onclick="location.href='EdmsFileList.jsp';">목록 보기</button>
			</td>
		</tr>
	</table>
	
	</form>
	
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>