<%@ include file="../Sidebar1.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="board.*" %>
 <%@ page import="java.util.*" %>
<%@ page import="utils.BoardPage"%>
 <%
	request.setCharacterEncoding("utf-8");
 	response.setContentType("text/html;charset=utf-8");
 	
 	BoardDAO dao = BoardDAO.getInstance();
//DAO를 생성해 DB에 연결

//사용자가 입력한 검색 조건을 Map에 저장
Map<String, Object> param = new HashMap<String, Object>();
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
if (searchWord != null) {
	param.put("searchField", searchField);
	param.put("searchWord", searchWord);
}
	String cate = "";
	System.out.println(session.getAttribute("cate").toString()+ " - 세션 확인");
	if ( session.getAttribute("cate").toString().length() > 0){ //0보다 크다? == 세션에 내용이 있다
		cate = (String)session.getAttribute("cate");
	}else {
	    cate = request.getParameter("cate");
	}
	

int totalCount = dao.selectCount(param, cate);
System.out.println("totalCount : "+totalCount);
int pageSize = Integer.parseInt(application.getInitParameter("POSTS_PER_PAGE"));
System.out.println("pageSize : "+pageSize);
int blockPage = Integer.parseInt(application.getInitParameter("PAGES_PER_BLOCK"));
System.out.println("blockSize : "+blockPage);
int totalPage = (int) Math.ceil((double) totalCount / pageSize); // 전체 페이지 수

//현재 페이지 확인
int pageNum = 1;
String pageTemp = request.getParameter("pageNum");
if (pageTemp != null && !pageTemp.equals(""))
	pageNum = Integer.parseInt(pageTemp); // 요청받은 페이지로 수정

//목록에 출력할 게시물 범위 계산
int start = (pageNum - 1) * pageSize + 1; // 첫 게시물 번호
int end = pageNum * pageSize; // 마지막 게시물 번호
param.put("start", start);
param.put("end", end);
//페이지 처리 end

List<BoardVO> boardLists = dao.selectListPage(param, cate);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원제 게시판</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">
</head>
<body>
	<h2>
		목록 보기(List) - 현재 페이지 :
		<%=pageNum%>
		(전체 :
		<%=totalPage%>)
	</h2>
	<!-- 검색폼 -->
	<form method="get">
		<table border="1" width="90%" align="center">
			<tr>
				<td align="center"><select name="searchField">
						<option value="title">제목
						<option value="content">내용
				</select> <input type="text" name="searchWord"> <input type="submit" value="검색하기"></td>
			</tr>
		</table>
	</form>
	<!-- 게시물 목록 테이블(표) -->


	<table border="1" width="90%" align="center">
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
		int virtualNum = 0;
		int countNum = 0;
		for (BoardVO vo : boardLists) {
			//virtualNum = totalCount--; //기존코드
			virtualNum = totalCount - (((pageNum - 1) * pageSize) + countNum++);
		%>
		<tr align="center">
			<td><%=virtualNum%></td>
			<td align="left"><a href="View.jsp?idx=<%=vo.getIdx()%>&i=<%=virtualNum%>"><%=vo.getTitle()%></a></td>
			<td align="center"><%=dao.getName(vo.getUsercode())%></td>
			<td align="center"><%=vo.getVisitcount()%></td>
			<td align="center"><%=vo.getPostdate()%></td>
		</tr>
		<%
		}
		}
		%>
	</table>
	<!--  목록 하단의 [글쓰기] 버튼 -->
	<table border="1" width="90%" align="center">
		<tr align="center">
			<!-- 페이징 처리 -->
			<td><%=BoardPage.pagingStr(totalCount, pageSize, blockPage, pageNum, request.getRequestURI())%></td>
			<!-- 글쓰기 버튼 -->
			<%
				String enpcate = session.getAttribute("cate").toString();
				String enpdept_kor = session.getAttribute("dept_name_kor").toString();
				
			if (enpcate.equals("2")){
			%>
			<td>
				<button type="button" onclick="location.href='Write.jsp';">글쓰기</button>
			</td>
			<%} // cate가 1이나 3일때는 인사팀이여야만 글쓰기가 나오게.
			else if ((enpcate.equals("1")||enpcate.equals("3")) & enpdept_kor.equals("인사팀"))  {
			%>
			<td>
				<button type="button" onclick="location.href='Write.jsp';">글쓰기</button>
			</td>
			<%
			}
			%>
		</tr>
	</table>
</body>
</html>
<%@ include file="../Sidebar2.jsp" %>