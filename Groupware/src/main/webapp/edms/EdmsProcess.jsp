<%@page import="edms.*"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="attachedfile.AttachedFileDAO"%>
<%@page import="attachedfile.AttachedFileVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%! EdmsDAO edmsdao = EdmsDAO.getInstance(); %>
	<% 
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	
	String saveDirectory = application.getRealPath("/Uploads");
	
	int maxPostSize = 1024 * 1000 * 10; // 10MB
	String encoding = "UTF-8";
	
	MultipartRequest multipartrequest = new MultipartRequest(request, saveDirectory, maxPostSize, encoding);
	
	String user_code = "200205001"; // 임시로 홍길동 코드 사용
	String title = multipartrequest.getParameter("title"); 
	String doctype = multipartrequest.getParameter("cate");
	String ofile = multipartrequest.getFilesystemName("ofile");
	
	String[] name = multipartrequest.getParameterValues("name");
	String[] code = multipartrequest.getParameterValues("code");
	String[] deptkr = multipartrequest.getParameterValues("deptkr");
	String[] poskr = multipartrequest.getParameterValues("poskr");
	String[] contents = multipartrequest.getParameterValues("content");
	
 	 if (name != null) { //부장이 0에 들어가있고, 진행되면서 뒷쪽에 부하직원들 들어가있음.
 		 String codes = "";
 	 	 String confirmeds = "";
		 String content = "";
		 
 	 	 for (int i = 0; i < name.length; i++){ 
			 codes += code[i];
			 confirmeds += "1/";
		}
 	 	 
 	 	 for (int i = 0; i < contents.length; i++){
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
		%>
		<script type="text/javascript">
		alert('전자결재 상신 성공');
		</script>
		<%
			
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

					AttachedFileDAO fDao = new AttachedFileDAO();
					uploadFileResult = fDao.inputFile(fVo);
					fDao.close();
				}catch(Exception e){
					e.printStackTrace();
				}
			 	//	request.getRequestDispatcher("EdmsList.jsp").forward(request, response);
			} 
			if (ofile != null && uploadFileResult == 1){ // 첨부파일이 있고 업로드 성공한 경우
				request.getRequestDispatcher("EdmsList.jsp").forward(request, response);
			}else {
				%>
				<script type="text/javascript">
				alert('파일 업로드에 실패하였습니다.');
				</script>
				<%
				request.getRequestDispatcher("EdmsApproval.jsp").forward(request, response);
			}
		
		}else{ // 인서트에 실패했다면.
			%>
			
			<script type="text/javascript">
				alert('전자결재 상신 실패 - 다시 상신해주세요.')
			</script>
			 
			<% 
			response.sendRedirect("EdmsApproval.jsp");
			
		}
	}
	%>