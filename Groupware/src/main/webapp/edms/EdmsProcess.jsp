<%@page import="org.apache.catalina.tribes.util.Arrays"%>
<%@page import="edms.*"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="attachedfile.AttachedFileVO"%>
<%@ include file="../Login/IsLoggedIn.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%! EdmsDAO edmsdao = EdmsDAO.getInstance(); %>
	<% 
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	
// 	String saveDirectory = application.getRealPath("/Uploads");
	String saveDirectory = "C:/Program Files/Apache Software Foundation/Tomcat 9.0/webapps/ROOT/Uploads";
	
	int maxPostSize = 1024 * 1000 * 10; // 10MB
	String encoding = "UTF-8";
	
	MultipartRequest multipartrequest = new MultipartRequest(request, saveDirectory, maxPostSize, encoding);
	
	String user_code = session.getAttribute("user_code").toString();
	// String user_code = "200205001"; // 임시로 홍길동 코드 사용
	String title = multipartrequest.getParameter("title"); 
	String doctype = multipartrequest.getParameter("cate");
	String ofile = multipartrequest.getFilesystemName("ofile");
	
	String[] name = multipartrequest.getParameterValues("name");
	String[] code = multipartrequest.getParameterValues("code");
	String[] deptkr = multipartrequest.getParameterValues("deptkr");
	String[] poskr = multipartrequest.getParameterValues("poskr");
	String[] contents = multipartrequest.getParameterValues("content");
	
	boolean flag = true;
	
	for (int i = code.length-1 ; i>0 ; i--){
		 // i 하위  i-1 상위
		 String hist = code[i-1].substring(0, code[i-1].length()-1);
		 String rowst = code[i].substring(0, code[i].length()-1);
		 int hi = edmsdao.getJobposnum(hist);
		 int row = edmsdao.getJobposnum(rowst);
		 if (hi <= row){ 
			 // 트루조건. 1이 사장이고 11이 인턴이니 리턴 int값이 작을수록 직위가 높은거임.
		 }else{
			 flag = false;
			 break;
		 }
	}
	
 	 if (flag) { //부장이 0에 들어가있고, 진행되면서 뒷쪽에 부하직원들 들어가있음.
 		 String codes = "";
 	 	 String confirmeds = "";
		 String content = "";
		 
 	 	 for (int i = 0; i < name.length; i++){ 
			 codes += code[i];
			 confirmeds += "1/";
		}
 	 	 
 	 	 for (int i = 0; i < contents.length; i++){ // 내용. 내용인데 1에서 5까지 있을수도 있고 없을수도 있기에 따로 for 문을 작성함.
 	 		 if (contents[i].length() > 0){
	 	 		 content += contents[i]+"`";
 	 		 }else
 	 			 break;
 	 	 }
		codes = codes.substring(0, codes.length()-1); 
		confirmeds = confirmeds.substring(0,confirmeds.length()-1); 
		// /를 기준으로 받아오고
		content = content.substring(0,content.length()-1); 
		// 내용은 `를 기준으로 자른다.
		
		EdmsVO eiv = new EdmsVO();
		eiv.setUser_code(user_code);
		eiv.setTitle(title);
		eiv.setLine(codes);
		eiv.setConfirmed(confirmeds);
		eiv.setDoctype(doctype);
		eiv.setContent(content);
		
		int result = edmsdao.insertEdms(eiv);
		
		if (result == 1){ // 인서트에 성공했다면
 			int idx = edmsdao.getIdx(eiv);
			//idx 가져오기
			if(ofile == null){ // 파일이 없을때 여기서 끝나게.
			%>
			<script>
				alert("전자결재 상신 완료");
	 			location.href= "EdmsList.jsp";
	 		</script>
			<%
			}
			
			int uploadFileResult = 0;
			if(ofile != null ){
			// 파일이 있다면 파일까지 첨부하기.
			
			
				try{
					
					String ext = ofile.substring(ofile.lastIndexOf("."));
					String sfile = idx + ext; // 새로운 파일 이름("idx.확장자")

					File oldFile = new File(saveDirectory + File.separator + ofile);
					File newFile = new File(saveDirectory + File.separator + sfile);
					oldFile.renameTo(newFile);

					AttachedFileVO fVo = new AttachedFileVO();
					fVo.setIdx(idx);
					fVo.setOfile(ofile);
					fVo.setSfile(sfile);

// 					AttachedFileDAO fDao = new AttachedFileDAO();
					AttachedFileDAO fDao = AttachedFileDAO.getInstance();
					uploadFileResult = fDao.inputFile(fVo);
// 					fDao.close();
				}catch(Exception e){
					e.printStackTrace();
				}
			 	//	request.getRequestDispatcher("EdmsList.jsp").forward(request, response);
			} 
			if (ofile != null && uploadFileResult == 1){ // 첨부파일이 있고 업로드 성공한 경우
				//request.getRequestDispatcher("EdmsList.jsp").forward(request, response);
				%>
				<script>
				alert("전자결재 상신 완료(file)");
	 			location.href= "EdmsList.jsp";
	 			</script>
				<%
				//response.sendRedirect("EdmsList.jsp");
			}else {
				%>
				<script>
				alert("파일업로드실패");
	 			location.href= "EdmsApproval.jsp";
	 		 	</script>
				<%
			}
		
		}
	}
	else{ // 인서트에 실패했다면.
		%>
		<script>
		alert("전자결재 상신 실패 - 결재라인을 다시 설정해주세요.");
	 	location.href= "EdmsApproval.jsp";
	 	</script>
		<%
			//out.println("<script  type='text/javascript'>alert('저장되셨습니다');</script>");
			//out.println("<script>alert('전자결재 상신 실패 - 결재라인을 다시 설정해주세요.');</script>");
			//response.sendRedirect("EdmsApproval.jsp");
	}
	%>