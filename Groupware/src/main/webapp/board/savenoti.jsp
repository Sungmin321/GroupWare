<% 
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");

session.setAttribute("cate", "1");

request.setAttribute("cate", "1");

request.getRequestDispatcher("List.jsp").forward(request, response);
%>