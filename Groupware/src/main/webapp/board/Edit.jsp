<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="board.*" %>
<%@ page import="java.net.URLEncoder" %>
<% 	
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	BoardDAO bdao = BoardDAO.getInstance();

		String idx = request.getParameter("idx"); // 게시물 찾아올때 쓸 idx 
		String number = request.getParameter("i"); // 글번호
	
	BoardVO vo = bdao.ViewBoard(idx);
	//idx로 정보 찾아오고
%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시글 수정</title>
<script type="text/javascript">
	function validateForm(form) { // 폼 내용 검증
		if (form.title.value == "") {
			alert("제목을 입력하세요.");
			form.title.focus();
			return false;
		}
		if (form.content.value == "") {
			alert("내용을 입력하세요.");
			form.content.focus();
			return false;
		}
	}
</script>
</head>
<body>
<%  %>
	<h2>회원제 게시판 - 수정하기(Edit) 현재 cate : <%= request.getAttribute("cate") %></h2>
	<form name="EidtFrm" method="post" action="EditProcess.jsp" enctype="multipart/form-data" onsubmit="return validateForm(this);">
		<table border="1" width="90%">
			<tr>
				<td>제목<input type="hidden" name="idx" value="<%= idx %>"/></td>
				<td><input type="text" name="title" style="width: 90%;" value="<%= vo.getTitle( )%>"/></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea name="content" style="width: 90%; height: 100px;"><%= vo.getContent() %></textarea></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<button type="submit">작성 완료</button>
					<button type="reset">다시 입력</button>
					<button type="button" onclick="location.href='List.jsp';">목록 보기</button>
				</td>
			</tr>
			<tr>
				<td>첨부파일</td>
				<td><input type="file" name="ofile"></td>
			</tr>
		</table>
</html>
<%@ include file="../Sidebar2.jsp" %>