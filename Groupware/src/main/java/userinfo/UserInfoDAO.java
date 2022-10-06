package userinfo;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import dbcon.DBConnPool;

public class UserInfoDAO extends DBConnPool {
	public UserInfoDAO() {
		super();
	}
	
//	public UserInfoVO getUserInfoVO(String user_id, String user_pw) {
//		UserInfoVO vo = new UserInfoVO();
//		
//		String query = "SELECT * FROM userinfo WHERE user_id=? AND user_pw=?";
//		
//		try {
//			psmt = con.prepareStatement(query);
//			psmt.setString(1, user_id);
//			psmt.setString(2, user_pw);
//			rs = psmt.executeQuery();
//			
//			if(rs.next()) {
//				vo.setUser_code(rs.getInt("user_code"));
//				vo.setUser_name(rs.getString("user_name"));
//				vo.setUser_id(rs.getString("user_id"));
//				vo.setUser_pw(rs.getString("user_pw"));
//				vo.setDept_id(rs.getInt("dept_id"));
//				vo.setPos_id(rs.getInt("pos_id"));
//				vo.setRes_id(rs.getInt("res_id"));
//			}
//		}catch(Exception e) {
//			e.printStackTrace();
//		}
//		
//		return vo;
//	}
	
	public UserInfoKorVO getUserInfoVO(String user_id, String user_pw) {
		UserInfoKorVO vo = new UserInfoKorVO();
		
		String query = "SELECT u.USER_CODE, u.USER_NAME, u.USER_ID, u.USER_PW,"
				+ " d.DEPT_NAME_KOR, j.POS_NAME_KOR, r.RES_NAME_KOR"
				+ " FROM USERINFO u , DEPARTMENT2 d , JOBPOSITION j , RESPONSIBILITY r"
				+ " WHERE u.DEPT_ID = d.DEPT_ID AND u.POS_ID = j.POS_ID AND u.RES_ID = r.RES_ID(+)"
				+ " AND u.user_id=? AND user_pw=?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, user_id);
			psmt.setString(2, user_pw);
			rs = psmt.executeQuery();
			
			if(rs.next()) {
				vo.setUser_code(rs.getInt("user_code"));
				vo.setUser_name(rs.getString("user_name"));
				vo.setUser_id(rs.getString("user_id"));
				vo.setUser_pw(rs.getString("user_pw"));
				vo.setDept_name_kor(rs.getString("dept_name_kor"));
				vo.setPos_name_kor(rs.getString("pos_name_kor"));
				vo.setRes_name_kor(rs.getString("res_name_kor"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return vo;
	}
	
	public UserInfoVO getUserInfoVO(String user_id) {
		UserInfoVO vo = new UserInfoVO();
		
		String query = "SELECT * FROM userinfo WHERE user_id=?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, user_id);
			rs = psmt.executeQuery();
			
			if(rs.next()) {
				vo.setUser_code(rs.getInt("user_code"));
				vo.setUser_name(rs.getString("user_name"));
				vo.setUser_id(rs.getString("user_id"));
				vo.setUser_pw(rs.getString("user_pw"));
				vo.setDept_id(rs.getInt("dept_id"));
				vo.setPos_id(rs.getInt("pos_id"));
				vo.setRes_id(rs.getInt("res_id"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return vo;
	}
	
//	public List<UserInfoKorVO> selectList(Map<String, Object> map){
	public List<UserInfoKorVO> findAll(Map<String, Object> map){
		List<UserInfoKorVO> list = new ArrayList<UserInfoKorVO>();
		
		String query = "SELECT u.USER_CODE, u.USER_NAME, u.USER_ID, u.USER_PW,"
				+ " d.DEPT_NAME_KOR, j.POS_NAME_KOR, r.RES_NAME_KOR "
				+ " FROM USERINFO u , DEPARTMENT2 d , JOBPOSITION j , RESPONSIBILITY r"
				+ " WHERE u.DEPT_ID = d.DEPT_ID AND u.POS_ID = j.POS_ID AND u.RES_ID = r.RES_ID(+)";
		if(map.get("searchWord") != null) {
			query += " AND " + map.get("searchField") + " LIKE '%" + map.get("searchWord") + "%'";
		}
		query += " ORDER BY user_name";
		
//		System.out.println(query);
		
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			
			while(rs.next()) {
				UserInfoKorVO vo = new UserInfoKorVO();
				vo.setUser_code(rs.getInt("user_code"));
				vo.setUser_name(rs.getString("user_name"));
				vo.setUser_id(rs.getString("user_id"));
				vo.setUser_pw(rs.getString("user_pw"));
				vo.setDept_name_kor(rs.getString("dept_name_kor"));
				vo.setPos_name_kor(rs.getString("pos_name_kor"));
				vo.setRes_name_kor(rs.getString("res_name_kor"));
				
				list.add(vo);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
//	public int insert(UserInfoVO vo) {
	public int addStaff(UserInfoVO vo) {
		int result = 0;
		
		String query = "INSERT INTO userinfo(user_code, user_name, user_id, user_pw, dept_id, pos_id, res_id)"
				+ " values(?, ?, ?, ?, ?, ?, ?)";
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setInt(1, vo.getUser_code());
			psmt.setString(2, vo.getUser_name());
			psmt.setString(3, vo.getUser_id());
			psmt.setString(4, vo.getUser_pw());
			psmt.setInt(5, vo.getDept_id());
			psmt.setInt(6, vo.getPos_id());
			psmt.setInt(7, vo.getRes_id());
			
			result = psmt.executeUpdate();

		}catch(Exception e){
			e.printStackTrace();
		}
		
		return result;
	}
	
//	public int insertIdNull(UserInfoVO vo) {
	public int addStaffIdNull(UserInfoVO vo) {
		int result = 0;
		
		String query = "INSERT INTO userinfo(user_code, user_name, user_id, user_pw, dept_id, pos_id)"
				+ " values(?, ?, ?, ?, ?, ?)";
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setInt(1, vo.getUser_code());
			psmt.setString(2, vo.getUser_name());
			psmt.setString(3, vo.getUser_id());
			psmt.setString(4, vo.getUser_pw());
			psmt.setInt(5, vo.getDept_id());
			psmt.setInt(6, vo.getPos_id());
			
			result = psmt.executeUpdate();
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return result;
	}
	
//	public int update(UserInfoVO vo) {
	public int modifyStaff(UserInfoVO vo) {
		int result = 0;
		
		String query = "UPDATE userinfo"
				+ " SET user_code = ?, user_name = ?, user_id = ?, user_pw = ?, dept_id = ?, pos_id = ?, res_id = ?"
				+ " WHERE user_code = ?";
		
//		System.out.println(query);
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setInt(1, vo.getUser_code());
			psmt.setString(2, vo.getUser_name());
			psmt.setString(3, vo.getUser_id());
			psmt.setString(4, vo.getUser_pw());
			psmt.setInt(5, vo.getDept_id());
			psmt.setInt(6, vo.getPos_id());
			psmt.setInt(7, vo.getRes_id());
			psmt.setInt(8, vo.getUser_code());
			
			result = psmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}

//		System.out.println(query);
		
		return result;
	}
	
//	public int updateIdNull(UserInfoVO vo) {
	public int modifyStaffIdNull(UserInfoVO vo) {
		int result = 0;
		
		String query = "UPDATE userinfo"
				+ " SET user_code = ?, user_name = ?, user_id = ?, user_pw = ?, dept_id = ?, pos_id = ?, res_id = null"
				+ " WHERE user_code = ?";
		
		System.out.println(query);
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setInt(1, vo.getUser_code());
			psmt.setString(2, vo.getUser_name());
			psmt.setString(3, vo.getUser_id());
			psmt.setString(4, vo.getUser_pw());
			psmt.setInt(5, vo.getDept_id());
			psmt.setInt(6, vo.getPos_id());
			psmt.setInt(7, vo.getUser_code());
			
			result = psmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
}
