<%@page import="userinfo.UserInfoKorVO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");

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
	var v = form.submitName.value;

	if(v != "검색" && !textFrm.recipients.value){
		alert("받는 사람을 한 명 이상 선택하세요.");
		return false;
	}
	
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

	<div style="margin:10px 5px 10px 5px;">
	<h3>받는사람 추가</h3>
	</div>
	
	<form name="textFrm" method="post" onsubmit="return validateForm(this);">
	<input type="hidden" name="status" value="<%= request.getParameter("status") %>"/>
	<table class="table table-hover" style="width:500px; margin:10px 10px 10px 10px;">
	<thead>
		<tr>
			<th style="border-bottom:none;">받는사람 : </th>
		</tr>
		<tr>
			<th style="border-bottom:none;">
			<div class="form-group" style="float:left; margin-right:10px; width=80%;">
				<input type="text" class="form-control" id="recipients" name="recipients" style="width:350px; height:100px;" readonly/>
			</div>
			<div class="form-group" style="float:left; width=20%;">
				<input type="button" class="btn btn-dark"  id="deleteText" name="deleteText" value="모두 삭제" onclick="deleteRecipients();"/>
			</div>
			</th>
		</tr>
	</thead>
	</table>
	<table class="table table-hover"  style="width:500px; margin:10px 10px 10px 10px;">
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
				<input type="submit" class="btn btn-outline-primary" id="search_btn" name="submitName" value="검색"/>
			 </div>
			</fieldset>
			</th>	
		
			<th style="width:30%; border-bottom:none;">
			</th>

		</tr>
	</thead>
	</table>
	</form>

	<form name="addFrm" method="post" onsubmit="return validateForm(this);">
	<table class="table table-hover"  style="width:500px; margin:10px 10px 10px 10px;">
	<thead>
		<tr align="center">
			<th></th>
			<th>이름</th>
			<th>사원코드</th>
			<th>부서</th>
			<th>직급</th>
			<th>직책</th>
		</tr>
	</thead>
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
			<td align="center" colspan="6" style="border-bottom:none;">
				<input type="hidden" id="status" name="status" value="<%= request.getParameter("status") %>"/>
				<input type="hidden" id="recipientsValue" name="recipientsValue"/>
				<input type="submit" class="btn btn-primary" id="close_btn" name="submitName" value="선택 완료"/>
			</td>
		</tr>
	</table>	
	</form>

</body>
</html>