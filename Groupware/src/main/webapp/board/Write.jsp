<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원제 게시판</title>
<script type="text/javascript">
	function validateForm(form) { // 폼 내용 검증
		if (form.title.value == "") {
			alert("제목을 입력하세요.");
			form.title.focus();
			return false;
		}
		if (form.content.value == "") {
			alert("내용을 입력하세요.");
			form.content.focus();
			return false;
		}
	}
</script>
</head>
<body>
	<h2>회원제 게시판 - 글쓰기(Write)</h2>
	<form name="writeFrm" method="post" action="WriteProcess.jsp" enctype="multipart/form-data" onsubmit="return validateForm(this);">
		<table border="1" width="90%">
			<tr>
				<td>제목</td>
				<td><input type="text" name="title" style="width: 90%;" /></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea name="content" style="width: 90%; height: 100px;"></textarea></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<button type="submit">작성 완료</button>
					<button type="reset">다시 입력</button>
					<button type="button" onclick="location.href='List.jsp';">목록 보기</button>
				</td>
			</tr>
			<tr>
				<td>첨부파일</td>
				<td><input type="file" name="ofile"></td>
			</tr>
		</table>
</html>
<%@ include file="../Sidebar2.jsp" %>