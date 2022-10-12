<%@page import="userinfo.UserInfoKorVO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");

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
<title>받는사람 추가</title>
</head>
<body>

<script>
window.onload = function(){
	var parentValue = opener.document.getElementById('childSelected').value;
	document.getElementById('recipients').value = parentValue;
};

function getRadioValue(event){
	var selectedValue = event.target.value;
	var textValue = document.getElementById('recipients').value;
	if(textValue != null && textValue != ""){
		document.getElementById('recipients').value = textValue + "," + selectedValue;
		document.getElementById('recipientsValue').value = textValue.replaceAll(",","+") + "+" + selectedValue;
		opener.document.getElementById('childSelected').value = textValue + "," + selectedValue;
	}else{
		document.getElementById('recipients').value = selectedValue;
		document.getElementById('recipientsValue').value = selectedValue;
		opener.document.getElementById('childSelected').value = selectedValue;
	}
};

function deleteRecipients(){
	document.getElementById('recipients').value = "";
	document.getElementById('recipientsValue').value = "";
	opener.document.getElementById('childSelected').value = "";
};

function validateForm(form){
	if(!textFrm.recipients.value){
		alert("받는 사람을 한 명 이상 선택하세요.");
		return false;
	}
	
	var v = form.submitName.value;
	
	if(v == "검색"){
		form.action = "AddRecipient.jsp";
	}else if(v == "선택 완료"){
		form.action = "MailWrite.jsp";
		window.opener.name = "parentPage";
		document.addFrm.target = "parentPage";
		self.close();
	}else{
		return false;
	}
};

</script>

	<h2>받는사람 추가</h2>
<!-- 	<form name="textFrm" method="get"> -->
	<form name="textFrm" method="post" onsubmit="return validateForm(this);">
	<input type="hidden" name="status" value="<%= request.getParameter("status") %>"/>
	<table width="90%">
		<tr>
			<td>받는사람 : </td>
		</tr>
		<tr>
			<td>
				<input type="text" id="recipients" name="recipients" style="width:400px; height:50px;" readonly/>
				<input type="button" id="deleteText" name="deleteText" value="모두 삭제" onclick="deleteRecipients();"/>
			</td>
		</tr>
	</table>
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
				<input type="submit" id="search_btn" name="submitName" value="검색"/>
			</td>
		</tr>
	</table>
	</form>

<!-- 	<form name="addFrm" method="post" onsubmit="return validateForm();" action="MailWrite.jsp;"> -->
	<form name="addFrm" method="post" onsubmit="return validateForm(this);">
	<table border="1" width="90%">
		<tr align="center">
			<td></td>
			<td>이름</td>
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
					value="<%= vo.getUser_code() %>" 
					onclick="getRadioValue(event)"/>
			</td>
			<td align="center" id="name"><%= vo.getUser_name() %></td>
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
	}
}
%>
		</tr>
		<tr>
			<td align="center" colspan="6">
				<input type="hidden" id="status" name="status" value="<%= request.getParameter("status") %>"/>
				<input type="hidden" id="recipientsValue" name="recipientsValue"/>
<!-- 				<input type="button" id="btn" name="btn" value="선택 완료" onclick="closeThisWindow();"/> -->
<!-- 				<input type="button" id="btn" name="btn" value="선택 완료" onclick="btn_click(this);"/> -->
				<input type="submit" id="close_btn" name="submitName" value="선택 완료"/>
			</td>
		</tr>
	</table>	
	</form>

</body>
</html>