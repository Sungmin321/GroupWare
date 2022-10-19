<%@page import="userinfo.UserInfoVO"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
if(session.getAttribute("user_id") != null && !session.getAttribute("user_id").equals("null")){
	UserInfoDAO dao = new UserInfoDAO();
	UserInfoVO vo = dao.getUserInfoVO(session.getAttribute("user_id").toString());
	int dept_id = vo.getDept_id();
	
	if(dept_id != 1){
%>

<script>
	alert("직원관리 화면에 대한 접근 권한이 없습니다.");
	history.back();
</script>
	return;
<%
	}
}
%>
</body>
</html>