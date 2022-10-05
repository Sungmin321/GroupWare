<%@page import="java.util.ArrayList"%>
<%@page import="deptPosRes.DeptPosResVO"%>
<%@page import="java.util.List"%>
<%@page import="deptPosRes.DeptPosResDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@ include file="../Login/IsLoggedIn.jsp" %> --%>
<%
DeptPosResDAO dao = new DeptPosResDAO();
List<DeptPosResVO> list = new ArrayList<DeptPosResVO>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 추가</title>
</head>
<body>

<script>
function validateForm(form){
	if(!form.user_name.value){
		alert("이름을 입력하세요.");
		return false;
	}
	if(!form.user_id.value){
		alert("아이디를 입력하세요.");
		return false;
	}
	if(!form.user_pw.value){
		alert("비밀번호를 입력하세요.");
		return false;
	}
	if(!form.user_code.value){
		alert("사원코드를 입력하세요.");
		return false;
	}
	if(!form.dept_id.value){
		alert("부서를 선택하세요.");
		return false;
	}
	if(!form.pos_id.value){
		alert("직급을 선택하세요.");
		return false;
	}
	if(!form.res_id.value){
		alert("직책을 선택하세요.");
		return false;
	}
	window.opener.name = "parentPage";
	document.addFrm.target = "parentPage";	
	self.close();
};
</script>

	<h2>직원 추가하기</h2>

	<form name="addFrm" method="post" onsubmit="return validateForm(this);" action="AddProcess.jsp;">

	<table border="1" width="90%">
		<tr>
			<td>이름</td>
			<td><input type="text" name="user_name"/></td>
		</tr>
		<tr>
			<td>아이디</td>
			<td><input type="text" name="user_id"/></td>
		</tr>
		<tr>
			<td>비밀번호</td>
			<td><input type="text" name="user_pw"/></td>
		</tr>
		<tr>
			<td>사원 코드</td>
			<td><input type="text" name="user_code"/></td>
		</tr>
		<tr>
			<td>부서</td>
			<td>
				<select name="dept_id">
<%
list = dao.selectList("department2");

for(DeptPosResVO vo : list){
%>
					<option value="<%= vo.getId() %>"><%= vo.getName_kor() %></option>
<%
}
%>				
				</select>
			</td>
		</tr>
		<tr>
			<td>직급</td>
			<td>
				<select name="pos_id">
<%
list = dao.selectList("jobposition");

for(DeptPosResVO vo : list){
%>
					<option value="<%= vo.getId() %>"><%= vo.getName_kor() %></option>
<%
}
%>
				</select>
			</td>
		</tr>
		<tr>
			<td>직책</td>
			<td>
				<select name="res_id">
					<option value="0">없음</option>
<%
list = dao.selectList("responsibility");

for(DeptPosResVO vo : list){
%>
					<option value="<%= vo.getId() %>"><%= vo.getName_kor() %></option>
<%
}
%>
				</select>
			</td>
		</tr>
	</table>
	
	<table width="90%">
		<tr>
			<td>
				<input type="submit" value="추가"/>
			</td>
		</tr>
	</table>

	</form>

</body>
</html>