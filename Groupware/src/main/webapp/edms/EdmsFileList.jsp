<%@page import="userinfo.UserInfoVO"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ include file="../Sidebar1.jsp" %>
<%@page import="board.BoardVO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../Login/IsLoggedIn.jsp" %> 
<%
request.setCharacterEncoding("utf-8");

// String edmsFile = "";
// BoardDAO dao = new BoardDAO(edmsFile);
BoardDAO dao = BoardDAO.getInstance();

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
// dao.close();
%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<meta charset="UTF-8">
<title>전자결재 - 자료실</title>
</head>
<body>
	<h3>자료실</h3>
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
					<option value="title">제목</option>
					<option value="content">내용</option>
					<option value="user_name">작성자</option>
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
			<th width="10%">번호</th>
			<th width="50%">제목</th>
			<th width="15%">작성자</th>
			<th width="10%">조회수</th>
			<th width="15%">작성일</th>
		</tr>
	</thead>
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
	
	<table class="table table-hover" width="90%">
	<thead>
		<tr align="right">
			<td style="border-bottom:none;">
<%
if(session.getAttribute("user_id") != null && !session.getAttribute("user_id").equals("null")){
	UserInfoDAO uDao = new UserInfoDAO();
	UserInfoVO uVo = uDao.getUserInfoVO(session.getAttribute("user_id").toString());

	if(uVo.getDept_id() == 1){
%>
				<button type="button" class="btn btn-primary" onclick="location.href='EdmsFileWrite.jsp';">글쓰기</button>
<%
	}	
}
%>
			</td>
		</tr>
	</thead>
	</table>
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>