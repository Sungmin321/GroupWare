<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
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
	<h3>회원제 게시판 - 글쓰기(Write)</h3>
	<form name="writeFrm" method="post" action="WriteProcess.jsp" enctype="multipart/form-data" onsubmit="return validateForm(this);">
		<table class="table table-hover" width="90%">
			<tr>
				<td>제목</td>
				<td><input type="text" class="form-control" name="title" style="width: 90%;" /></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea name="content" class="form-control" style="width: 90%; height: 100px;"></textarea></td>
			</tr>
			<tr>
				<td>첨부파일</td>
				<td>
				<div class="form-group" style="float:left;">
					<input type="file" class="form-control" name="ofile" style="width: 90%;">
				</div>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center" style="border-bottom:none;">
					<button type="submit" class="btn btn-primary">작성 완료</button>
					<button type="reset" class="btn btn-primary">다시 입력</button>
					<button type="button" class="btn btn-primary" onclick="location.href='List.jsp';">목록 보기</button>
				</td>
			</tr>
		</table>
	</form>
</html>
<%@ include file="../Sidebar2.jsp" %>