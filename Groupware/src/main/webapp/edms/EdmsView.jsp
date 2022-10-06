<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="edms.*" %>
<%@ page import="attachedfile.*" %>
<%@ page import="java.net.URLEncoder" %>
<%! EdmsDAO edmsdao = EdmsDAO.getInstance(); %>
<% 
		String idx = request.getParameter("idx"); // 게시물 찾아올때 쓸 idx 
		String number = request.getParameter("i"); // 글번호
		AttachedFileDAO dao = new AttachedFileDAO();
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

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table border="1" width="90%" align="center">
		<tr>
			<th width="30%">문서번호</th>
			<td><%= number %></td>
		</tr>
		<tr>
			<th>제목</th>
			<td><%= evo.getTitle() %></td>
		</tr>
		<tr>
			<th>기안자</th>
			<td><%= edmsdao.getName(evo.getUser_code()) %></td>
		</tr>
		<tr>
			<th>문서양식</th>
			<td><%= doctypekr %></td>
		</tr>
		<tr>
			<th>기안일</th>
			<td><%= evo.getPostdate() %></td>
		</tr>
		<tr>
			<th>결재상태</th>
			<td><%= statuskr %></td>
		</tr>
		<tr>
			<th>기안완료일</th>
			<td><%= evo.getLastdate()==null?"미완료":evo.getLastdate() %></td>
		</tr>
		<tr>
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
		<tr>
			<th>첨부파일</th>
			<td>
			<a href="../attachedfile/Download.jsp?oName=
			<%= URLEncoder.encode(fVo.getOfile(), "UTF-8")%>&sName=<%= URLEncoder.encode(fVo.getSfile(), "UTF-8")%>"><%= fVo.getOfile() %>
			</a>
			</td>
		</tr>
	</table>
	<table border="1" width="90%" align="center">
		<tr>
			<th colspan="4">결재라인</th>
		</tr>
		<tr>
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
				<td><%= ivo.getName() %></td>
				<td><%= ivo.getDeptkr() %></td>
				<td><%= ivo.getPoskr() %></td>
				<td><%= confirmed %></td>
			</tr>
			<%
		}
		%>
	</table>
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>