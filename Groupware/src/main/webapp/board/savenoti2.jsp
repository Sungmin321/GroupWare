<% 
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");

session.setAttribute("cate", "2");

request.getRequestDispatcher("List.jsp").forward(request, response);
%>