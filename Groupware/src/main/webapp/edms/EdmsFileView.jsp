<%@page import="java.net.URLEncoder"%>
<%@page import="attachedfile.AttachedFileVO"%>
<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="userinfo.UserInfoVO"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@page import="board.BoardVO"%>
<%@page import="board.BoardDAO"%>
<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");

// 수정하기, 삭제하기 버튼 접근 권한 확인
String user_id = session.getAttribute("user_id").toString();

UserInfoDAO iDao = new UserInfoDAO();
UserInfoVO iVo = iDao.getUserInfoVO(user_id);
String user_code = String.valueOf(iVo.getUser_code());

// 상세페이지 내용
int idx = Integer.parseInt(request.getParameter("idx"));

String edmsFile = "";
// BoardDAO dao = new BoardDAO(edmsFile);
BoardDAO dao = BoardDAO.getInstance();
dao.updateVisitCount(idx);
BoardVO vo = dao.selectView(idx);
// dao.close();

// 상세페이지 첨부파일
AttachedFileDAO fDao = new AttachedFileDAO();
AttachedFileVO fVo = fDao.selectView(idx);
// System.out.println("fVo.getOfile() : " + fVo.getOfile());
fDao.close();
%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>전자결재 - 자료실 상세보기</title>
</head>
<body>

<script>
function deletePost(){
	var confirmed = confirm("정말로 삭제하시겠습니까?");
	if(confirmed){
		var form = document.viewFrm;
		form.method = "post";
		form.action = "EdmsFileDeleteProcess.jsp";
		form.submit();
	}
};
</script>

	<h3>상세보기</h3>
	
	<form name="viewFrm">
	<input type="hidden" name="idx" value="<%= idx %>"/>
	<table class="table table-hover" width="90%">
		<tr>
			<td align="center" width="15%">작성자</td>
			<td><%= vo.getUser_name() %></td>
			<td align="center" width="15%">조회수</td>
			<td align="center"><%= vo.getVisitcount() %></td>
		</tr>
		<tr>
			<td align="center" width="15%">작성일자</td>
			<td colspan="3"><%= vo.getPostdate() %></td>
		</tr>
		<tr>
			<td align="center" width="15%">제목</td>
			<td colspan="3"><%= vo.getTitle() %></td>
		</tr>
<%
if(fVo.getOfile() != null){
%>
		<tr>
			<td align="center" width="15%">첨부파일</td>
			<td colspan="3" align="left"><a href="../attachedfile/Download.jsp?oName=<%= URLEncoder.encode(fVo.getOfile(), "UTF-8")%>&sName=<%= URLEncoder.encode(fVo.getSfile(), "UTF-8")%>"><%= fVo.getOfile() %></a></td>
		</tr>
<%
}
%>
		<tr>
			<td align="center" width="15%" height="300">내용</td>
			<td colspan="3"><%= vo.getContent() %></td>
		</tr>
	</table>
	
	<table class="table table-hover" width="90%">
	<thead>
		<tr align="center">
			<th style="border-bottom:none;">
<%
if(session.getAttribute("user_id") != null && user_code.equals(vo.getUsercode())){
%>
				<button type="button" class="btn btn-primary" onclick="location.href='EdmsFileEdit.jsp?idx=<%= vo.getIdx() %>';">수정하기</button>
				<button type="button" class="btn btn-primary" onclick="deletePost();">삭제하기</button>
<%
}
%>
				<button type="button" class="btn btn-primary" onclick="location.href='EdmsFileList.jsp';">목록 보기</button>
			</th>
		</tr>
	</thead>
	</table>
	</form>
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>