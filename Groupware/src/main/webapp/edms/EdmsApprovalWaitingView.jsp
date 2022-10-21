<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="edms.*" %>
<%@ page import="attachedfile.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="../Login/IsLoggedIn.jsp" %>  
<%! EdmsDAO edmsdao = EdmsDAO.getInstance(); %>
<% 
	String idx = request.getParameter("idx"); // 게시물 찾아올때 쓸 idx 
	String number = request.getParameter("i"); // 글번호
	
// 	AttachedFileDAO dao = new AttachedFileDAO();
	AttachedFileDAO dao = AttachedFileDAO.getInstance();
	AttachedFileVO fVo = dao.selectView(Integer.parseInt(idx));
	
	EdmsVO evo = edmsdao.viewEdms(idx); //idx로 정보 찾아오고
//	EdmsVO evo = edmsdao.viewEdms("40"); //임시 정보
	String statuskr = "";
	String doctypekr = "";

switch (evo.getDoctype()) {
case "1" :
	doctypekr = "지출결의서";
	break;
case "2" :
	doctypekr = "품의서";
	break;
case "3" :
	doctypekr = "보고서";
	break;
case "4" :
	doctypekr = "협조전";
	break;
case "5" :
	doctypekr = "사직/휴직/복직원";
	break;
}

switch (evo.getStatus()){
case "1" :
	statuskr = "미승인";
	break;
case "2" :
	statuskr = "승인";
	break;
case "3" :
	statuskr = "반려";
	break;
}

String v1 = "";
if(request.getAttribute("v1") != null){
	v1 = request.getAttribute("v1").toString();
}
System.out.println("v1 : " + v1);
%>

<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>Insert title here</title>

<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
<script type="text/javascript">
window.onload = function(){
	var v1 = "<%= v1 %>";
	
	if(v1 != ""){
		$('#submitBtn1').hide();
		$('#submitBtn2').hide();
	}
};
</script>

</head>
<body>
	<table class="table table-hover" width="90%" align="center">
		<tr align="center">
			<th width="30%">문서번호</th>
			<td align="left"><%= number %></td>
		</tr align="center">
		<tr align="center">
			<th>제목</th>
			<td align="left"><%= evo.getTitle() %></td>
		</tr align="center">
		<tr align="center">
			<th>기안자</th>
			<td align="left"><%= edmsdao.getName(evo.getUser_code()) %></td>
		</tr>
		<tr align="center">
			<th>문서양식</th>
			<td align="left"><%= doctypekr %></td>
		</tr>
		<tr align="center">
			<th>기안일</th>
			<td align="left"><%= evo.getPostdate() %></td>
		</tr>
		<tr align="center">
			<th>결재상태</th>
			<td align="left"><%= statuskr %></td>
		</tr>
		<tr align="center">
			<th>기안완료일</th>
			<td align="left"><%= evo.getLastdate()==null?"미완료":evo.getLastdate() %></td>
		</tr>
		<tr align="center">
		<th colspan="2">결재 내용</th>
		</tr>
		<% String Contents[] = evo.getContent().split("`"); 
			for (int i = 0; i<Contents.length ; i++){
				%>
				<tr>
					<td colspan="2"><%= Contents[i] %></td>
				</tr>
				<%
			}
		%>
		<% if(fVo.getOfile() != null) {
		%>
		<tr align="center">
			<th>첨부파일</th>
			<td align="left"><a href="../attachedfile/Download.jsp?oName=
			<%= URLEncoder.encode(fVo.getOfile(), "UTF-8")%>&sName=<%= URLEncoder.encode(fVo.getSfile(), "UTF-8")%>"><%= fVo.getOfile() %>
			</a></td>
		</tr>
		<% } else {
		%>
		<tr align="center">
			<th>첨부파일</th>
			<td align="left">첨부 된 파일이 없습니다.</td>
		</tr>
		<% } %>
	</table>
	<table class="table table-hover" width="90%" align="center">
		<tr align="center">
			<th colspan="4">결재라인</th>
		</tr>
		<tr align="center">
			<th>이름</th>
			<th>부서</th>
			<th>직위</th>
			<th>결재상태</th>
		</tr>
		<%
		String[] codes = evo.getLine().split("/");
		String[] confirmeds = evo.getConfirmed().split("/");
		String confirmed = "";
		List<EdmsInfoVO> list = edmsdao.findList(codes);
		
		EdmsInfoVO ivo; 
		for (int i = 0; i<list.size(); i++){
			ivo = list.get(i);
			
			switch (confirmeds[i]){
			case "1" :
				confirmed = "미승인";
				break;
			case "2" :
				confirmed = "승인";
				break;
			case "3" :
				confirmed = "반려";
				break;
			}
			
			%>
			<tr>
				<td align="center"><%= ivo.getName() %></td>
				<td align="center"><%= ivo.getDeptkr() %></td>
				<td align="center"><%= ivo.getPoskr() %></td>
				<td align="center"><%= confirmed %></td>
			</tr>
			<%
		}
		%>
	</table>
	<table class="table table-hover" align="center">
	<thead>
		<tr align="center">
			<th width="40%" style="border-bottom:none;">
				<form action="EdmsApprovalProcess.jsp" method="post">
					<input type="submit" class="btn btn-primary" id="submitBtn1" style="width:100%;height:100%;" value="승인">
					<input type="hidden" name="idx" value="<%= idx %>">
					<input type="hidden" name="i" value="<%= number %>">
				</form>
			</th>
			<th width="40%" style="border-bottom:none;">
				<form action="EdmsReferProcess.jsp" method="post">
					<input type="submit" class="btn btn-primary" id="submitBtn2" style="width:100%;height:100%;" value="반려">
					<input type="hidden" name="idx" value="<%= idx %>">
					<input type="hidden" name="i" value="<%= number %>">
				</form>
			</th>
		</tr>
	</thead>
	</table>
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>