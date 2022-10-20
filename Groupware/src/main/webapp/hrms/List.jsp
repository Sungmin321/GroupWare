<%@ include file="../Sidebar1.jsp" %>
<%@page import="userinfo.UserInfoKorVO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../Login/IsLoggedIn.jsp" %>
<%@ include file="CheckDept.jsp" %>
<%
// UserInfoDAO dao = new UserInfoDAO();
UserInfoDAO dao = UserInfoDAO.getInstance();
Map<String, Object> map = new HashMap<String, Object>();

String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
if(searchWord != null){
	map.put("searchField", searchField);
	map.put("searchWord", searchWord);
}

List<UserInfoKorVO> list = dao.findAll(map);
%>

<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>직원 관리</title>
</head>
<body>

<script>
	var v;
	
	function editUserInfo(){
		if(v == null){
			alert("정보를 수정할 사원을 선택하세요.");
			return false;
		}
		window.open("<%= request.getContextPath() %>/hrms/Edit.jsp", "정보 수정", "width=550, height=550, resizable=no")
	};
	
	function addUser(){
		window.open("<%= request.getContextPath() %>/hrms/Add.jsp", "직원 추가", "width=550, height=550, resizable=no")
	};
	
	function getRadioValue(event){
		v = event.target.value;
		document.getElementById('checkedValue').value = v;
	};
	
</script>

<h3>직원 관리</h3>

	<input type="hidden" id="checkedValue" value=""/>
	
	<table class="table table-hover" width="90%">
	<thead>
		<tr align="right">
			<th colspan="3" scope="col" style="border-bottom:none;">
				<button type="button" class="btn btn-primary" onclick="editUserInfo();">수정하기</button>
				<button type="button" class="btn btn-primary" onclick="addUser();">직원 추가</button>
			</th>		
		</tr>
	</thead>
	</table>
	
	<form method="get">
	<table class="table table-hover" width="90%">
	<thead>
		<tr align="center">
			
			<th style="width:30%; border-bottom:none;">
			</th>
			
			<th scope="col" style="width:15%; border-bottom:none;">
			<fieldset>
			 <div class="form-group" style="float:right;">
				<select class="form-select" name="searchField" style="width:200px;">
					<option value="dept_name_kor">부서명</option>
					<option value="user_name">이름</option>
					<option value="user_code">사원코드</option>
					<option value="res_name_kor">직책</option>
				</select>
			 </div>
			</fieldset>
			</th>
			
			<th scope="col" style="width:15%; border-bottom:none;">
			<fieldset>
			 <div class="form-group" style="float:center;">
				<input type="text" class="form-control" name="searchWord" style="width:200px;"/>
			 </div>
			</fieldset>
			</th>
			
			<th scope="col" style="width:10%; border-bottom:none;">
			<fieldset>
			 <div class="form-group" style="float:left;">
				<input type="submit" class="btn btn-outline-primary" value="검색"/>
			 </div>
			</fieldset>
			</th>
			
			<th style="width:30%; border-bottom:none;">
			</th>
			
		</tr>
	</thead>
	</table>
	</form>
	
	<table class="table table-hover" width="90%">
	<thead>
		<tr align="center" style="background-color:#DCDCDC;">
			<th scope="col"></th>
			<th scope="col">이름</th>
			<th scope="col">아이디</th>
			<th scope="col">비밀번호</th>
			<th scope="col">사원코드</th>
			<th scope="col">부서</th>
			<th scope="col">직급</th>
			<th scope="col">직책</th>
		</tr>
	</thead>
	<tbody>
<%
if(list.isEmpty()){
%>
		<tr>
			<td colspan="8" align="center">
				등록된 사원정보가 없습니다.
			</td>
		</tr>
<%
}else{
	for(UserInfoKorVO vo : list){
%>	
		<tr align="center">
			<td>
				<input type="radio" id="radioId" name="radioName" 
					value="<%= vo.getUser_name() %>,<%= vo.getUser_id() %>,<%= vo.getUser_pw() %>,<%= vo.getUser_code() %>,<%= vo.getDept_name_kor()%>,<%= vo.getPos_name_kor() %>,<%= vo.getRes_name_kor() %>" 
					onclick="getRadioValue(event)"/>
			</td>
			<td align="center" id="name"><%= vo.getUser_name() %></td>
			<td align="center"><%= vo.getUser_id() %></td>
			<td align="center"><%= vo.getUser_pw() %></td>
			<td align="center"><%= vo.getUser_code() %></td>
			<td align="center"><%= vo.getDept_name_kor() %></td>
			<td align="center"><%= vo.getPos_name_kor() %></td>
<%
		if(vo.getRes_name_kor() == null){
%>			
			<td align="center">없음</td>
<%
		}else{
%>			
			<td align="center"><%= vo.getRes_name_kor() %></td>
<%
		}
%>
		</tr>
<%
 	} // for문의 끝
} // else문의 끝
%>	
	</tbody>
	</table>
	
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>