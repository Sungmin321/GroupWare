<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="mail.MailDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
request.setCharacterEncoding("utf-8");

int status = 0;
if(request.getParameter("status") != null && !request.getParameter("status").equals("null")){
	status = Integer.parseInt(request.getParameter("status"));
}
String[] arr = null;
if(request.getParameter("chk_value") != null && !request.getParameter("chk_value").equals("null")){
	arr = request.getParameter("chk_value").split(","); // idx 
}
int[] chk_value = new int[arr.length];
for(int i=0; i<arr.length; i++){
	chk_value[i] = Integer.parseInt(arr[i]);
}

int result = 0;

MailDAO dao = new MailDAO();
AttachedFileDAO fDao = new AttachedFileDAO();

for(int i=0; i<chk_value.length; i++){
	result = dao.delete(chk_value[i]);
	fDao.delete(chk_value[i]);
	if(result != 1){
		break;
	}
}
dao.close();
fDao.close();

if(result == 1){
%>
<script>
	alert("삭제되었습니다.");
	location.href="MailList.jsp?status=<%= request.getParameter("status")%>";
</script>	
<%
}else{
%>
<script>
	alert("메일 삭제 처리에 실패하였습니다.");
	history.back();
</script>
<%
}
%>
