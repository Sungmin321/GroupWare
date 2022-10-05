<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2> 여기는 list 화면입니다.</h2>
	<% String saveDirectory = application.getRealPath("/Uploads"); %>
	<%= saveDirectory %>
</body>
</html>