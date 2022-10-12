<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="board.*"%>
<% 
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	BoardVO vo = new BoardVO();
	BoardDAO dao = BoardDAO.getInstance();
	
	for (int i = 0; i<30 ; i++){
		vo.setCate("1");
		vo.setUsercode("201012222");
		vo.setTitle("공지사항 제목"+i);
		vo.setContent("공지사항 내용"+i);
		
		dao.insertWrite(vo);
	}
	%>
