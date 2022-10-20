<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="board.*" %>
<%@ page import="attachedfile.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="../Login/IsLoggedIn.jsp" %>  
<% 	
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	
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
	
	BoardDAO bdao = BoardDAO.getInstance();
	
		String idx = request.getParameter("idx"); // 게시물 찾아올때 쓸 idx 
		String number = request.getParameter("i"); // 글번호
// 		AttachedFileDAO dao = new AttachedFileDAO();
		AttachedFileDAO dao = AttachedFileDAO.getInstance();
		AttachedFileVO fVo = dao.selectView(Integer.parseInt(idx));
	
	BoardVO vo = bdao.ViewBoard(idx);
	//idx로 정보 찾아오고
%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>Board View</title>
</head>
<body>
	<table class="table table-hover" width="90%" align="center">
		<tr>
			<td>번호</td>
			<td><%= number %></td>
			<td>작성자</td>
			<td><%=vo.getUsercode()%></td>
		</tr>
		<tr>
			<td>작성일</td>
			<td><%=vo.getPostdate()%></td>
			<td>조회수</td>
			<td><%=vo.getVisitcount()%></td>
		</tr>
		<tr>
			<td>제목</td>
			<td colspan="3"><%= vo.getTitle() %></td>
		</tr>
		<tr>
			<td>내용</td>
			<td colspan="3" height="100">
			<%= vo.getContent() %></td>
		</tr>
		<% if(fVo.getOfile() != null) { %>
		<tr>
			<td>첨부파일</td>
			<td>
			<a href="../attachedfile/Download.jsp?oName=
			<%= URLEncoder.encode(fVo.getOfile(), "UTF-8")%>&sName=<%= URLEncoder.encode(fVo.getSfile(), "UTF-8")%>"><%= fVo.getOfile() %>
			</a>
			</td>
		</tr>
		<% }else { %>
		<tr>
			<td>첨부파일</td>
			<td colspan="3">
			첨부 된 파일이 없습니다.
			</td>
		</tr>
		<% } %>
		<tr>
				<td colspan="4" align="center" style="border-bottom:none;">
					<%
					if (session.getAttribute("user_code") != null && session.getAttribute("user_code").toString().equals(vo.getUsercode())) {
					%>
					<button type="button" class="btn btn-primary" onclick="location.href='Edit.jsp?idx=<%=vo.getIdx()%>'">수정하기</button>
					<button type="button" class="btn btn-primary" onclick="location.href='DeleteProcess.jsp?idx<%=vo.getIdx()%>&i=<%=number%>'">삭제하기</button> 
					<% } %>
					<button type="button" class="btn btn-primary" onclick="location.href='List.jsp';">목록 보기</button>
				</td>
		</tr>
	</table>
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>