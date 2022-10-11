<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="edms.*" %>
<%! EdmsDAO edmsdao = EdmsDAO.getInstance();
%>
<% 
	String user_code = session.getAttribute("user_code").toString();
	
	//임시 테스트 이한목 코드
	//String user_code = "201012002";
	
	ArrayList<EdmsVO> edmsLists = edmsdao.getApprovalWaitingList(user_code);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2 align="center"><%= edmsdao.getName(user_code) %> 승인대기 List</h2>
	<!-- 검색폼 -->
	<form method="get">
		<table border="1" class="table table-dark table-striped" width="90%" align="center">
			<tr>
				<td align="center"><select name="searchField">
						<option value="title">제목
						<option value="content">내용
				</select> <input type="text" name="searchWord"> <input type="submit" value="검색하기"></td>
			</tr>
		</table>
	</form>
	<!-- 게시물 목록 테이블(표) -->
	
	
	<!-- 
	 //번호 제목 기안자 문서유형 기안일 결재상태 기안완료일
	 -->
	<table border="1" class="table table-dark table-striped" width="90%" align="center">
		<!--  각 컬럼의 이름 -->
		<tr>
			<th width="5%">번호</th>
			<th width="30%">제목</th> 
			<th width="10%">기안자</th> 
			<th width="10%">문서유형</th>
			<th width="15%">기안일</th> 
			<th width="10%">결재상태</th>
			<th width="20%">기안완료일</th>
			<!-- 목록의 내용 -->

			<%
			if (edmsLists.isEmpty()) {
				// 게시물이 하나도 없을 때
			%>
		
		<tr>
			<td colspan="7" align="center">대기중인 전자결재가 없습니다</td>
		</tr>
		<%
		} else {
		int virtualNum = 0;
		String doctypekr = "";
		String doctype;
		String status;
		String statuskr = "";
		EdmsVO evo = new EdmsVO();
		for (int i=0; i<edmsLists.size(); i++) {
			evo = edmsLists.get(i);
			
			edmsdao.getName(evo.getUser_code());
			doctype = evo.getDoctype();
			status = evo.getStatus();
			switch (doctype) {
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
			
			switch (status) {
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
		<tr align="center">
			<td><%=edmsLists.size()-i%>
			<!-- 
			<input type="hidden" name="idx" value="<%= evo.getIdx() %>"/>
			<input type="hidden" name="i" value="<%= edmsLists.size()-i %>"/>
			 -->
			</td>
			<td align="left"><a href="EdmsApprovalWaitingView.jsp?idx=<%=evo.getIdx()%>&i=<%=edmsLists.size()-i%>"><%=evo.getTitle()%></a></td>
			<td align="center"><%=edmsdao.getName(evo.getUser_code())%></td>
			<td align="center"><%= doctypekr %></td>
			<td align="center"><%=evo.getPostdate()%></td>
			<td align="center"><%=statuskr%></td>
			<td align="center"><%=evo.getLastdate()==null?"미완료":evo.getLastdate()%></td>
		</tr>
		<%
		}
		}
		%>
	</table>
	<!--  목록 하단의 [글쓰기] 버튼 -->
	<table border="1" width="90%"  class="table table-dark table-striped" align="center">
		<tr align="right">
			<td><button class="btn btn-primary" type="button" onclick="location.href='EdmsApproval.jsp';">전자결재 상신</button></td>
		</tr>
	</table>
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>