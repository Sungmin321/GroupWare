<%@page import="attachedfile.AttachedFileVO"%>
<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="board.BoardVO"%>
<%@page import="board.BoardDAO"%>
<%@page import="userinfo.UserInfoVO"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<%-- 	<input type="hidden" name="user_code" value="<%= user_code %>"/> --%>
<!-- 	<input type="hidden" name="cate" value="3"/> -->
	
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
			<td width="15%">내용</td>
			<td>
				<textarea name="content" style="width: 100%; height: 300px;"><%= vo.getContent() %></textarea>
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