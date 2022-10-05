package myServlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import edms.EdmsDAO;
import edms.EdmsInfoVO;

//@WebServlet("/UserSearchServlet")
public class UserSearchServlet extends HttpServlet {
		EdmsDAO edao = EdmsDAO.getInstance();
	public UserSearchServlet() {
		System.out.println("서블릿객체생성");
		// TODO Auto-generated constructor stub
	}
		
		
	private static final long serialVersionUID = 1L;
       
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("DOPOST 실행됨.");
		
		String cate = request.getParameter("cate");
		String searchword = request.getParameter("searchword");
		System.out.println(cate);
		System.out.println(searchword);
		
		ArrayList<EdmsInfoVO> list = edao.findList(cate, searchword);
		System.out.println("여기까지");
		JSONArray jarray = new JSONArray();
		for (EdmsInfoVO vo : list ) {
			System.out.println("여기까지2");
			JSONObject json = new JSONObject();
			json.put("name", vo.getName());
			json.put("code", vo.getCode());
			json.put("deptkr", vo.getDeptkr());
			json.put("poskr", vo.getPoskr());
			
			jarray.add(json);
		}
		System.out.println("여기까지3");
		
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		response.getWriter().print(jarray.toJSONString());
		
	}

}