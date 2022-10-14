<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");

String idx = request.getParameter("idx");

// String edmsFile = "";
// BoardDAO bDao = new BoardDAO(edmsFile);
BoardDAO bDao = BoardDAO.getInstance();
int result = bDao.deletePost(idx);
// bDao.close();

AttachedFileDAO fDao = new AttachedFileDAO();
fDao.delete(Integer.parseInt(idx));
fDao.close();

if(result == 1){
%>
<script>
	alert("삭제되었습니다.");
	location.href = "EdmsFileList.jsp";
</script>
<%
}else{
%>
<script>
	alert("게시물 삭제에 실패하였습니다.");
	history.back();
// 	response.sendRedirect("EdmsFileList.jsp");
</script>
<%
}
%>
