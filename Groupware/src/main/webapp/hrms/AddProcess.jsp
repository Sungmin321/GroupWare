<%@page import="userinfo.UserInfoDAO"%>
<%@page import="userinfo.UserInfoVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String user_name = request.getParameter("user_name");
String user_id = request.getParameter("user_id");
String user_pw = request.getParameter("user_pw");
int user_code = Integer.parseInt(request.getParameter("user_code"));
int dept_id = Integer.parseInt(request.getParameter("dept_id"));
int pos_id = Integer.parseInt(request.getParameter("pos_id"));
int res_id = Integer.parseInt(request.getParameter("res_id"));

UserInfoVO vo = new UserInfoVO();
vo.setUser_name(user_name);
vo.setUser_id(user_id);
vo.setUser_pw(user_pw);
vo.setUser_code(user_code);
vo.setDept_id(dept_id);
vo.setPos_id(pos_id);
vo.setRes_id(res_id);

// UserInfoDAO dao = UserInfoDAO.getInstance();
UserInfoDAO dao = new UserInfoDAO();

int result;

if(res_id != 0){ // 직책이 있을때
	result = dao.addStaff(vo);	
}else{ // 직책이 없을때
	result = dao.addStaffIdNull(vo);
}

dao.close();

if(result == 1){
%>	
	<script>
		alert('등록되었습니다.');
		location.href='List.jsp';
	</script>
<% 
// 	response.sendRedirect("List.jsp");
}else{
%>
	<script>
		alert('등록에 실패하였습니다.');
		history.back();
	</script>
<% 	
}
%>