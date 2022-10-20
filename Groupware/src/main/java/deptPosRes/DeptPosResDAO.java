package deptPosRes;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import dbcon.DBConnPool;

public class DeptPosResDAO extends DBConnPool{
//	public DeptPosResDAO() {
//		super();
//	}
	
	private static DeptPosResDAO instance = new DeptPosResDAO();

	private DeptPosResDAO() {
		
	}

	public static DeptPosResDAO getInstance() {
		return instance;
	}
	
	public List<DeptPosResVO> selectList(String tableName){
		List<DeptPosResVO> list = new ArrayList<DeptPosResVO>();
		
		String query = "SELECT * from " + tableName;
		
		try{
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			
			while(rs.next()) {
				DeptPosResVO vo = new DeptPosResVO();
				
				vo.setId(rs.getInt(1));
				vo.setName(rs.getString(2));
				vo.setName_kor(rs.getString(3));
				
				list.add(vo);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			
		}finally {
			try {
				if (stmt != null) {
					stmt.close();
				}
				if (psmt != null) {
					psmt.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		
		return list;
	}
}
