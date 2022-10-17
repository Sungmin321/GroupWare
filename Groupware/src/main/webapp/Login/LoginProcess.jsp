<%@page import="userinfo.UserInfoKorVO"%>
<%@page import="userinfo.UserInfoDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String user_id = request.getParameter("user_id");
String user_pw = request.getParameter("user_pw");

// UserInfoDAO dao = UserInfoDAO.getInstance();
UserInfoDAO dao = new UserInfoDAO();
UserInfoKorVO vo = dao.getUserInfoVO(user_id, user_pw);
dao.close();

if(vo.getUser_id() != null){
	session.setAttribute("user_id", vo.getUser_id());
	session.setAttribute("user_name", vo.getUser_name());
	session.setAttribute("user_code", vo.getUser_code());
	session.setAttribute("dept_name_kor", vo.getDept_name_kor());
	session.setAttribute("pos_name_kor", vo.getPos_name_kor());
	session.setAttribute("res_name_kor", vo.getRes_name_kor());
	response.sendRedirect("../index.jsp");
}else{
	request.setAttribute("LoginErrMsg", "아이디 또는 비밀번호를 잘못 입력했습니다.<br/>입력하신 내용을 다시 확인해주세요.");
	request.getRequestDispatcher("../index.jsp").forward(request, response);
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>