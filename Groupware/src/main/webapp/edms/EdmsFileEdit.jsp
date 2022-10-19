<%@page import="attachedfile.AttachedFileVO"%>
<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="board.BoardVO"%>
<%@page import="board.BoardDAO"%>
<%@page import="userinfo.UserInfoVO"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../Login/IsLoggedIn.jsp" %> 
<%
request.setCharacterEncoding("utf-8");

//게시물 내용 가져오기
int idx = Integer.parseInt(request.getParameter("idx"));

String edmsFile = "";
// BoardDAO dao = new BoardDAO(edmsFile);
BoardDAO dao = BoardDAO.getInstance();
BoardVO vo = dao.selectView(idx);
// dao.close();

// id, 사원코드 정보 가져오기
String user_id = session.getAttribute("user_id").toString();
UserInfoDAO uDao = new UserInfoDAO();
UserInfoVO uVo = uDao.getUserInfoVO(user_id);
int user_code = uVo.getUser_code();
String user_name = uVo.getUser_name();
uDao.close();

//첨부파일 가져오기
AttachedFileDAO fDao = new AttachedFileDAO();
AttachedFileVO fVo = fDao.selectView(idx);

System.out.println("fVo.getOfile() : " + fVo.getOfile());

fDao.close();
%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>전자결재 - 게시글 수정</title>
</head>
<body>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript">
window.onload = function(){
	var fileName = "<%=fVo.getOfile()%>";
	
	if(fileName != null && fileName != "null"){
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

function delete_btn_click(){
	document.getElementById("fileName").value = "";
};
</script>
	<h2>수정하기</h2>
	
	<form name="writeFrm" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);" action="EdmsFileEditProcess.jsp">
	
	<input type="hidden" name="idx" value="<%= idx %>"/>
	
	<table class="table table-hover" width="90%">
		<tr>
			<td width="15%">작성자</td>
			<td>
				<input type="text" class="form-control" name="user_name" value="<%= user_name %>" style="width:90%;" readonly/>
			</td>
		</tr>
		<tr>
			<td width="15%">제목</td>
			<td>
				<input type="text" class="form-control" name="title" value="<%= vo.getTitle() %>" style="width: 90%;"/>
			</td>
		</tr>
		<tr>
			<td width="15%">첨부파일</td>
			<td>
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
			<td width="15%">내용</td>
			<td>
				<textarea class="form-control" name="content" style="width: 100%; height: 300px;"><%= vo.getContent() %></textarea>
			</td>
		</tr>
	</table>
	
	<table class="table table-hover" width="90%">
		<tr>
			<td align="center">
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