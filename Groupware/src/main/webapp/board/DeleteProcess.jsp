<%@page import="attachedfile.AttachedFileDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="board.*"%>
<%@page import="attachedfile.AttachedFileDAO.*"%>
<%
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");

	String idx = request.getParameter("idx");
	BoardDAO dao = BoardDAO.getInstance();
	AttachedFileDAO adao = new AttachedFileDAO();
	
	dao.deletePost(idx);
	adao.delete(Integer.parseInt(idx));
	//삭제구문 실행
%>
<script>
	alert("게시물이 삭제 되었습니다.");
	location.href= "List.jsp";
</script>