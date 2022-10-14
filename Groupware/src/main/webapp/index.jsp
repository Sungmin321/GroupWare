<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
<!-- 	<h2>Log in</h2> -->
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
	<form action="<%= request.getContextPath() %>/Login/LoginProcess.jsp" method="post" name="LoginFrm" onsubmit="return validateForm(this);">
		<fieldset style="margin: 15px 15px 15px 25px;">
			<legend>Login</legend>
	    	<div class="form-group" style="margin: 0px 15px 0px 15px;">
        		<label for="user_id" class="form-label mt-4">ID</label>
         		<input type="text" class="form-control" id="user_id" name="user_id" placeholder="ID" style="width:300px;">
        	</div>
        	<div class="form-group" style="margin: 0px 15px 0px 15px;">
        		<label for="user_pw" class="form-label mt-4">Password</label>
        		<input type="password" class="form-control" id="user_pw" name="user_pw" placeholder="Password" style="width:300px;">
      		</div>
      		<div style="margin: 25px 15px 15px 15px;">
				<input type="submit" class="btn btn-primary" value="Log in"/>
      		</div>
		</fieldset>
	</form>

	<%
	} else{
// 		response.sendRedirect("LoginSuccess.jsp"); // 메인 페이지 구현 후 LoginSucess에서 메인 페이지로 변경
		response.sendRedirect("main.jsp"); // 메인 페이지 구현 후 LoginSucess에서 메인 페이지로 변경
	}
	%>		
	
</body>
</html>