<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
	<h2>Log in</h2>
	<span style="color: red; font-size: 1.2em;">
		<%= request.getAttribute("LoginErrMsg") == null ? "" : request.getAttribute("LoginErrMsg") %>
	</span>
	
	<%
	if(session.getAttribute("user_id") == null){
	%>
	
	<script>
	function validateForm(form){
		if(!form.user_id.value){
			alert("아이디를 입력하세요.");
			form.user_id.focus();
			return false;
		}
		if(!form.user_pw.value || form.user_pw.value == ""){
			alert("비밀번호를 입력하세요.");
			form.user_pw.focus();
			return false;
		}
	}
	</script>

	<form action="LoginProcess.jsp" method="post" name="LoginFrm" onsubmit="return validateForm(this);">
		ID : <input type="text" name="user_id"/><br/>
		Password : <input type="password" name="user_pw"/><br/>
		<input type="submit" value="Log in"/>
	</form>

	<%
	} else{
// 		response.sendRedirect("LoginSuccess.jsp"); // 메인 페이지 구현 후 LoginSucess에서 메인 페이지로 변경
		response.sendRedirect("../index.jsp"); // 메인 페이지 구현 후 LoginSucess에서 메인 페이지로 변경
	}
	%>		
	
</body>
</html>