<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 성공</title>
</head>
<body>

<script>
function setStatus(num){
	if(num == 1){
		document.getElementById("status").value = num;
		document.frm.action="../mail/MailWrite.jsp";
		document.frm.submit();
	}else if(num >= 2 && num <= 5){
		document.getElementById("status").value = num;
		document.frm.action="../mail/MailList.jsp";
		document.frm.submit();
	}else{
		return false;
	}
};
</script>

	<h2>로그인 성공(이후 메인 페이지로 변경될 페이지)</h2>
	<%= session.getAttribute("user_name") %> 회원님, 로그인하셨습니다.<br/>
	
	<%= session.getAttribute("dept_name_kor") %><br/>
	<%= session.getAttribute("pos_name_kor") %><br/>
	<%= session.getAttribute("res_name_kor") %><br/>
	
	<a href="Logout.jsp">[Logout]</a>
	
<!-- 	메뉴를 대신할 버튼 -->
	
	<form name="frm" method="post">
		<input type="hidden" id="status" name="status" value="0"/>
		
		<input type="submit" id="1" value="매일쓰기" onclick="setStatus(1);"/>
		<input type="submit" id="2" value="받은메일함" onclick="setStatus(2);"/>
		<input type="submit" id="3" value="보낸메일함" onclick="setStatus(3);"/>
		<input type="submit" id="4" value="임시보관함" onclick="setStatus(4);"/>
		<input type="submit" id="5" value="휴지통" onclick="setStatus(5);"/>
	</form>
	
</body>
</html>