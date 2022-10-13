<%@page import="userinfo.UserInfoVO"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");

String user_id = session.getAttribute("user_id").toString();
UserInfoDAO uDao = new UserInfoDAO();
UserInfoVO uVo = uDao.getUserInfoVO(user_id);
int user_code = uVo.getUser_code();
String user_name = uVo.getUser_name();
uDao.close();
%>
<!DOCTYPE html>
<html>
<head>
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
	
	<table border="1" width="90%">
		<tr>
			<td width="15%">작성자</td>
			<td>
				<input type="text" name="user_name" value="<%= user_name %>" style="width:90%;" readonly/>
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
			<td width="15%">내용</td>
			<td>
				<textarea name="content" style="width: 100%; height: 300px;"></textarea>
			</td>
		</tr>
	</table>
	
	<table width="90%">
		<tr>
			<td align="center">
				<input type="submit" name="submitValue" value="작성완료"/>
				<button type="reset">다시 입력</button>
				<button type="button" onclick="location.href='EdmsFileList.jsp';">목록 보기</button>
			</td>
		</tr>
	</table>
	
	</form>
	
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>