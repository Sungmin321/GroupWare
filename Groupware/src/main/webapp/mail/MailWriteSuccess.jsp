<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");

String status = request.getAttribute("status").toString();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메일 전송 완료</title>
</head>
<body>
<script>
function changeSubmitValue(form){
	var v = form.submitName.value;
	
	if(v == "받은메일함으로 이동"){
		form.action = "MailList.jsp";
	}else if(v == "임시보관함으로 이동"){
		form.action = "MailList.jsp";
	}else if(v == "메일쓰기"){
		form.action = "MailWrite.jsp";
	}else if(v == "쓰던 페이지 가기"){
		form.action = "MailWrite.jsp";
	}
};
</script>

<%
if(status.equals("2")){	
%>
	<h2>메일이 정상적으로 전송되었습니다.</h2>
	
	<form name="frm1" method="post" onsubmit="return changeSubmitValue(this);">
		<input type="hidden" id="status1" name="status" value="<%= request.getAttribute("status").toString() %>"/>
		<input type="hidden" id="submitValue1" name="submitValue" value="<%= request.getAttribute("submitValue").toString() %>"/>
		<input type="submit" id="submit1" name="submitName" value="받은메일함으로 이동"/>
	</form>
	<form name="frm2" method="post" onsubmit="return changeSubmitValue(this);">
		<input type="hidden" id="status2" name="status" value="<%= request.getAttribute("status").toString() %>"/>
		<input type="hidden" id="submitValue2" name="submitValue" value="<%= request.getAttribute("submitValue").toString() %>"/>
		<input type="submit" id="submit2" name="submitName" value="메일쓰기"/>
	</form>
	
<%
}else if(status.equals("4")){
%>
	<h2>작성하신 메일이 임시 저장되었습니다.</h2>

	<form name="frm3" method="post" onsubmit="return changeSubmitValue(this);">
		<input type="hidden" id="status3" name="status" value="<%= request.getAttribute("status").toString() %>"/>
		<input type="hidden" id="submitValue3" name="submitValue" value="<%= request.getAttribute("submitValue").toString() %>"/>
		<input type="submit" id="submit3" name="submitName" value="임시보관함으로 이동"/>
	</form>
	<form name="frm4" method="post" onsubmit="return changeSubmitValue(this);">
		<input type="hidden" id="status4" name="status" value="<%= request.getAttribute("status").toString() %>"/>
		<input type="hidden" id="submitValue4" name="submitValue" value="<%= request.getAttribute("submitValue").toString() %>"/>
		<input type="submit" id="submit4" name="submitName" value="쓰던 페이지 가기"/>
	</form>
<%
}
%>
</body>
</html>