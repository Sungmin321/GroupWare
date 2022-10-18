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
int[] statusArr = new int[arr.length];

int[] chk_value = new int[arr.length];
for(int i=0; i<arr.length; i++){
	chk_value[i] = Integer.parseInt(arr[i]);
}

MailDAO dao = new MailDAO();


for(int i=0; i<statusArr.length; i++){
	statusArr[i] = dao.getStatus(chk_value[i]);
}

int result = 0;

for(int i=0; i<chk_value.length; i++){
	result = dao.updateStatus(statusArr[i] / 10, chk_value[i]);
	if(result != 1){
		break;
	}
}
dao.close();

if(result == 1){
%>
<script>
	alert("이동되었습니다.");
	location.href="MailList.jsp?status=<%= request.getParameter("status")%>";
</script>	
<%
}else{
%>
<script>
	alert("메일함 이동 처리에 실패하였습니다.");
	history.back();
</script>
<%
}
%>
