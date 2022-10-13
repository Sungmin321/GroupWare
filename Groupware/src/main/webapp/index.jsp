<%@ include file="./Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.*" %>
<%@ page import="java.util.*" %>
<% BoardDAO dao = BoardDAO.getInstance();

	List<BoardVO> boardLists = dao.selectListPage("1");
	
	System.out.println(boardLists.size());
%>
<h2>
		공지사항 
	</h2>
	<!-- 게시물 목록 테이블(표) -->
	<table border="1" width="100%" align="center">
		<!--  각 컬럼의 이름 -->
		<tr align="center" border="1">
			<th width="10%">번호</th>
			<th width="50%">제목</th>
			<th width="15%">작성자</th>
			<th width="10%">조회수</th>
			<th width="15%">작성일</th>
			<!-- 목록의 내용 -->
		</tr>
			<%
			if (boardLists.isEmpty()) {
				// 게시물이 하나도 없을 때
			%>
		
		<tr>
			<td colspan="5" align="center">등록된 게시물이 없습니다ㅡㅡ^</td>
		</tr>
		<%
		} else {
		// 게시물이 있을 때 
		for (int i = 0; i<boardLists.size() ; i++) {
			BoardVO vo = boardLists.get(i);
		%>
		<tr align="center">
			<td><%= i+1 %></td>
			<td align="left"><a href="board/View.jsp?idx=<%=vo.getIdx()%>&i=<%=i+1%>&cate=1"><%=vo.getTitle()%></a></td>
			<td align="center"><%=dao.getName(vo.getUsercode())%></td>
			<td align="center"><%=vo.getVisitcount()%></td>
			<td align="center"><%=vo.getPostdate()%></td>
		</tr>
		<%
		}
	}
	%>
	</table>
</div>
<div class="container">
<% 

	boardLists = dao.selectListPage("2");
	
	System.out.println(boardLists.size());
%>
<h2>
		게시판
	</h2>
	<!-- 게시물 목록 테이블(표) -->
	<table border="1" width="100%" align="center">
		<!--  각 컬럼의 이름 -->
		<tr align="center" border="1">
			<th width="10%">번호</th>
			<th width="50%">제목</th>
			<th width="15%">작성자</th>
			<th width="10%">조회수</th>
			<th width="15%">작성일</th>
			<!-- 목록의 내용 -->
		</tr>
			<%
			if (boardLists.isEmpty()) {
				// 게시물이 하나도 없을 때
			%>
		
		<tr>
			<td colspan="5" align="center">등록된 게시물이 없습니다ㅡㅡ^</td>
		</tr>
		<%
		} else {
		// 게시물이 있을 때 
		for (int i = 0; i<boardLists.size() ; i++) {
			BoardVO vo = boardLists.get(i);
		%>
		<tr align="center">
			<td><%= i+1 %></td>
			<td align="left"><a href="board/View.jsp?idx=<%=vo.getIdx()%>&i=<%=i+1%>&cate=2"><%=vo.getTitle()%></a></td>
			<td align="center"><%=dao.getName(vo.getUsercode())%></td>
			<td align="center"><%=vo.getVisitcount()%></td>
			<td align="center"><%=vo.getPostdate()%></td>
		</tr>
		<%
		}
	}
	%>
	</table>
<%@ include file="./Sidebar2.jsp" %>