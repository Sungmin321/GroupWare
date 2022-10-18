<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="board.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="../Login/IsLoggedIn.jsp" %>  
<% 	
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	BoardDAO bdao = BoardDAO.getInstance();

	if( session.getAttribute("cate") == null ){ // 세션에 값이 없거나 -> main 화면에서 바로 들어온 경우. main에서 받아서 세션에 저장시켜준다.
		System.out.println("첫번째 조건 : 세션에 카테값이 null 일때 request에 cate값을 넣어주기. request cate : "+request.getParameter("cate"));
		String cate = request.getParameter("cate");
	
		session.setAttribute("cate", cate);
	}else if ( !(session.getAttribute("cate").toString().equals(request.getParameter("cate"))) ){ //세션의 cate 값과 request의 cate값이 같은경우.
		System.out.println("두번째 조건 : 세션의 값과 request의 cate값이 다를때. request cate : "+request.getParameter("cate"));
		
		if(request.getParameter("cate") != null){ // 널이 아니면 request의 정보를 session에 저장해라.
			String cate = request.getParameter("cate");
			session.setAttribute("cate", cate);
		}
	}
	
		String idx = request.getParameter("idx"); // 게시물 찾아올때 쓸 idx 
		String number = request.getParameter("i"); // 글번호
	
	BoardVO vo = bdao.ViewBoard(idx);
	//idx로 정보 찾아오고
%>
<!DOCTYPE>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
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
	<h3>회원제 게시판 - 수정하기(Edit) 현재 cate : <%= session.getAttribute("cate").toString() %></h3>
	<form name="EidtFrm" method="post" action="EditProcess.jsp" enctype="multipart/form-data" onsubmit="return validateForm(this);">
		<table class="table table-hover" width="90%">
			<tr>
				<td>제목<input type="hidden" name="idx" value="<%= idx %>"/></td>
				<td><input type="text" class="form-control" name="title" style="width: 90%;" value="<%= vo.getTitle( )%>"/></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea class="form-control" name="content" style="width: 90%; height: 100px;"><%= vo.getContent() %></textarea></td>
			</tr>
			<tr>
				<td>첨부파일</td>
				<td>
				<div class="form-group" style="float:left;">
					<input type="file" class="form-control" name="ofile" style="width: 90%;">
				</div>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center" style="border-bottom:none;">
					<button type="submit" class="btn btn-primary">작성 완료</button>
					<button type="reset" class="btn btn-primary">다시 입력</button>
					<button type="button" class="btn btn-primary" onclick="location.href='List.jsp';">목록 보기</button>
				</td>
			</tr>
		</table>
	</form>
</html>
<%@ include file="../Sidebar2.jsp" %>