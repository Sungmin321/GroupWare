<%@page import="attachedfile.AttachedFileVO"%>
<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="mail.MailVO"%>
<%@page import="mail.MailDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../Login/IsLoggedIn.jsp" %>
<%
request.setCharacterEncoding("utf-8");

int idx = Integer.parseInt(request.getParameter("idx"));
String status = request.getParameter("status");

MailDAO dao = new MailDAO();
MailVO vo = dao.selectView(idx);
dao.close();

AttachedFileDAO fDao = new AttachedFileDAO();
AttachedFileVO fVo = fDao.selecView(idx);
fDao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메일 상세 보기</title>
<style>
.td_content{vertical-align:top}
</style>
</head>
<body>
	<h2>메일 상세 보기</h2>
	<form>
	
		<table widty="90%">
			<tr>
				<td><button type="button" onclick="location.href='MailList.jsp?status=<%= request.getParameter("status") %>';">목록보기</button></td>
			</tr>
		</table>
	
		<table border="1" width="90%">
			<tr align="center">
				<td>제목</td>
				<td colspan="3" align="left"><%= vo.getTitle() %></td>
			</tr>
			<tr align="center">
				<td width="15%">보낸사람</td>
				<td align="left" width="35%"><%= vo.getUser_name() %><<%= vo.getSender() %>></td>
				<td width="15%">보낸날짜</td>
				<td align="left" width="35%"><%= vo.getSenddate() %></td>
			</tr>
<%
if(fVo.getOfile() != null){
%>
			<tr align="center">
				<td>첨부파일</td>
				<td colspan="3" align="left"><%= fVo.getOfile() %></td>
			</tr>
<%
}
%>
			<tr align="center" height="300">
			
<%
if(vo.getContent() != null){
%>
				<td colspan="4" align="left" class="td_content"><%= vo.getContent().replace("\r\n", "<br/>") %></td>
<%
}else{	
%>
				<td colspan="4" align="left" class="td_content"></td>
<%
}
%>
			</tr>
		</table>
	</form>
</body>
</html>