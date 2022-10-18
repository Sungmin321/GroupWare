
    </div>
  </div>
        <div class="sidebar">
            <div class="profile">
                <img src="https://yt3.ggpht.com/ytc/AMLnZu-7OpiH7MOmo-4njrAr2L0OmJVF7j7dBJLvdcFHnQ=s900-c-k-c0x00ffffff-no-rj" alt="profile_picture">
<%--                 <h3><%= session.getAttribute("user_name").toString() %></h3> --%>
<%--                 <p><%= session.getAttribute("dept_name_kor").toString() %></p> --%>
 <%
 if(session.getAttribute("user_name") != null && !session.getAttribute("user_name").equals("null")){
 %>
                <h3><%= session.getAttribute("user_name").toString() %></h3>
 <%
 }else{
 %>
                <h3>정보 없음</h3>
 <%
 }
 
 if(session.getAttribute("dept_name_kor") != null && !session.getAttribute("dept_name_kor").equals("null")){
 %>
                <p><%= session.getAttribute("dept_name_kor").toString() %></p>
 <%
 }else{
 %>
                <h3>정보 없음</h3>
 <%
 }
 %>
            </div>
            <ul>
                <li>
                    <a href="/Groupware/main.jsp" class="active">
                        <span class="icon"><i class="fas fa-home"></i></span>
                        <span class="item">Home</span>
                    </a>
                </li>
        
                <li>
                    <a href="/Groupware/board/savenoti.jsp">
                        <span class="icon"><i class="fas fa-podcast"></i></span>
                        <span class="item">공지사항</span>
                    </a>
                </li>
                
                <li class="menu_1">
                    <a href="#">
                        <span class="icon"><i class="fas fa-envelope"></i></span>
                        <span class="item">전자메일</span>
                          <a class="sub_1" href="/Groupware/mail/MailWrite.jsp?status=1" style="font-size: 12px"><i class="fas fa-edit"></i>&nbsp;메일쓰기</a>
                      	  <a class="sub_1" href="/Groupware/mail/MailList.jsp?status=2" style="font-size: 12px"><i class="fas fa-envelope-open"></i>&nbsp;받은메일함</a>
                      	  <a class="sub_1" href="/Groupware/mail/MailList.jsp?status=3" style="font-size: 12px"><i class="fas fa-share"></i>&nbsp;보낸메일함</a>
                      	  <a class="sub_1" href="/Groupware/mail/MailList.jsp?status=4" style="font-size: 12px"><i class="fas fa-share"></i>&nbsp;임시보관함</a>
                      	  <a class="sub_1" href="/Groupware/mail/MailList.jsp?status=5" style="font-size: 12px"><i class="fas fa-trash"></i>&nbsp;휴지통</a>
                    </a>
                </li>

                <li class="menu_2">
                    <a>
                        <span class="icon"><i class="fas fa-clipboard"></i></span>
                        <span class="item">전자결재</span>
                      	  <a class="sub_2" href="/Groupware/edms/EdmsApproval.jsp" style="font-size: 12px"><i class="fas fa-edit"></i>&nbsp;전자결재 상신</a>
                      	  <a class="sub_2" href="/Groupware/edms/EdmsList.jsp" style="font-size: 12px"><i class="fas fa-list"></i>&nbsp;리스트</a>
                      	  <a class="sub_2" href="/Groupware/edms/EdmsApprovalWaitingList.jsp" style="font-size: 12px"><i class="fas fa-outdent"></i>&nbsp;승인대기</a>
                      	  <a class="sub_2" href="/Groupware/edms/EdmsFileList.jsp" style="font-size: 12px"><i class="fas fa-cubes"></i>&nbsp;자료실</a>
                    </a>
                </li>
                
                <li>
                    <a href="/Groupware/board/savenoti2.jsp">
                        <span class="icon"><i class="fas fa-users"></i></span>
                        <span class="item">게시판</span>
                    </a>
                </li>
                <li>
                    <a href="/Groupware/hrms/List.jsp">
                        <span class="icon"><i class="fas fa-address-card"></i></span>
                        <span class="item">직원관리</span>
                    </a>
                </li>
            </ul>
        </div>
        
    </div>
	<script>
	  var hamburger = document.querySelector(".hamburger");
	  hamburger.addEventListener("click", function(){
	    document.querySelector("body").classList.toggle("active");
	  })
	  
	   $(document).ready(function(){

 	    $('.sub_1').hide();
 	    $('.sub_2').hide();

		$('.menu_1').mouseover(function(){
			$('.sub_1').slideDown();

		});
		$('.menu_1').mouseleave(function(){
			$('.sub_1').hide();
		});

		$('.menu_2').mouseover(function(){
			$('.sub_2').slideDown();

		});
		$('.menu_2').mouseleave(function(){
			$('.sub_2').hide();
		});
	});
	</script>
	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
</body>
</html>