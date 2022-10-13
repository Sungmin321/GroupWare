<%@ include file="../Sidebar1.jsp" %>
<%@page import="board.BoardVO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");

String edmsFile = "";
BoardDAO dao = new BoardDAO(edmsFile);

Map<String, Object> map = new HashMap<String, Object>();
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
if (searchWord != null) {
	map.put("searchField", searchField);
	map.put("searchWord", searchWord);
}

String cate = "3";

int totalCount = dao.selectCountFile(map, cate);

System.out.println("totalCount : "+totalCount);

// List<BoardVO> boardLists = dao.selectListPage(map, cate); // 추후 페이징 처리 후에 이 메서드로 수정
List<BoardVO> boardLists = dao.selectList(map, cate);
dao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전자결재 - 자료실</title>
</head>
<body>
	<h2>자료실</h2>
	<form method="get">
	<table border="1" width="90%">
		<tr>
			<td align="center">
				<select name="searchField">
					<option value="title">제목</option>
					<option value="content">내용</option>
					<option value="user_name">작성자</option>
				</select>
				<input type="text" name="searchWord"/>
				<input type="submit" value="검색"/>
			</td>
		</tr>
	</table>
	</form>
	
	<table border="1" width="90%">
		<tr>
			<th width="10%">번호</th>
			<th width="50%">제목</th>
			<th width="15%">작성자</th>
			<th width="10%">조회수</th>
			<th width="15%">작성일</th>
		</tr>
<%
if(boardLists.isEmpty()){	
%>		<tr>
			<td colspan="5" align="center">
				등록된 게시물이 없습니다.
			</td>
		</tr>
<%
}else{
	int virtualNum = 0;
	for(BoardVO vo : boardLists){
		virtualNum = totalCount--;
%>		
		<tr>
			<td align="center"><%= virtualNum %></td>
			<td align="center"><a href="EdmsFileView.jsp?idx=<%= vo.getIdx() %>"><%= vo.getTitle() %></a></td>
			<td align="center"><%= vo.getUser_name() %></td>
			<td align="center"><%= vo.getVisitcount() %></td>
			<td align="center"><%= vo.getPostdate() %></td>
		</tr>
<%
	}
}
%>		
	</table>
	
	<table width="90%">
		<tr align="right">
			<td>
				<button type="button" onclick="location.href='EdmsFileWrite.jsp';">글쓰기</button>
			</td>
		</tr>
	</table>
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>