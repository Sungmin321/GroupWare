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
// 수정하기, 삭제하기 버튼 접근 권한 확인
String user_id = session.getAttribute("user_id").toString();

UserInfoDAO iDao = new UserInfoDAO();
UserInfoVO iVo = iDao.getUserInfoVO(user_id);
String user_code = String.valueOf(iVo.getUser_code());

// 상세페이지 내용
int idx = Integer.parseInt(request.getParameter("idx"));

String edmsFile = "";
BoardDAO dao = new BoardDAO(edmsFile);
dao.updateVisitCount(idx);
BoardVO vo = dao.selectView(idx);
dao.close();

// 상세페이지 첨부파일
AttachedFileDAO fDao = new AttachedFileDAO();
AttachedFileVO fVo = fDao.selectView(idx);
// System.out.println("fVo.getOfile() : " + fVo.getOfile());
fDao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전자결재 - 자료실 상세보기</title>
</head>
<body>

<script>
function deletePost(){
	
};
</script>

	<h2>상세보기</h2>
	
	<table border="1" width="90%">
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
			<td align="center" width="15%" height="100">내용</td>
			<td colspan="3"><%= vo.getContent() %></td>
		</tr>
	</table>
	
	<table width="90%">
		<tr align="center">
			<td>
<%
if(session.getAttribute("user_id") != null && user_code.equals(vo.getUsercode())){
%>
				<button type="button" onclick="location.href='EdmsFileEdit.jsp?idx=<%= vo.getIdx() %>';">수정하기</button>
				<button type="button" onclick="deletePost();">삭제하기</button>
<%
}
%>
				<button type="button" onclick="location.href='EdmsFileList.jsp';">목록 보기</button>
			</td>
		</tr>
	</table>
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>