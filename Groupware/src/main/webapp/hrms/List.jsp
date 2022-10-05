<%@page import="userinfo.UserInfoKorVO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@ include file="../Login/IsLoggedIn.jsp" %>     --%>
<%
UserInfoDAO dao = new UserInfoDAO();
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
		window.open("<%= request.getContextPath() %>/hrms/Edit.jsp", "정보 수정", "width=600, height=400")
	};
	
	function addUser(){
		window.open("<%= request.getContextPath() %>/hrms/Add.jsp", "직원 추가", "width=600, height=400")
	};
	
	function getRadioValue(event){
		v = event.target.value;
		document.getElementById('checkedValue').value = v;
	};
	
</script>

	<input type="hidden" id="checkedValue" value=""/>
	
	<table width="90%">
		<tr>
			<td align="right">
				<button type="button" onclick="editUserInfo();">수정하기</button>
				<button type="button" onclick="addUser();">직원 추가</button>
			</td>
		</tr>
	</table>
	
	<form method="get">
	<table border="1" width="90%">
		<tr>
			<td align="center">
				<select name="searchField">
					<option value="dept_name_kor">부서명</option>
					<option value="user_name">이름</option>
					<option value="user_code">사원코드</option>
					<option value="res_name_kor">직책</option>
				</select>
				<input type="text" name="searchWord"/>
				<input type="submit" value="검색"/>
			</td>
		</tr>
	</table>
	</form>
	
	<table border="1" width="90%">
		<tr align="center">
			<td></td>
			<td>이름</td>
			<td>아이디</td>
			<td>비밀번호</td>
			<td>사원코드</td>
			<td>부서</td>
			<td>직급</td>
			<td>직책</td>
		</tr>
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
	</table>
	
</body>
</html>