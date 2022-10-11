<%@ include file="../Sidebar1.jsp" %>
<%@page import="userinfo.UserInfoVO"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@page import="mail.MailVO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="mail.MailDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@ include file="../Login/IsLoggedIn.jsp" %> --%>
<%-- <jsp:include page="../Login/IsLoggedIn.jsp"/> --%>

<!-- 메인 화면에서 메뉴 클릭시 mailList 페이지로 이동하면서 request 영역을 통해 status 값을 받아온다 -->
<!-- status 1 : 메일쓰기, 2 : 받은메일함, 3 : 보낸메일함, 4 : 임시보관함, 5 : 휴지통 -->
<!-- 현재는 메인 페이지와 연결되지않았으므로 LoginSuccess.jsp 페이지에 각 버튼으로 메일함을 구현하여 페이지를 이동시킨다 -->

<%-- <% --%>
<!-- if(session.getAttribute("user_id") == null){ -->
<!-- 	response.sendRedirect("../Login/IsLoggedIn.jsp"); -->
<!-- } -->
<!-- %> -->

<% 
request.setCharacterEncoding("utf-8");

Map<String, Object> map = new HashMap<String, Object>();

// 세션 영역의 user_id로 user_code를 구해서 map.put();
UserInfoDAO uDao = new UserInfoDAO();
String user_id = session.getAttribute("user_id").toString();

UserInfoVO uVo = uDao.getUserInfoVO(user_id);
int user_code = uVo.getUser_code();

map.put("user_code", user_code);

// 검색어, status 구해서 map.put(); 
MailDAO dao = new MailDAO();

String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
String status = request.getParameter("status");

// System.out.println("status : " + status);

map.put("status", status);

if (searchWord != null) {
	map.put("searchField", searchField);
	map.put("searchWord", searchWord);
}

List<MailVO> list = dao.findAll(map);
dao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메일함</title>
</head>
<body>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript">
$(document).on('click','#checkAll',function(){
	console.log("clicked");
	if($(this).is(":checked")){
		$('input:checkbox[name="check[]"]').each(function(){
			this.checked=true;
		});
	}else{
		$('input:checkbox[name="check[]"]').each(function(){
			this.checked=false;
		});
	}
});

$(document).on('click','input:checkbox[name="check[]"]',function(){
	var total = $('input[name="check[]"]').length;
	var countChecked = $('input[name="check[]"]:checked').length;
	
	if($(this).is(":checked")==true){ // 현재 믈릭한 체크박스 true일떄
		if(total == countChecked){ // 생성된 체크박스 갯수와 체크되어있는 갯수가 같을때
			$('input:checkbox[id="checkAll"]').prop("checked",true); // all checkbox true로 변경
		}
	}else{ // 현재 클릭한 체크박스 false일때
		if($('input:checkbox[id="checkAll"]').is(":checked")){ // all checkbox가 true면
			$('input:checkbox[id="checkAll"]').prop("checked",false); // all checkbox false로 변경
		}
	}
});

function delete_btn(){
	var obj = $('input[name="check[]"]');
	var chkArr = new Array();
	$('input:checkbox[name="check[]"]:checked').each(function(){
		chkArr.push(this.value);
	});
	$('#chk_value').val(chkArr);
	var status = <%= request.getParameter("status") %>;
	btn_frm.action = "MailDeleteBtnProcess.jsp";
	btn_frm.submit();
};

function restore_btn(){
	var obj = $('input[name="check[]"]');
	var chkArr = new Array();
	$('input:checkbox[name="check[]"]:checked').each(function(){
		chkArr.push(this.value);
	});
	$('#chk_value').val(chkArr);
	var status = <%= request.getParameter("status") %>;
	btn_frm.action = "MailRestoreBtnProcess.jsp";
	btn_frm.submit();
};

function permanentlyDelete_btn(){
	var confirmed = confirm("선택된 메일을 완전히 삭제하시겠습니까?\n영구 삭제되어 복구할 수 없습니다.");
	if(confirmed){
		var obj = $('input[name="check[]"]');
		var chkArr = new Array();
		$('input:checkbox[name="check[]"]:checked').each(function(){
			chkArr.push(this.value);
		});
		$('#chk_value').val(chkArr);
		var status = <%= request.getParameter("status") %>;
		btn_frm.action = "MailpermanentlyDeleteBtnProcess.jsp";
		btn_frm.submit();
	}
};


</script>
<%
if(status.equals("2")){
%>
	<h2>받은메일함</h2>
<%
}else if(status.equals("3")){
%>
	<h2>보낸메일함</h2>
<%
}else if(status.equals("4")){
%>
	<h2>임시보관함</h2>
<%
}else if(status.equals("5")){
%>
	<h2>휴지통</h2>
<%
}
%>
	<form method="get" name="btn_frm">
	<input type="hidden" name="status" value="<%=request.getParameter("status")%>"/>
	<input type="hidden" id="chk_value" name="chk_value"/>
	<table width="90%">
		<tr>
			<td>
<!-- 				삭제 (받은메일함, 보낸메일함, 임시보관함) -->
<!-- 				완전삭제, 복원 (휴지통만) -->
<%
// if(status == 2 || status == 3 || status == 4){
if(status.equals("2") || status.equals("3") || status.equals("4")){
%>
				<button type="button" onclick="delete_btn();">삭제</button>
<%
}
// if(status == 5){
if(status.equals("5")){
%>
				<button type="button" onclick="permanentlyDelete_btn();">완전삭제</button>
				<button type="button" onclick="restore_btn();">복원</button>
<%
}
%>
			</td>
		</tr>
	</table>
	</form>
	
	<form method="get">
	<table border="1" width="90%">
		<tr align="center">
			<td>
				<input type="hidden" name="status" value="<%=request.getParameter("status")%>"/>
				<select name="searchField">
					<option value="title">제목</option>
					<option value="content">내용</option>
					<option value="sendder">보낸사람</option>
				</select>
				<input type="text" name="searchWord"/>
				<input type="submit" value="검색"/>
			</td>		
		</tr>
	</table>
	</form>
	
	<table border="1" width="90%">
		<tr align="center">
			<td>
				<input type="checkbox" id="checkAll"/>
			</td>
			<td>보낸이</td>
			<td>제목</td>
			<td>보낸 날짜</td>
		</tr>
<%
if(list.isEmpty()){
%>
		<tr>
			<td colspan="4" align="center">
				메일함에 메일이 없습니다.
			</td>		
		</tr>
<%
}else{
	for(MailVO vo : list){
%>		
		<tr>
			<td align="center">
				<input type="checkbox" name="check[]" value="<%= vo.getIdx() %>"/>
			</td>
			<td align="center"><%= vo.getUser_name() %><<%= vo.getSender() %>></td>
<%
		if(status.equals("4")){			
%>
			<td align="center"><a href="MailWrite.jsp?idx=<%= vo.getIdx() %>&status=<%= request.getParameter("status") %>"><%= vo.getTitle() %></a></td>
<%
		}else{
%>
			<td align="center"><a href="MailView.jsp?idx=<%= vo.getIdx() %>&status=<%= request.getParameter("status") %>"><%= vo.getTitle() %></a></td>
<% 
		}
%>			
			<td align="center"><%= vo.getSenddate() %></td>
		</tr>	
<%
	}
}
%>
	</table>
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>