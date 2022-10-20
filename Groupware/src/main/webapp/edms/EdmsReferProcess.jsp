<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="edms.*"%>
<%@ page import="java.util.*"%>
<%
System.out.println("EdmsReferProcess.jsp 페이지");

EdmsDAO edmsdao = EdmsDAO.getInstance();

request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
String user_code = session.getAttribute("user_code").toString();

//임시 테스트 이한목 코드
// String user_code = "201012002";
String idx = request.getParameter("idx");

int result = edmsdao.updateReferConfirmed(user_code, idx);

System.out.println("result : " + result);

if (result>0){
	%> 
	<script type="text/javascript">
	alert('반려 완료');
	</script>
	<%	
	}

request.getRequestDispatcher("EdmsApprovalWaitingView.jsp").forward(request, response);
%>