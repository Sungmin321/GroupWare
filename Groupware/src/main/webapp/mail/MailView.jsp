<%@ include file="../Sidebar1.jsp" %>
<%@page import="java.net.URLEncoder" %>
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

// System.out.println("View.jsp의 status : " + status);

if(vo.getStatus() == 1){
	dao.updateStatus(2, idx); // 안 읽은 메일(status : 1) -> 읽은 메일(status : 2)로 변경
}else if(vo.getStatus() / 10 == 1 && vo.getStatus() % 10 == 5){
	dao.updateStatus(25, idx); // 휴지통 안 읽은 메일(status : 15) -> 휴지통 읽은 메일(status : 25)로 변경
}

dao.close();

AttachedFileDAO fDao = new AttachedFileDAO();
AttachedFileVO fVo = fDao.selectView(idx);

System.out.println("idx : " + idx);
System.out.println("fVo.getOfile() : " + fVo.getOfile());

fDao.close();
%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>메일 상세 보기</title>
<style>
.td_content{vertical-align:top}
</style>
</head>
<body>
	<h3>메일 상세 보기</h3>
	<form>
	
		<table class="table table-hover" width="90%">
		<thead>
			<tr>
				<td style="border-bottom:none;">
					<button type="button" class="btn btn-primary" onclick="location.href='MailList.jsp?status=<%= request.getParameter("status") %>';">목록보기</button>
				</td>
			</tr>
		</thead>
		</table>
	
		<table class="table table-hover" width="90%">
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
<%-- 				<td colspan="3" align="left"><%= fVo.getOfile() %></td> --%>
				<td colspan="3" align="left"><a href="../attachedfile/Download.jsp?oName=<%= URLEncoder.encode(fVo.getOfile(), "UTF-8")%>&sName=<%= URLEncoder.encode(fVo.getSfile(), "UTF-8")%>"><%= fVo.getOfile() %></a></td>
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
<%@ include file="../Sidebar2.jsp" %>