<%@page import="java.util.ArrayList"%>
<%@page import="deptPosRes.DeptPosResVO"%>
<%@page import="deptPosRes.DeptPosResDAO"%>
<%@page import="userinfo.UserInfoKorVO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../Login/IsLoggedIn.jsp" %>
<%
request.setCharacterEncoding("utf-8");

// DeptPosResDAO dao = new DeptPosResDAO();
DeptPosResDAO dao = DeptPosResDAO.getInstance();
List<DeptPosResVO> list = new ArrayList<DeptPosResVO>();
%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>정보 수정</title>
</head>
<body>

<script>
window.onload = function(){
	var v = opener.document.getElementById('checkedValue').value;
	var vSplit = v.split(',');
	
	document.getElementById('user_name').value = vSplit[0];
	document.getElementById('user_id').value = vSplit[1];
	document.getElementById('user_pw').value = vSplit[2];
	document.getElementById('user_code').value = vSplit[3];
	
	var el;
	
	el = document.getElementById('dept_id');
	
	for(var i=0; i<el.options.length; i++){
		if(el.options[i].text == vSplit[4]){
			el.options[i].selected = true;
		}
	}

	el = document.getElementById('pos_id');
	
	for(var i=0; i<el.options.length; i++){
		if(el.options[i].text == vSplit[5]){
			el.options[i].selected = true;
		}
	}
	
	el = document.getElementById('res_id');
	
	if(el.value == null){
		el.options[0].selected = true;
	}else{
		for(var i=0; i<el.options.length; i++){
			if(el.options[i].text == vSplit[6]){
				el.options[i].selected = true;
			}
		}
	}
};

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
	document.EditFrm.target = "parentPage";	
	self.close();
};
</script>

	<div style="margin:10px 5px 10px 5px;">
	<h3>정보 수정</h3>
	</div>

	<form name="EditFrm" method="post" onsubmit="return validateForm(this);" action="EditProcess.jsp;">

	<table class="table table-hover" style="width:500px; margin:10px 10px 10px 10px;">
		<tr>
			<td style="vertical-align:middle;">이름</td>
			<td>
				<input type="text" class="form-control" id="user_name" name="user_name" style="width:70%;"/>
			</td>
		</tr>
		<tr>
			<td style="vertical-align:middle;">아이디</td>
			<td>
				<input type="text" class="form-control" id="user_id" name="user_id"style="width:70%;"/>
			</td>
		</tr>
		<tr>
			<td style="vertical-align:middle;">비밀번호</td>
			<td>
			<input type="text" class="form-control" id="user_pw" name="user_pw"style="width:70%;"/>
			</td>
		</tr>
		<tr>
			<td style="vertical-align:middle;">사원 코드</td>
			<td>
			<input type="text" class="form-control" id="user_code" name="user_code"style="width:70%;"/>
			</td>
		</tr>
		<tr>
			<td style="vertical-align:middle;">부서</td>
			<td>
				<select class="form-select" id="dept_id" name="dept_id"style="width:70%;">
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
			<td style="vertical-align:middle;">직급</td>
			<td>
				<select class="form-select" id="pos_id" name="pos_id"style="width:70%;">
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
			<td style="vertical-align:middle;">직책</td>
			<td>
				<select class="form-select" id="res_id" name="res_id"style="width:70%;">
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

	<div style="margin:5px 5px 5px 5px;">
	<table style="width:500px; margin:10px 10px 10px 10px;">
		<tr>
			<td>
				<input type="submit" class="btn btn-primary" value="수정"/>
			</td>
		</tr>
	</table>
	</div>	

	</form>
	
</body>
</html>